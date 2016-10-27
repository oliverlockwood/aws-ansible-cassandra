#!/bin/bash

ansible --version

# ansible -vvvv -i ec2.py eu-west-1 --list-hosts
# ansible -vvvv -i ec2.py eu-west-1 -m ec2_facts

./projects/transifex/create-txgh.sh --env prod --name fratello
