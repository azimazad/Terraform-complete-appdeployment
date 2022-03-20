**Terraform-Complete-MultiResource-AppDeployment**  

This projects is completely configured as infrastructre as code from terraform script which shows automation
of web application deployment and creation of various aws resources which include AWS INSTANCE, REMOTE-EXEC, S3 BUCKET (which will save backend.tf),
VPC, SUBNETS(public & privtae), Internet Gateway, Route tables & Association table.

**Requirements:**

1.Install terraform (v1.0.0 or later)  
2.Install Git  
3.AWS credentials to allow terraform create resources (Current Supported Way: Access and Secret Key).  

**How to run the project:**  

1. Open git bash  
2. Create a directory to clone the repo from github using 'mkdir'  
3. Use 'git clone' to clone the directory from github.  
4. User 'aws configure'  and put your access & sceret keys and confifure the cli.  
5. Run 'SSH-keygen' command to generate your own public and private keys, Default name of the key is demokey in the script if you want you can genearte with other name but remember to change the name of the key in terraform script "demokey".  
6. Run terraform init to setup the terraform backend - `terraform init` 
7. Apply terraform passing secret and access key as variables - `terraform apply -var 'access_key=****' -var 'secret_key=****'`  
8. Replace the variable values with your own credentials.  
9. Run terraform output to grab the public ip from the app instance = `terraform output app_instance_ip` 
10. Wait about four or five minutes after terraform ends the execution. This script uses the userdata from ec2 to configure the instance, 
it take some time.  
11. Use the public ip in your browser to see the message from the webapp hosted inside the ec2 instance.  
12. If you want to destroy the infrastructure, simple use terraform destroy command - `terraform destroy -var 'access_key=****' -var 'secret_key=****'` 

**KeyNotes:**  

1.The appdata is saved in web.sh file which while execute during creatition of our EC2 instance.  
2.The app artifcate is taken from https://www.tooplate.com/zip-templates/2117_infinite_loop.zip.  


## Terraform Defaults

- vpc_cidr_block     - 10.0.0.0/16
- public_cidr_block  - 10.0.1.0/24
- private_cidr_block - 10.0.2.0/24
- instance_type      - t2.micro
- image_id           - Amazon Linux 2
- Terraform Backend  - local folder
- region             - us-east-1
