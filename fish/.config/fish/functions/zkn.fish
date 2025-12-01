function zkn
    set -l current_dir (pwd)
    cd $ZK_NOTEBOOK_DIR && zk new --title $argv
    cd $current_dir
end
