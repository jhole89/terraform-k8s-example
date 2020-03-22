# minikube-echoserver
Example of running [echoserver](https://console.cloud.google.com/gcr/images/google-containers/GLOBAL/echoserver) on 
minikube using pure terraform

Prerequisites
* [Terraform > 0.12](https://www.terraform.io/downloads.html)
* [minikube > 1.5.2](https://kubernetes.io/docs/tasks/tools/install-minikube/)

Steps:
1. Start minikube: `minikube start`
2. Clone repo: `git clone git@github.com:jhole89/terraform-k8s-example.git`
3. Change to this directory: `cd minikube-echoserver`
4. Initialise terraform: `terraform init`
5. Apply terraform plan: `tf apply --auto-approve` - you should see the following output
    ```
    kubernetes_namespace.example_namespace: Creating...
    kubernetes_namespace.example_namespace: Creation complete after 0s [id=example-app-namespace]
    kubernetes_deployment.example_deployment: Creating...
    kubernetes_deployment.example_deployment: Creation complete after 5s [id=example-app-namespace/example-app-deployment]
    kubernetes_service.example_service: Creating...
    kubernetes_service.example_service: Creation complete after 1s [id=example-app-namespace/example-app-service]

    Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

    Outputs:

    node_port = 31740
    ```
6. The plan outputs the `node_port` exposed through the kubernetes service (here it was 31740). You can now hit the 
endpoint using curl: `curl $(minikube ip):31740`
7. Once no longer required you can remove all resources: `terraform destroy --auto-approve`
8. Stop minikube: `minikube stop`
