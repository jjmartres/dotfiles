function zkl
    set -l current_dir (pwd)
    cd $ZK_NOTEBOOK_DIR && zk list --interactive
    cd $current_dir
end
