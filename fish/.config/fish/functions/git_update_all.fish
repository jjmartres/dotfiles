function git_update_all
  set WORKING_DIRECTORY (pwd)
  echo "Updating all repositories in $WORKING_DIRECTORY"

  if test -z "$argv[1]"
    echo "No mode provided. Using default mode."
    set MODE "fetch"
  elseif test "$argv[1]" = "pull"
    set MODE "pull"
  elseif test "$argv[1]" = "fetch"
    set MODE "fetch"
  else
    echo "ERROR: unknown mode $argv[1]" >&2
    return 1 # Exit with an error code
  end

  set LOGFILE "$WORKING_DIRECTORY/gitupdateall.log"

  echo "Using mode: $MODE"
  echo "Using logfile: $LOGFILE"

  find . -maxdepth 1 -type d \( ! -name . \) -exec fish -c 'cd "{}" ; if test -d ".git" ; echo "Found git repository:" ; pwd ; echo "Updating.." ; git $MODE -v >> $LOGFILE 2>&1 ; echo "Done." ; end' \;
end
