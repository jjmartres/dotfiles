## Configure where our applications go
cask_args appdir: "/Applications"

## Tap homebrew
tap "buo/cask-upgrade"                          # Tap for the cask-upgrade tool
tap "aquasecurity/trivy"                        # Tap for the Trivy security scanner
tap "safedep/tap"                               # Tap for safedep
tap "hashicorp/tap"                             # Tap for Hashicorp tools
tap "koekeishiya/formulae"                      # Formulae for Homebrew
tap "FelixKratz/formulae"                       # Formulae for Homebrew
tap "lusingander/tap"                           # Formulae for Homebrew
tap "fairwindsops/tap"                          # Formulae for Homebrew
tap "robusta-dev/homebrew-krr"                  # Formulae for Homebrew
tap "vladkens/tap"                              # Formulae for Homebrew
tap "doganarif/tap"                             # Formulae for Homebrew

## Fonts
cask "font-iosevka-nerd-font"
cask "font-jetbrains-mono-nerd-font"
cask "sf-symbols" if OS.mac?
cask "font-sf-mono" if OS.mac?
cask "font-sf-pro" if OS.mac?

## Shell Utilities
brew "ast-grep"                                 # Structural search and replace for code
brew "bat"                                      # Cat clone with syntax highlighting and Git integration
brew "binutils"                                 # Collection of binary tools
brew "coreutils"                                # Basic command-line utilities (ls, cp, etc.)
brew "curl"                                     # Tool to transfer data from/to a server
brew "dnstracer"                                # Traces DNS query paths
brew "eza"                                      # ls replacement easy to use and simple to install
brew "fd"                                       # Simple, fast and user-friendly alternative to 'find'
brew "fish"                                     # Fish shell (alternative to zsh)
brew "fisher"                                   # Plugin manager for fish
brew "findutils"                                # Utilities for finding files
brew "fzf"                                      # Fuzzy finder for the command line
brew "gawk"                                     # GNU version of the awk text processing tool
brew "gmp"                                      # GNU Multiple Precision Arithmetic Library
brew "gnu-getopt"                               # GNU version of getopt for command-line options
brew "gnu-indent"                               # GNU program for indenting C code
brew "gnu-sed"                                  # GNU stream editor for text manipulation
brew "gnu-tar"                                  # GNU version of the tar archiving utility
brew "gnutls"                                   # GNU Transport Layer Security library
brew "grep"                                     # Command-line utility for searching plain-text data sets
brew "btop"                                     # A monitor of resources
brew "moreutils"                                # Additional Unix utilities
brew "nmap"                                     # Network exploration tool and security scanner
brew "nushell"                                  # Modern shell for the GitHub era
brew "openssh"                                  # OpenBSD Secure Shell tools (ssh, scp, etc.)
brew "pstree"                                   # Displays running processes as a tree
brew "readline"                                 # Library for interactive command-line editing
brew "rename"                                   # Utility for batch renaming files
brew "ripgrep"                                  # Line-oriented search tool that recursively searches directories
brew "rlwrap"                                   # Adds readline input editing to other utilities
brew "rsync"                                    # Utility for synchronizing files and directories
brew "shfmt"                                    # Shell formatters with support for bash and zsh
brew "socat"                                    # Multipurpose relay tool
brew "sqlite3"                                  # Command-line interface for SQLite databases
brew "ssh-copy-id"                              # Copies your public key to a remote host for passwordless login
brew "sslscan"                                  # Tests SSL/TLS services to find supported cipher suites
brew "starship"                                 # Cross-shell prompt for any shell
brew "stow"                                     # Manages symbolic links for package installation
brew "tree"                                     # Displays directory contents in a tree-like format
brew "uni2ascii"                                # Converts Unicode strings to ASCII equivalents
brew "vivid"                                    # vivid is a generator for the LS_COLORS environment variable that controls the colorized output of ls / eza
brew "watch"                                    # Executes a program periodically, showing output in full screen
brew "wget"                                     # Tool to download files from the web
brew "z"                                        # Jump to frequently used directories
brew "zlib"                                     # Compression library
brew "zoxide"                                   # Smarter cd command, learns your habits
brew "fastfetch"                                # Fast system information script
brew "superfile"                                # Perfect Terminal-based file manager
brew "zk"                                       # Zettelkasten CLI

## Improve OSx UI experience
#brew "yabai" if OS.mac?                          # Yet Another Bouncer for macOS
#brew "skhd" if OS.mac?                           # Simple hotkey daemon for macOS
#brew "borders" if OS.mac?                        # lightweight tool designed to add colored borders to user windows

## Versioning (Git)
brew "gh"                                       # GitHub CLI
brew "git"                                      # Distributed version control system
brew "git-crypt"                                # Transparent file encryption in Git
brew "git-lfs"                                  # Git extension for versioning large files
brew "glab"                                     # GitLab CLI
brew "gh"                                       # Command-line wrapper for Git that makes you a GitHub ninja
brew "lazygit"                                  # Simple terminal UI for git commands
brew "mercurial"                                # Distributed revision control system

## Development Tools
brew "cmake"                                    # Cross-platform build system generator
brew "gcc"                                      # GNU Compiler Collection
brew "glow"                                     # Render markdown on the terminal
brew "jq"                                       # Lightweight and flexible command-line JSON processor
brew "lua"                                      # Powerful, lightweight programming language
brew "lua-language-server"                      # Language Server Protocol implementation for Lua
brew "luajit", args: ["HEAD"]                   # High-performance Lua JIT compiler (HEAD version)
brew "markdown-toc"                             # Generate table of contents for Markdown files
brew "mysql-client"                             # MySQL command-line client
brew "neovim"                                   # Hyperextensible Vim-based text editor
brew "tree-sitter-cli"                          # CLI tool for managing Tree-sitter parsers
brew "nvm"                                      # Node.js version management
brew "prettierd"                                # Opinionated code formatter (daemon)
brew "prettier"                                 # Opinionated code formatter
brew "rust"                                     # Systems programming language
brew "yq"                                       # Portable command-line YAML processor
brew "uv"                                       # Universal package manager for cli tools
brew "golangci-lint"                            # Fast linters Runner for Go
brew "asdf"                                     # Extendable version manager with support for Ruby, Node.js, Elixir, Erlang & more
brew "macmon"                                   # Monitor CPU, memory, network, disk, and process activity on your Mac
brew "poetry"                                   # Python dependency management and packaging tool

## DevOps Tools
brew "atuin"                                    # Sync, search and backup shell history with Atuin
brew "ansible"                                  # Automation engine
brew "aquasecurity/trivy/trivy"                 # Simple and comprehensive vulnerability scanner
brew "checkov"                                  # Static analysis tool for infrastructure-as-code
brew "dive"                                     # Tool for exploring each layer in a docker image
brew "hadolint"                                 # Dockerfile linter
brew "hashicorp/tap/packer"                     # Tool for building machine images
brew "helm"                                     # The Kubernetes Package Manager
brew "helmfile"                                 # Declaratively manage Helm charts
brew "infracost"                                # Cloud cost estimation for Terraform
brew "istioctl"                                 # CLI tool for Istio service mesh
brew "jsonnet"                                  # Configuration language for Google Cloud Platform
brew "jsonnet-bundler"                          # Package manager for Jsonnet
brew "k9s"                                      # Kubernetes CLI To Manage Your Clusters In Style!
brew "k9sight"                                  # A fast, keyboard-driven TUI for debugging Kubernetes workloads
brew "kubectx"                                  # Tool to switch between Kubernetes contexts
brew "kubecolor"                                # Add colors to kubectl output
brew "kustomize"                                # Kubernetes native configuration management
brew "mongodb-atlas"                            # MongoDB Atlas CLI
brew "polaris"                                  # Validation of Kubernetes YAML
brew "pre-commit"                               # Framework for managing and maintaining multi-language pre-commit hooks
brew "redis"                                    # In-memory data structure store, often used for caching/brokerage
brew "sipcalc"                                  # Simple IP calculator
brew "skaffold"                                 # Easy and Repeatable Kubernetes Development
brew "terraform-docs"                           # Generate documentation from Terraform modules
brew "terraform-ls"                             # Language Server Protocol for Terraform
brew "terraformer"                              # Generate tf/json and hcl from existing infrastructure
brew "terrahelp"                                # Collection of helpful Terraform utilities
brew "tflint"                                   # Terraform linter
brew "tfsec"                                    # Security scanner for Terraform code
brew "terrascan"                                # Static code analyzer for Infrastructure as Code
brew "tfenv"                                    # Terraform version manager
brew "jira-cli"                                 # A Textual User Interface for interacting with Atlassian Jira from your shell
brew "jiratui"                                  # A Textual User Interface for interacting with Atlassian Jira from your shell
brew "go-task"                                  # Task runner / simpler Make alternative written in Go
brew "serie"                                    # A rich git commit graph in your terminal, like magic
brew "diff-so-fancy"                            # Compare anything with git
brew "atac"                                     # A terminal client for the API
brew "zellij"                                   # A terminal session mananger
brew "robusta-dev/homebrew-krr/krr"             # Kubernetes Resource Reporter
brew "kubebuilder"                              # CLI tool for building Kubernetes APIs
brew "pydantic"                                 # Data validation and settings management using Python type hints

## Graphics
brew "asciinema"                                # Record and share terminal sessions
brew "exiftool"                                 # Read and write meta information in various file formats
brew "ffmpeg"                                   # Complete, cross-platform solution to record, convert and stream audio and video
brew "gifsicle"                                 # Tool for creating, manipulating, and optimizing GIF animations
brew "graphviz"                                 # Open-source graph visualization software
brew "imagemagick"                              # Software suite to create, edit, compose, or convert bitmap images
brew "marp-cli"                                 # Markdown presentation ecosystem
brew "chafa"                                    # Versatile and fast Unicode/ASCII/ANSI graphics renderer

## Security
brew "safedep/tap/vet"                                  # Safely manage your dependencies
brew "aquasecurity/trivy/trivy"                 # Simple and comprehensive vulnerability scanner

## AI
brew "ollama"                                   # Run large language models locally
brew "opencode"                         # The AI coding agent built for the terminal

## Fun
brew "c2048"                                    # Terminal version of the 2048 game
brew "fortune"                                  # Print a random, hopefully interesting, adage

## Cask Applications (General)
cask "ghostty"                                  # Modern and customizable terminal emulator
cask "gitkraken"                                # Cross-platform Git GUI client
cask "gcloud-cli"                               # Command-line tool for Google Cloud Platform
cask "hiddenbar"                                # Utility to hide menu bar icons
cask "httpie-desktop"                           # Modern command-line HTTP client
cask "steam"                                    # Steam client
cask "bruno"                                    # Fully-offline API-client today
cask "grandperspective"                         # Disk usage
cask "visual-studio-code"                       # Visula Studio Code editor
cask "macdown"                                  # Markdown editor
cask "dbeaver-community"                        # Database management tool
cask "vlc"                                      # Cross-platform multimedia player
cask "cyberduck"                                # FTP, SFTP, WebDAV, Amazon S3, OpenStack Swift, Backblaze B2, Microsoft Azure & OneDrive, Google Drive
cask "appcleaner"                               # Cleaner for macOS apps
cask "maccy"                                    # Clipboard manager
cask "soulseek"                                 # P2P music streamer
cask "discord"                                  # Chat with your friends
