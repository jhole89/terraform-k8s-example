# okteto-hello-world
Example of running [hello-world](https://hub.docker.com/r/okteto/hello-world) on 
[okteto-cloud](https://cloud.okteto.com/) using pure terraform

Prerequisites
* [Terraform > 0.12](https://www.terraform.io/downloads.html)
* [Okteto Cloud account](https://cloud.okteto.com/#/login)

Steps:
1. Clone repo: `git clone git@github.com:jhole89/terraform-k8s-example.git`
2. Change to this directory: `cd okteto-hello-world`
3. Initialise terraform: `terraform init`
4. Copy tfvars template: `cp terraform.tfvars.template terraform.tfvars`
5. Fill in `terraform.tfvars` with Okteto values (found in your `okteto-kube.config` - make sure your
`okteto-kube.config` is also in your `~/.kube/config`)
6. Apply terraform plan: `tf apply --auto-approve` - you should see the following output
    ```
    kubernetes_deployment.example_deployment: Creating...
    kubernetes_deployment.example_deployment: Creation complete after 5s [id=jhole89/hello-world-deployment]
    kubernetes_service.example_service: Creating...
    kubernetes_service.example_service: Creation complete after 0s [id=jhole89/hello-world-service]

    Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

    Outputs:

    url = https://hello-world-service-jhole89.cloud.okteto.net/
    ```
6. The plan outputs the `url` exposed through the kubernetes service. You can now hit the endpoint using curl: 
`curl https://hello-world-service-jhole89.cloud.okteto.net/`
7. Once no longer required you can remove all resources: `terraform destroy --auto-approve`
