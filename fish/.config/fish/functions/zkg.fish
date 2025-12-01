function zkg
    set -l current_dir (pwd)
    cd $ZK_NOTEBOOK_DIR && zk list --match $argv
    cd $current_dir
end
