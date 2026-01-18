#!/bin/bash
# Source Spack environment if starting bash
if [[ "$1" == "bash" ]] || [[ "$1" == "/bin/bash" ]]; then
    exec /bin/bash --rcfile /etc/profile -l "${@:2}"
else
    # For other commands (like supervisord), just execute them
    exec "$@"
fi
