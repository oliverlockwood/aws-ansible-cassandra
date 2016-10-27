Create a TXGH node as per https://github.com/transifex/txgh/blob/devel/docs/aws.md

Use or create {env}.yml to specify environment specific attributes such as aws subnets
Use or create {db_name}.yml to specify database attributes such as Cassandra version, number of nodes 

Usage:
```
  ./create-txgh.sh --env prod --name fratello
```

Note that you will need the ansible role from https://github.com/rvm/rvm1-ansible
```
  ansible-galaxy install rvm_io.rvm1-ruby
```