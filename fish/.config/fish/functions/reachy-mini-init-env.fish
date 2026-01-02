function reachy-mini-init-env
    echo "PYTHON 3.12.12" >.tools-versions
    asdf install
    uv venv -p $(asdf which python) --clear
    uv sync --all-extras --frozen
end
