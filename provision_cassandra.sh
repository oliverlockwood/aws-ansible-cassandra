#!/bin/bash

ansible --version

# ansible -vvvv -i ec2.py eu-west-1 --list-hosts
# ansible -vvvv -i ec2.py eu-west-1 -m ec2_facts

./projects/cassandra/create-cassandra-cluster.sh --env demo2 --dbname gemini
