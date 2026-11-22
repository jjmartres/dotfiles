function clean_storage --description "Libère de l'espace disque : caches d'outils, providers Terraform, logs gcloud (+ Docker, node_modules/.venv en option)"
    set -l dry_run 0
    set -l assume_yes 0
    set -l with_docker 0
    set -l with_deps 0
    set -l root $HOME/Repositories
    set -l schedule ""
    set -l job_flags

    # Repos dont les dépendances servent à des outils actifs (agents, serveurs MCP) : --deps n'y touche pas.
    # Surchargeable : set -U CLEAN_STORAGE_KEEP perso/farnswrth perso/mon-outil
    set -l keep perso/farnswrth perso/ai-coding-agents perso/nebulis perso/reachy-mcp-server perso/opencode-cost-guard perso/hawking perso/dotfiles perso/astroagent
    if set -q CLEAN_STORAGE_KEEP
        set keep $CLEAN_STORAGE_KEEP
    end

    set -l i 1
    while test $i -le (count $argv)
        switch $argv[$i]
            case -n --dry-run
                set dry_run 1
            case -y --yes
                set assume_yes 1
            case --docker
                set with_docker 1
                set -a job_flags --docker
            case --deps
                set with_deps 1
                set -a job_flags --deps
            case --all
                set with_docker 1
                set with_deps 1
                set -a job_flags --all
            case --path
                set i (math $i + 1)
                if test $i -gt (count $argv); or not test -d "$argv[$i]"
                    set_color red
                    echo "--path attend un dossier existant"
                    set_color normal
                    return 1
                end
                set root (realpath $argv[$i])
                set -a job_flags --path $root
            case --schedule
                set schedule install
            case --unschedule
                set schedule uninstall
            case -h --help
                echo "Usage: clean_storage [--dry-run] [--yes] [--docker] [--deps] [--all] [--path DIR]"
                echo "       clean_storage --schedule [--docker] [--deps] [--all] [--path DIR]"
                echo "       clean_storage --unschedule"
                echo ""
                echo "Toujours :"
                echo "  - .terraform/providers copiés en dur sous DIR (re-liés depuis ~/.terraform.d/plugin-cache au prochain init)"
                echo "  - logs gcloud, caches uv / npm / trivy / pre-commit / Go / brew / Cypress / puppeteer / poetry / pip / virtualenv"
                echo "  - VACUUM de ~/.local/share/opencode/opencode.db (si opencode n'est pas lancé)"
                echo "Options :"
                echo "  --docker    docker system prune -a (garde volumes et conteneurs actifs) + fstrim de la VM colima"
                echo "  --deps      node_modules et .venv sous DIR, sauf repos de CLEAN_STORAGE_KEEP"
                echo "  --all       --docker + --deps"
                echo "  --path DIR  racine des repos (défaut : ~/Repositories)"
                echo "  --dry-run   affiche seulement ce qui serait libéré"
                echo "  --yes       ne demande pas de confirmation"
                echo "  --schedule  lance clean_storage --yes (+ options données) le 1er et le 16 du mois à 12:30 (launchd)"
                echo "              log : ~/.local/share/clean_storage/clean_storage.log"
                echo "  --unschedule  retire la tâche planifiée"
                echo ""
                echo "Jamais : ~/Library/Caches/Google, données utilisateur, volumes Docker."
                return 0
            case '*'
                set_color red
                echo "Option inconnue : $argv[$i] (clean_storage --help)"
                set_color normal
                return 1
        end
        set i (math $i + 1)
    end

    # --- Planification launchd (macOS) ------------------------------------
    if test -n "$schedule"
        if not type -q launchctl
            set_color red
            echo "La planification utilise launchd (macOS uniquement)"
            set_color normal
            return 1
        end
        set -l label local.clean_storage
        set -l plist $HOME/Library/LaunchAgents/$label.plist
        set -l domain gui/(id -u)
        launchctl bootout $domain/$label >/dev/null 2>&1

        if test $schedule = uninstall
            rm -f $plist
            echo "Tâche planifiée retirée."
            return 0
        end

        set -l log_dir $HOME/.local/share/clean_storage
        command mkdir -p $log_dir $HOME/Library/LaunchAgents
        set -l cmd "date; clean_storage --yes"
        for f in $job_flags
            set cmd "$cmd "(string escape -- $f)
        end
        set -l days
        for d in 1 16
            set -a days "    <dict><key>Day</key><integer>$d</integer><key>Hour</key><integer>12</integer><key>Minute</key><integer>30</integer></dict>"
        end
        printf '%s\n' \
            '<?xml version="1.0" encoding="UTF-8"?>' \
            '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">' \
            '<plist version="1.0"><dict>' \
            "  <key>Label</key><string>$label</string>" \
            "  <key>ProgramArguments</key><array><string>"(command -s fish)"</string><string>-c</string><string>$cmd</string></array>" \
            '  <key>StartCalendarInterval</key><array>' \
            $days \
            '  </array>' \
            '  <key>Nice</key><integer>10</integer>' \
            '  <key>LowPriorityIO</key><true/>' \
            '  <key>ProcessType</key><string>Background</string>' \
            "  <key>StandardOutPath</key><string>$log_dir/clean_storage.log</string>" \
            "  <key>StandardErrorPath</key><string>$log_dir/clean_storage.log</string>" \
            '</dict></plist>' >$plist
        if not launchctl bootstrap $domain $plist
            set_color red
            echo "launchctl bootstrap a échoué ($plist)"
            set_color normal
            return 1
        end
        set_color green
        echo "Planifié : fish -c '$cmd'"
        set_color normal
        echo "Le 1er et le 16 du mois à 12:30 (rattrapé au réveil si le Mac dormait)"
        echo "Log : $log_dir/clean_storage.log"
        return 0
    end

    # --- Inventaire -------------------------------------------------------
    set_color --bold
    echo "Analyse de l'espace récupérable…"
    set_color normal

    set -l labels
    set -l sizes

    # Providers Terraform copiés (pas des symlinks vers le cache)
    set -l tf_dirs
    for d in (find $root -type d -name .terraform -prune 2>/dev/null)
        if test -d $d/providers; and test (count (find $d/providers -type f -name 'terraform-provider-*' -print -quit 2>/dev/null)) -gt 0
            set -a tf_dirs $d/providers
        end
    end
    set -l kb 0
    if test (count $tf_dirs) -gt 0
        set kb (du -sk $tf_dirs 2>/dev/null | awk '{s+=$1} END {print s+0}')
    end
    set -a labels "Providers Terraform ("(count $tf_dirs)" dossiers)"
    set -a sizes $kb

    # Caches simples (dossiers supprimés tels quels)
    set -l cache_dirs $HOME/.config/gcloud/logs $HOME/Library/Caches/Cypress $HOME/.cache/puppeteer $HOME/Library/Caches/pypoetry $HOME/Library/Caches/virtualenv $HOME/Library/Caches/pip $HOME/go/pkg/mod
    for d in $cache_dirs
        if test -d $d
            set -a labels (string replace $HOME '~' $d)
            set -a sizes (du -sk $d 2>/dev/null | awk '{print $1+0}')
        end
    end

    # Caches gérés par leur outil
    set -l tool_caches \
        "uv|$HOME/.cache/uv" \
        "npm|$HOME/.npm/_cacache" \
        "trivy|$HOME/Library/Caches/trivy" \
        "pre-commit|$HOME/.cache/pre-commit"
    if type -q go
        set -a tool_caches "go|"(go env GOMODCACHE)
    end
    if type -q brew
        set -a tool_caches "brew|"(brew --cache)
    end
    for entry in $tool_caches
        set -l parts (string split -m1 '|' $entry)
        if type -q $parts[1]; and test -d "$parts[2]"
            set -a labels "Cache $parts[1]"
            set -a sizes (du -sk $parts[2] 2>/dev/null | awk '{print $1+0}')
        end
    end

    # Pages libres de la base opencode (rendues par VACUUM, aucune session supprimée)
    set -l opencode_db $HOME/.local/share/opencode/opencode.db
    if test -f $opencode_db; and type -q sqlite3
        set -a labels "opencode.db (pages libres, VACUUM)"
        set -a sizes (sqlite3 $opencode_db "select freelist_count * page_size / 1024 from pragma_freelist_count, pragma_page_size;" 2>/dev/null; or echo 0)
    end

    # node_modules / .venv (option)
    set -l dep_dirs
    if test $with_deps -eq 1
        set -l keep_re (string join '|' (string escape --style=regex -- $keep))
        for d in (find $root \( -name node_modules -o -name .venv \) -type d -prune 2>/dev/null)
            set -l rel (string replace "$root/" '' $d)
            if test -n "$keep_re"; and string match -qr "^($keep_re)/" -- $rel
                continue
            end
            set -a dep_dirs $d
        end
        set kb 0
        if test (count $dep_dirs) -gt 0
            set kb (du -sk $dep_dirs 2>/dev/null | awk '{s+=$1} END {print s+0}')
        end
        set -a labels "node_modules / .venv ("(count $dep_dirs)" dossiers)"
        set -a sizes $kb
    end

    # Docker (option)
    set -l docker_ok 0
    if test $with_docker -eq 1
        if type -q docker; and docker info >/dev/null 2>&1
            set docker_ok 1
            set -a labels "Docker (images, cache, conteneurs arrêtés ; au moins)"
            # Volumes exclus : prune ne les supprime pas
            set -a sizes (docker system df --format '{{.Type}}|{{.Reclaimable}}' 2>/dev/null | awk -F'|' '
                $1 == "Local Volumes" {next}
                {split($2, a, " "); v = a[1] + 0}
                a[1] ~ /kB$/ {s += v} a[1] ~ /MB$/ {s += v * 1024} a[1] ~ /GB$/ {s += v * 1048576} a[1] ~ /TB$/ {s += v * 1073741824}
                END {printf "%d", s}')
        else
            set_color yellow
            echo "Docker indisponible (colima arrêté ?) : ignoré"
            set_color normal
        end
    end

    # --- Rapport ----------------------------------------------------------
    echo ""
    set -l total 0
    for j in (seq (count $labels))
        set total (math $total + $sizes[$j])
        printf "  %8.1f Go  %s\n" (math $sizes[$j] / 1048576) $labels[$j]
    end
    set_color --bold
    printf "  %8.1f Go  total estimé\n" (math $total / 1048576)
    set_color normal
    if test $with_docker -eq 1
        set_color brblack
        echo "  (Docker sous-estimé : les couches partagées et l'espace rendu par fstrim ne sont pas comptés)"
        set_color normal
    end

    if test $dry_run -eq 1
        return 0
    end
    if test $assume_yes -eq 0
        read -l -P "Nettoyer ? [o/N] " answer
        if not string match -qi -r '^(o|oui|y|yes)$' -- $answer
            echo "Annulé."
            return 0
        end
    end

    # --- Nettoyage --------------------------------------------------------
    set -l free_before (df -k $HOME | awk 'NR==2 {print $4}')

    for d in $tf_dirs
        rm -rf -- $d
    end
    command mkdir -p $HOME/.terraform.d/plugin-cache

    for d in $cache_dirs
        if test -d $d
            chmod -R u+w $d 2>/dev/null
            rm -rf -- $d
        end
    end
    command mkdir -p $HOME/.config/gcloud/logs

    if type -q uv
        # Un serveur MCP lancé par uvx garde le verrou : ne pas bloquer 5 min
        if not env UV_LOCK_TIMEOUT=10 uv cache prune >/dev/null 2>&1
            set_color yellow
            echo "uv : cache verrouillé par un process uv/uvx en cours, ignoré"
            set_color normal
        end
    end
    type -q npm; and npm cache clean --force >/dev/null 2>&1
    type -q trivy; and trivy clean --all >/dev/null 2>&1
    type -q pre-commit; and pre-commit gc >/dev/null 2>&1
    type -q go; and go clean -modcache >/dev/null 2>&1
    type -q brew; and brew cleanup -s --prune=all >/dev/null 2>&1

    if test -f $opencode_db; and type -q sqlite3
        if pgrep -x opencode >/dev/null
            set_color yellow
            echo "opencode est lancé : VACUUM de opencode.db ignoré"
            set_color normal
        else
            sqlite3 $opencode_db "pragma wal_checkpoint(TRUNCATE); vacuum;" >/dev/null 2>&1
        end
    end

    for d in $dep_dirs
        rm -rf -- $d
    end

    if test $docker_ok -eq 1
        docker system prune -a -f >/dev/null 2>&1
        if type -q colima; and colima status >/dev/null 2>&1
            colima ssh -- sudo fstrim -a >/dev/null 2>&1
        end
    end

    set -l free_after (df -k $HOME | awk 'NR==2 {print $4}')
    echo ""
    set_color green
    printf "Libéré : %.1f Go  (libre : %.0f Go)\n" (math "max(0, $free_after - $free_before) / 1048576") (math $free_after / 1048576)
    set_color normal
    return 0
end
