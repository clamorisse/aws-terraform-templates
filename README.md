# aws-terraform-templates
This is a terraform script to create an AWS template for a static website.

## How to use it:

```bash

# The command apply is use to run the script,
# assignig the path and file name containing the access key to the AWS acount.

terraform apply -var 'key_name=mgmt_access_key' -var 'key_path=/path/file_name.pem'

# Before running the apply command, make sure you run the plan command that shows the changes that will take place.

terraform plan -var 'key_name=mgmt_access_key' -var 'key_path=/path/file_name.pem'


