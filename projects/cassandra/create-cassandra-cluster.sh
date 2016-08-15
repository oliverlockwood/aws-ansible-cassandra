#!/bin/bash -eu

script_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
ansible_root="$script_dir/../../"

cd $ansible_root

function usage {
    echo "Basic usage ./$(basename $0) --env demo --dbname gemini"
    exit 1
}

function create_cassandra_stack {
    local env=$1
    local db_name=$2
    local varfile=$(mktemp -t $(basename $0).XXXXXX)

    echo "Creating Cassandra stack ${db_name} in ${env}, using ${varfile} for temporary variable storage"

    # Create nodes in zones A and B
    ansible-playbook -vvvv -i local projects/cassandra/create_cluster.yml -e "app_name=${db_name} env=${env} zone=a varfile=${varfile}"
    ansible-playbook -vvvv -i local projects/cassandra/create_cluster.yml -e "app_name=${db_name} env=${env} zone=b varfile=/tmp/bob"

    # Install Cassandra in zones A and B
    local extra_vars=$(head -1 ${varfile})
    ansible-playbook -vvvv -i ec2.py projects/cassandra/install_cassandra.yml -e "app_name=${db_name} env=${env} zone=a ${extra_vars}"
    ansible-playbook -vvvv -i ec2.py projects/cassandra/install_cassandra.yml -e "app_name=${db_name} env=${env} zone=b ${extra_vars}"

    # Restart Cassandra to pick up updated config files
    ansible-playbook -vvvv -i ec2.py projects/cassandra/restart_cassandra.yml -e "app_name=${db_name} env=${env}"

    # Create keyspace for cqlmigrate
    ansible-playbook -vvvv -i ec2.py projects/cassandra/create-cqlmigrate-locks-keyspace.yml -e "app_name=${db_name} env=${env}"
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
        -d|--dbname)
            dbname=$2
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
if [ -z ${dbname:-} ]; then
    echo "Db name can not be empty"
    usage
fi

create_cassandra_stack $env $dbname
