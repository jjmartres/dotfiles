function zksave
    cd $HOME/.notes
    git add .
    git commit -m "Notes: $(date '+%Y-%m-%d %H:%M')"
    git push
end
