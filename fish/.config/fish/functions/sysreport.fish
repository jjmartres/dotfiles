function sysreport --description "Rapports de charge machine (CPU / RAM / disque / process / dossiers) via sysstats"
    set -l bin $HOME/.local/bin/sysstats
    if not test -x $bin
        set_color red
        echo "sysstats introuvable : $bin"
        set_color normal
        echo "Déploie le package : stow -R sysstats  (depuis le repo dotfiles)"
        return 1
    end

    set -l cmd report
    set -l rest $argv
    if test (count $argv) -gt 0; and not string match -q -- '-*' $argv[1]
        set cmd $argv[1]
        set rest $argv[2..-1]
    end

    switch $cmd
        case report r
            /usr/bin/python3 $bin report $rest
        case last runs status s
            /usr/bin/python3 $bin status
        case open o
            open (/usr/bin/python3 $bin path)
        case latest l
            set -l dir (/usr/bin/python3 $bin path)
            set -l latest (command ls -t $dir/*.html 2>/dev/null)[1]
            if test -z "$latest"
                set_color yellow
                echo "Aucun rapport dans $dir"
                set_color normal
                return 1
            end
            echo $latest
            open $latest
        case list ls
            set -l dir (/usr/bin/python3 $bin path)
            set -l files (command ls -t $dir/*.html 2>/dev/null)
            if test (count $files) -eq 0
                echo "Aucun rapport dans $dir"
                return 0
            end
            for f in $files
                set_color brblack
                printf "%s  " (date -r (stat -f %m $f) "+%a %d/%m %H:%M")
                set_color normal
                echo (basename $f)
            end
        case install
            /usr/bin/python3 $bin install
        case uninstall
            /usr/bin/python3 $bin uninstall
        case -h --help help
            echo "Usage: sysreport [report] [--days N | --hours N | --date AAAA-MM-JJ] [--no-open]"
            echo "       sysreport last        derniers runs (collecte, scan, rapports) et état launchd"
            echo "       sysreport open        ouvre le dossier des rapports"
            echo "       sysreport latest      ouvre le dernier rapport"
            echo "       sysreport list        liste les rapports"
            echo "       sysreport install     active les tâches launchd (5 min + quotidien 23:55)"
            echo "       sysreport uninstall   retire les tâches launchd (garde les données)"
            echo ""
            echo "Exemples:"
            echo "  sysreport                 # rapport des dernières 24 h"
            echo "  sysreport --days 7        # rapport sur 7 jours"
            echo "  sysreport --date 2026-11-21"
        case '*'
            set_color red
            echo "Commande inconnue : $cmd (sysreport --help)"
            set_color normal
            return 1
    end
end
