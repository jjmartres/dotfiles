# Completions for the code function

# Disable default file completion
complete -c code -f

# ── Flags ──────────────────────────────────────────────────────────────────────

complete -c code -l help -s h -d "Show help message"
complete -c code -l refresh   -d "Force rebuild of the repository cache"
complete -c code -l herdr     -d "Open repository in a Herdr workspace"

# ── Positional arg: search path ────────────────────────────────────────────────
# Re-enable directory completion for the root path argument

complete -c code -F -a "(__fish_complete_directories)"
