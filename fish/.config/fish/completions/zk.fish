# Sous-commandes principales
complete -c zk -f -n __fish_use_subcommand -a new -d 'Create a new note'
complete -c zk -f -n __fish_use_subcommand -a list -d 'List notes'
complete -c zk -f -n __fish_use_subcommand -a edit -d 'Edit notes'
complete -c zk -f -n __fish_use_subcommand -a daily -d 'Open daily note'
complete -c zk -f -n __fish_use_subcommand -a index -d 'Index notes'
complete -c zk -f -n __fish_use_subcommand -a tag -d 'Manage tags'
complete -c zk -f -n __fish_use_subcommand -a init -d 'Initialize notebook'

# Alias suggérés
complete -c zk -f -n __fish_use_subcommand -a n -d '→ zkn: New note'
complete -c zk -f -n __fish_use_subcommand -a l -d '→ zkl: List interactive'
complete -c zk -f -n __fish_use_subcommand -a d -d '→ zkd: Daily note'
complete -c zk -f -n __fish_use_subcommand -a t -d '→ zkt: Filter by tag'
complete -c zk -f -n __fish_use_subcommand -a r -d '→ zkr: Recent notes'
complete -c zk -f -n __fish_use_subcommand -a e -d '→ zke: Edited notes'
complete -c zk -f -n __fish_use_subcommand -a g -d '→ zkg: Grep notes'

# Options pour 'zk new'
complete -c zk -f -n '__fish_seen_subcommand_from new' -l title -d 'Note title'
complete -c zk -f -n '__fish_seen_subcommand_from new' -l group -d 'Note group'

# Options pour 'zk list'
complete -c zk -f -n '__fish_seen_subcommand_from list' -l interactive -d 'Interactive mode'
complete -c zk -f -n '__fish_seen_subcommand_from list' -l tag -d 'Filter by tag'
complete -c zk -f -n '__fish_seen_subcommand_from list' -l match -d 'Match content'
