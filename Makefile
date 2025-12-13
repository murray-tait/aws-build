date=$$(date '+%Y.%m.%d.%H.%M')
export AWS_PROFILE=973963482762_AWSAdministratorAccess

init:
	cd terraform && terraform init

plan:
	cd terraform && terraform plan

apply:
	cd terraform && terraform apply

state:
	cd terraform && terraform state list

tag:
	git tag v${date}
	git push origin tag v${date}