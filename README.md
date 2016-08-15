# aws-ansible-cassandra
Simple Ansible script to set up a minimal Cassandra cluster

# Installing

Need python installed:

    brew install python

Then use pip (not homebrew) to install ansible:

    pip install -Iv ansible==2.1.1.0
    pip install paramiko PyYAML Jinja2 httplib2 six boto

# AWS access

Need the following environment variables to be set up:

    export AWS_ACCESS_KEY_ID 'your-access-key-id'
    export AWS_SECRET_ACCESS_KEY='your-secret-access-key'
