function pixinsight_sync
    rsync -avh --size-only --delete --info=progress2 \
        --exclude=astrophotography/_Dbs/ \
        ~/Personal/astrophotography/* \
        personal:/media/jjmartres/Astrophotography/astrophotography/ 2>>~/.local/state/pixinsights_sync-errors.log
end
