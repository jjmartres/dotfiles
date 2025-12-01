function gitlab-sync
    # Sync (clone or update) all repositories from a GitLab group
    # Usage: gitlab-sync <group> [target-directory] [options]

    # Color definitions
    set -l blue (set_color blue)
    set -l green (set_color green)
    set -l yellow (set_color yellow)
    set -l red (set_color red)
    set -l cyan (set_color cyan)
    set -l normal (set_color normal)
    set -l bold (set_color --bold)

    # Help text
    if test (count $argv) -eq 0; or contains -- --help $argv; or contains -- -h $argv
        echo "$bold$cyan━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$normal"
        echo "$bold GitLab Sync - Clone or Update Repositories$normal"
        echo "$bold$cyan━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$normal"
        echo ""
        echo "Usage: gitlab-sync <group> [target-directory] [options]"
        echo ""
        echo "$bold Description:$normal"
        echo "  Intelligently syncs GitLab repositories:"
        echo "  • If repos don't exist → Clones them"
        echo "  • If repos exist → Updates them"
        echo ""
        echo "$bold Arguments:$normal"
        echo "  group              GitLab group name (e.g., 'acme')"
        echo "  target-directory   Where to sync repos (default: current directory)"
        echo ""
        echo "$bold Options:$normal"
        echo "  --stash           Auto-stash uncommitted changes before update"
        echo "  --force-clone     Force re-clone even if repos exist"
        echo "  --archived        Include archived repositories"
        echo "  --dry-run         Show what would be done without doing it"
        echo ""
        echo "$bold Examples:$normal"
        echo "  gitlab-sync acme"
        echo "  gitlab-sync acme ~/projects"
        echo "  gitlab-sync acme ~/work --stash"
        echo "  gitlab-sync company/team . --archived"
        echo ""
        return 0
    end

    # Parse arguments
    set -l group_name $argv[1]
    set -l target_dir "."
    set -l stash_changes false
    set -l force_clone false
    set -l include_archived false
    set -l dry_run false

    # Parse remaining arguments
    set -l idx 2
    while test $idx -le (count $argv)
        switch $argv[$idx]
            case --stash
                set stash_changes true
            case --force-clone
                set force_clone true
            case --archived
                set include_archived true
            case --dry-run
                set dry_run true
            case '-*'
                echo "$red✗ Unknown option: $argv[$idx]$normal"
                echo "Use --help for usage information"
                return 1
            case '*'
                if test $target_dir = "."
                    set target_dir $argv[$idx]
                end
        end
        set idx (math $idx + 1)
    end

    # Validate group name
    if test -z "$group_name"
        echo "$red✗ Error: Group name required$normal"
        echo "Use --help for usage information"
        return 1
    end

    # Header
    echo "$bold$cyan━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$normal"
    echo "$bold GitLab Repository Sync$normal"
    echo "$bold$cyan━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$normal"
    echo "Group:      $yellow$group_name$normal"
    echo "Directory:  $yellow$target_dir$normal"
    echo "Stash:      $yellow$stash_changes$normal"
    echo "Archived:   $yellow$include_archived$normal"
    if test $dry_run = true
        echo "$yellow""[DRY RUN MODE]""$normal"
    end
    echo ""

    # Create target directory if needed
    if not test -d $target_dir
        echo "$blue→$normal Creating directory: $target_dir"
        if test $dry_run = false
            mkdir -p $target_dir
        end
    end

    # Expand target_dir to absolute path
    set target_dir (cd $target_dir 2>/dev/null; and pwd; or echo $target_dir)

    # Count existing repositories
    set -l existing_repos (find $target_dir -name ".git" -type d 2>/dev/null | wc -l | string trim)

    # Decide: Clone or Update?
    if test $existing_repos -eq 0; or test $force_clone = true
        # ═══════════════════════════════════════════════════════
        # CLONE MODE
        # ═══════════════════════════════════════════════════════

        if test $force_clone = true; and test $existing_repos -gt 0
            echo "$yellow⚠  Force clone requested - existing repos will be preserved$normal"
            echo ""
        end

        echo "$green✓$normal No existing repositories found"
        echo "$blue→$normal Cloning all repositories from: $bold$group_name$normal"
        echo ""

        # Build glab command
        set -l glab_cmd glab repo clone --group $group_name --paginate --preserve-namespace

        # Add archived filter
        if test $include_archived = false
            set -a glab_cmd --archived=false
        end

        echo "$cyan→ Command:$normal $glab_cmd"
        echo ""

        if test $dry_run = false
            # Execute clone
            cd $target_dir
            if eval $glab_cmd
                echo ""
                set -l cloned_repos (find . -name ".git" -type d 2>/dev/null | wc -l | string trim)
                echo "$bold$green━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$normal"
                echo "$bold$green✓ Clone completed successfully!$normal"
                echo "$bold$green━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$normal"
                echo "Repositories cloned: $bold$yellow$cloned_repos$normal"
                return 0
            else
                echo ""
                echo "$bold$red━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$normal"
                echo "$bold$red✗ Clone failed!$normal"
                echo "$bold$red━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$normal"
                return 1
            end
        else
            echo "$yellow""[DRY RUN] Would clone repositories to: ""$target_dir$normal"
        end

    else
        # ═══════════════════════════════════════════════════════
        # UPDATE MODE
        # ═══════════════════════════════════════════════════════

        echo "$green✓$normal Found $bold$yellow$existing_repos$normal existing repositories"
        echo "$blue→$normal Updating all repositories..."
        echo ""

        set -l updated 0
        set -l skipped 0
        set -l failed 0
        set -l up_to_date 0

        # Update each repository
        for git_dir in (find $target_dir -name ".git" -type d 2>/dev/null)
            set -l repo_path (dirname $git_dir)
            set -l relative_path (string replace "$target_dir/" "" $repo_path)

            if test $dry_run = true
                echo "$cyan→$normal Would update: $relative_path"
                continue
            end

            echo "$cyan━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$normal"
            echo "$bold📁 $relative_path$normal"

            cd $repo_path

            # Get current branch
            set -l current_branch (git rev-parse --abbrev-ref HEAD 2>/dev/null)
            if test $status -ne 0
                echo "  $red✗ Not a valid git repository$normal"
                set failed (math $failed + 1); set -a failed_repos $relative_path
                echo ""
                continue
            end

            if test "$current_branch" = HEAD
                echo "  $yellow⚠  Detached HEAD state, skipping$normal"
                set skipped (math $skipped + 1)
                echo ""
                continue
            end

            echo "  Branch: $green$current_branch$normal"

            # Check for uncommitted changes
            set -l has_changes false
            if not git diff-index --quiet HEAD -- 2>/dev/null
                set has_changes true

                if test $stash_changes = true
                    echo "  $yellow→ Stashing uncommitted changes...$normal"
                    if git stash push -m "Auto-stash by gitlab-sync ($(date +%Y-%m-%d_%H:%M:%S))" >/dev/null 2>&1
                        echo "  $green✓ Stashed successfully$normal"
                    else
                        echo "  $red✗ Failed to stash$normal"
                        set failed (math $failed + 1); set -a failed_repos $relative_path
                        echo ""
                        continue
                    end
                else
                    echo "  $yellow⚠  Uncommitted changes detected, skipping$normal"
                    echo "  $cyan→ Use --stash to auto-stash changes$normal"
                    set skipped (math $skipped + 1)
                    echo ""
                    continue
                end
            end

            # Fetch updates
            echo "  $blue→ Fetching updates...$normal"
            if not git fetch origin --prune --quiet 2>&1
                echo "  $red✗ Fetch failed$normal"
                set failed (math $failed + 1); set -a failed_repos $relative_path
                if test $has_changes = true; and test $stash_changes = true
                    git stash pop --quiet 2>/dev/null
                end
                echo ""
                continue
            end

            # Check if updates available
            set -l local_commit (git rev-parse @ 2>/dev/null)
            set -l remote_commit (git rev-parse @{u} 2>/dev/null)

            if test -z "$remote_commit"
                echo "  $yellow⚠  No upstream branch configured$normal"
                set skipped (math $skipped + 1)
                if test $has_changes = true; and test $stash_changes = true
                    git stash pop --quiet 2>/dev/null
                end
                echo ""
                continue
            end

            if test "$local_commit" = "$remote_commit"
                echo "  $green✓ Already up to date$normal"
                set up_to_date (math $up_to_date + 1)
                if test $has_changes = true; and test $stash_changes = true
                    echo "  $blue→ Popping stash...$normal"
                    git stash pop --quiet 2>/dev/null
                end
                echo ""
                continue
            end

            # Check if can fast-forward
            set -l base_commit (git merge-base @ @{u} 2>/dev/null)

            if test "$local_commit" != "$base_commit"
                echo "  $yellow⚠  Local commits ahead or diverged, skipping$normal"
                set skipped (math $skipped + 1)
                if test $has_changes = true; and test $stash_changes = true
                    git stash pop --quiet 2>/dev/null
                end
                echo ""
                continue
            end

            # Pull changes
            echo "  $blue→ Pulling changes...$normal"
            if git pull --quiet 2>&1
                set -l commit_count (git rev-list --count $local_commit..$remote_commit 2>/dev/null)
                echo "  $bold$green✓ Updated successfully$normal $yellow($commit_count commit(s))$normal"
                set updated (math $updated + 1)

                # Pop stash if we stashed
                if test $has_changes = true; and test $stash_changes = true
                    echo "  $blue→ Popping stash...$normal"
                    if git stash pop --quiet 2>/dev/null
                        echo "  $green✓ Stash restored$normal"
                    else
                        echo "  $red✗ Stash pop failed (conflicts?)$normal"
                        echo "  $yellow→ Please resolve manually$normal"
                    end
                end
            else
                echo "  $red✗ Pull failed$normal"
                set failed (math $failed + 1); set -a failed_repos $relative_path
                if test $has_changes = true; and test $stash_changes = true
                    git stash pop --quiet 2>/dev/null
                end
            end

            echo ""
        end

        # Summary
        echo "$bold$cyan━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$normal"
        echo "$bold Summary$normal"
        echo "$bold$cyan━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$normal"
        echo "Total repositories:  $yellow$existing_repos$normal"
        echo "Updated:             $green$updated$normal"
        echo "Already up to date:  $blue$up_to_date$normal"
        echo "Skipped:             $yellow$skipped$normal"
        if test $failed -gt 0
            echo "Failed:              $red$failed$normal"
            echo
            echo "$bold$redFailed Repositories:$normal"
            for repo in $failed_repos
                echo "  - $repo"
            end
        end
        echo ""

        if test $failed -gt 0
            echo "$yellow⚠  Some repositories failed to update$normal"
            cd $target_dir
            return 1
        end
    end

    echo "$bold$green✓ Sync completed successfully!$normal"
    return 0
end
