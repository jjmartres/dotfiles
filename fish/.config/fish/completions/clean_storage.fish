complete -c clean_storage -f

complete -c clean_storage -s n -l dry-run -n "not contains -- --yes (commandline -opc); and not contains -- -y (commandline -opc)" -d "Afficher seulement ce qui serait libéré"
complete -c clean_storage -s y -l yes -n "not contains -- --dry-run (commandline -opc); and not contains -- -n (commandline -opc)" -d "Ne pas demander de confirmation"
complete -c clean_storage -l docker -n "not contains -- --docker (commandline -opc); and not contains -- --all (commandline -opc)" -d "Docker system prune -a + fstrim colima"
complete -c clean_storage -l deps -n "not contains -- --deps (commandline -opc); and not contains -- --all (commandline -opc)" -d "Supprimer node_modules et .venv des repos"
complete -c clean_storage -l all -n "not contains -- --all (commandline -opc); and not contains -- --docker (commandline -opc); and not contains -- --deps (commandline -opc)" -d "--docker + --deps"
complete -c clean_storage -l path -r -n "not contains -- --path (commandline -opc)" -d "Racine des repos (défaut : ~/Repositories)"
complete -c clean_storage -F -n "__fish_prev_arg_in --path"
complete -c clean_storage -s h -l help -d "Aide"
complete -c clean_storage -l schedule -n "not contains -- --unschedule (commandline -opc)" -d "Planifier le 1er et le 16 du mois (launchd)"
complete -c clean_storage -l unschedule -n "not contains -- --schedule (commandline -opc)" -d "Retirer la tâche planifiée"
