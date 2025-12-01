function zkr
    set -l current_dir (pwd)
    cd $ZK_NOTEBOOK_DIR && zk recent
    cd $current_dir
end
