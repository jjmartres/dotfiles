function personal --description "Manage personal mounts"
    if test (count $argv) -eq 0
        echo "Usage: personal [mount|umount]"
        return 1
    end

    switch $argv[1]
        case mount
            sudo /usr/local/bin/sshfs -o nonamedattr jjmartres@personal:/media/jjmartres/Astrophotography ~/Personal/Astrophotography/
            sudo /usr/local/bin/sshfs -o nonamedattr jjmartres@personal:/media/jjmartres/Medias ~/Personal/Medias/
        case umount
            umount -f ~/Personal/Astrophotography
            umount -f ~/Personal/Medias
        case '*'
            echo "Unknown command: $argv[1]"
            echo "Usage: personal [mount|umount]"
            return 1
    end
end
