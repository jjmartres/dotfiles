complete -c sysreport -f

function __sysreport_needs_command
    set -l tokens (commandline -opc)
    __fish_prev_arg_in --days --hours --date; and return 1
    for t in $tokens[2..-1]
        if contains -- $t report r last runs status s open o latest l list ls install uninstall help
            return 1
        end
    end
    return 0
end

function __sysreport_reporting
    set -l tokens (commandline -opc)
    test (count $tokens) -eq 1; and return 0
    contains -- report $tokens; or contains -- r $tokens; or string match -q -- '--*' $tokens[2]
end

function __sysreport_range_unset
    set -l tokens (commandline -opc)
    not contains -- --days $tokens; and not contains -- --hours $tokens; and not contains -- --date $tokens
end

function __sysreport_dates
    set -l db $HOME/.local/share/sysstats/stats.db
    test -f $db; or return
    sqlite3 $db "SELECT DISTINCT date(ts, 'unixepoch', 'localtime') FROM samples ORDER BY 1 DESC LIMIT 90" 2>/dev/null
end

# sous-commandes
complete -c sysreport -n __sysreport_needs_command -a report -d "Générer et ouvrir un rapport (défaut : 24 h)"
complete -c sysreport -n __sysreport_needs_command -a last -d "Derniers runs et état launchd"
complete -c sysreport -n __sysreport_needs_command -a open -d "Ouvrir le dossier des rapports"
complete -c sysreport -n __sysreport_needs_command -a latest -d "Ouvrir le dernier rapport"
complete -c sysreport -n __sysreport_needs_command -a list -d "Lister les rapports"
complete -c sysreport -n __sysreport_needs_command -a install -d "Activer les tâches launchd"
complete -c sysreport -n __sysreport_needs_command -a uninstall -d "Retirer les tâches launchd"
complete -c sysreport -n __sysreport_needs_command -s h -l help -d "Aide"

# options de rapport (mutuellement exclusives)
complete -c sysreport -n "__sysreport_reporting; and __sysreport_range_unset" -l days -r -d "Période en jours"
complete -c sysreport -n "__sysreport_reporting; and __sysreport_range_unset" -l hours -r -d "Période en heures"
complete -c sysreport -n "__sysreport_reporting; and __sysreport_range_unset" -l date -r -d "Journée complète"
complete -c sysreport -n "__sysreport_reporting; and not contains -- --no-open (commandline -opc)" -l no-open -d "Ne pas ouvrir le rapport"

# valeurs des options
complete -c sysreport -n "__fish_prev_arg_in --days" -x -a "1 2 3 7 14 30"
complete -c sysreport -n "__fish_prev_arg_in --hours" -x -a "1 6 12 24 48"
complete -c sysreport -n "__fish_prev_arg_in --date" -x -a "(__sysreport_dates)"
