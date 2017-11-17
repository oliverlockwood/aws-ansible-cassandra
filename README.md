# aws-ansible-cassandra
Simple Ansible script to set up a minimal Cassandra cluster

# Installing Python / Ansible

Need python installed:

    brew install python

Then use pip (not homebrew) to install ansible:

    pip install -Iv ansible==2.1.1.0
    pip install paramiko PyYAML Jinja2 httplib2 six boto

Make sure that the path to the Python executable defined in [local](local) is correct.

# AWS access

Need the following environment variables to be set up:

    export AWS_ACCESS_KEY_ID 'your-access-key-id'
    export AWS_SECRET_ACCESS_KEY='your-secret-access-key'

Need your SSH key (configured [here](https://eu-west-1.console.aws.amazon.com/ec2/v2/home?region=eu-west-1#KeyPairs:sort=keyName))
to have a name matching the `envname` you intend to pass to `--env`, be saved in ~/.ssh as `<envname>.pem` and set
`chmod` to `400`.  Additionally, you'll need to set up host mappings like the following in `~/.ssh/config`.

    Host 34.*
     User ubuntu
     IdentityFile ~/.ssh/demo2.pem
