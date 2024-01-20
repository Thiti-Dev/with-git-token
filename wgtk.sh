#!/bin/bash

token_path="./.token"
passed_args="$@"

show_helping_message() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -h, --help    Display this help message"
    echo "  configure     Configure your github credential"
}

cross_delivering_with_token() {


    local stored_token=$(get_stored_token)
    if [[ $passed_args == "git "*"github.com"* ]]; then
        modified_cli=$(echo "$passed_args" | sed -E '/https:\/\/[^@]+@github\.com/! s|(https://github\.com)|https://'"$stored_token"'@github.com|')
        echo "[with-git-token]: Executing -> $modified_cli"
        eval "$modified_cli"
        exit 0
    else
        echo "Error: This command can only be used with the git cli such cloning, origin-adding"
        exit 1
    fi
}

does_configuration_file_exist(){
    if [ -f "$token_path" ]; then
        return 0
    fi
    return 1
}

get_stored_token(){
    cat $token_path
}

# Check if no arguments are provided
if [ $# -eq 0 ]; then
    echo "Error: No arguments provided. Use '$0 --help' for usage information."
    exit 1
fi


while [ "$#" -gt 0 ]; do
    case "$1" in
        -h|--help)
            show_helping_message
            exit 0
            ;;
        configure)
            if [ -z "$2" ]; then
                echo "ERROR: GitHub token not provided."
                echo "Please configure your GitHub token using the following command:"
                echo "   wgtk configure {{Your GitHub token here}}"
                echo "Replace '{{Your GitHub token here}}' with your actual GitHub token."
                exit 1
            fi
            echo "$2" > ./.token
            exit 0
            ;;
        *)
            if ! does_configuration_file_exist; then
                echo "ERROR: No configuration found"
                echo "Please configure your GitHub token using the following command:"
                echo "   wgtk configure {{Your GitHub token here}}"
                exit 1
            fi
            cross_delivering_with_token
            exit 0
            ;;
    esac
    shift
done