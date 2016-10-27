#!/bin/bash -eu

script_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
ansible_root="$script_dir/../../"

cd $ansible_root

function usage {
    echo "Basic usage ./$(basename $0) --env demo --name gemini"
    exit 1
}

function create_transifex_github_integration {
    local env=$1
    local app_name=$2

    echo "Creating Transifex github integration stack ${app_name} in ${env}"

    # Create node in zone A
    ansible-playbook -vvvv -i local projects/transifex/create_node.yml -e "app_name=${app_name} env=${env} zone=a varfile=/dev/null"

    # Clear the Ansible cache
    python ec2.py --refresh-cache

    # Install and start TXGH
    ansible-playbook -vvvv -i ec2.py projects/transifex/install_txgh.yml -e "app_name=${app_name} env=${env} zone=a"
}

############################
###### Process Args ########
############################
while :; do
    case ${1:-} in
        -e|--env)
            env=$2
            shift
            ;;
        -d|--name)
            name=$2
            shift
            ;;
        -?*) # Unknown option
            echo 'WARN: Unknown option: %s\n' "$1" >&2
            usage
            ;;
        *) # No more options
            break
    esac
    shift
done

if [ -z ${env:-} ]; then
    echo "Env can not be empty"
    usage
fi
if [ -z ${name:-} ]; then
    echo "Name can not be empty"
    usage
fi

create_transifex_github_integration $env $name
