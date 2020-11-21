#!/usr/bin/env bash

SCRIPT_LOCATION="$(cd $(readlink "$(dirname "${BASH_SOURCE[0]}")") && pwd)"
BASEDIR=${SCRIPT_LOCATION%/*/*}
RED="$(tput setaf 1)"
NORMAL="$(tput sgr0)"

main() {
    [ -n "${DEBUG}" ] && printf "BASEDIR=${BASEDIR}\nSCRIPT_LOCATION=${SCRIPT_LOCATION}\n"

    if [ -z "${DEBUG}" ]; then
        read -rp "[${RED} WARNING${NORMAL} ] This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1; echo ""
        [[ $REPLY =~ ^[Yy]$ ]] && symlink_configs
    fi
}
   
symlink_configs() {
    echo "Starting creating symlinks..."
    # TODO ссылки создаются без правильных имен
    ln -sbiv "${BASEDIR}/home/"* "${HOME}/"
    ln -sbiv "${BASEDIR}/config/"* "${HOME}/.config/"
}

[ $? -ne 0 ] && exit 1
eval set -- "$(
     getopt --name "dot_install" \
         --options "dh" \
         --longoptions "debug,help" \
         -- "$@" \
    || exit 98
)"

while true; do
    case "$1" in
        -d|--debug) DEBUG="1" ;;
        -h|--help)  echo "Help msg" ; exit ;;
        --)         break ;;
    esac
    shift
done

[[ ${__lastarg:="${!#:-}"} =~ ^--$|${0}$ ]] \
  && __lastarg="" 

main "${@:-}"
