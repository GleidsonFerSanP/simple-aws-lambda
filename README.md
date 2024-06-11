# simple-aws-node-lambda

cd aws-lambda-node on the selected account folder
terraform apply -var-file="../second-account.tfvars"

cd resources on main account folders
terraform apply -var-file="../main-account.tfvars"