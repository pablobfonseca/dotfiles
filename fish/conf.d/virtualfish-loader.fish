set -g VIRTUALFISH_VERSION 2.5.1
set -g VIRTUALFISH_PYTHON_EXEC /usr/local/opt/python@3.8/bin/python3.8
source /usr/local/lib/python3.8/site-packages/virtualfish/virtual.fish
source /usr/local/lib/python3.8/site-packages/virtualfish/projects.fish
source /usr/local/lib/python3.8/site-packages/virtualfish/auto_activation.fish
emit virtualfish_did_setup_plugins
