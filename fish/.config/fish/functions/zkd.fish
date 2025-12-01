function zkd
    set -l current_dir (pwd)
    cd $ZK_NOTEBOOK_DIR && zk daily
    cd $current_dir
end
