# ecs-cluster
A Terraform project which can deploy an ECS Cluster

## Background

I recently had a couple of projects to work on that required a secure VPC configuring which would allow me to deploy images to an ECS Cluster in a quick and easy fashion. I've used Terraform in the past to do this kind of work, and I decided to share the design that I created.

 * Create a VPC similar to [the description here](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Scenario2.html), with a subnet in each availability zone (as I'm using the eu-west regions, there are only 3 availability zones to choose from) which uses an internet gateway for connectivity, hosts here need to have an associated public address, they are publically accessible (for example a bastion host)
 * Create another subnet in each availability zone which uses a NAT gateway for connectivity, hosts here cannot have a public IP associated and cannot be accessed from the outside world (this is where most hosts should live, if a web server needs to be accessed from the outside world it should be done through a load balancer)
 * Create a scaling group which can create instances that will be used as the capacity provider for an ECS cluster
 * Create the ECS cluster, task definitions and an ECR

I already knew how to do a lot of this, but ECS and ECR were new to me. After a lot of reading and plenty of trial and error I managed to get a working ECS cluster, and when I pushed an image to ECR it ran! However, if I updated the image, the running tasks were not replaced. Next I had to:

 * Create a lambda which was triggered by a CloudWatch alarm, this alarm looks for new images being pushed in to the ECR
 * This lambda is fairly simple, it just creates a new task definition and then updates the service
 * I did at one point make the lambda a little more complex, it checked to see if it was the first image in the repo and didn't run in this case, only running on subsequent pushes. This was because if the image was pushed the task was automatically published, then the lambda replaced that with another (identical) task. This required more permissions for the lambda and in the end I dropped it, as it didn't really impact operations in any way.
 * Later I added a second ECR, task definition, load balancer and lambda so that you could have 2 different tasks running in the same cluster and you can update it by pushing an image to it's own ECR and it should be published in the same way (the second container is configured to serve it's content on an internal load balancer, so perhaps an internal API server)

Once that was done, we have a nice development evironment for creating a new containerised web application.

Now if you create the infrastructure it will return the address for the ECR repo as well as the and then push a new image to the ECR, it will be automatically published on a secure VPC, with port forwarding and an Application Load Balancer configured to forward traffic to it.

Other features:

 * You can choose between running spot or on demand instances, since spot instances are up to about 75% cheaper, this can have a massive impact on the money you're spending in AWS
 * Service discovery rules
 * A pre-commit hook that will only allow you to proceed if `terraform validate` runs without error
 * It will find the latest ECS image when you deploy it, so it should be using the latest software

To use this you should update the variables file and add a region and cluster name (this name is used to create an s3 bucket so needs to be fairly unqiue)

## Environment

I tested this on ubuntu 18.04, with docker installed from [these instructions](https://docs.docker.com/install/linux/docker-ce/ubuntu/), latest terraform downloaded from [their website](https://www.terraform.io/downloads.html) which was Terraform v0.12.19. YMMV

## Test

You may have to run this command first depending on whether it has been run by your user previously or not, just update the region at the end:

`aws ecs put-account-setting-default --name serviceLongArnFormat --value enabled --region $REGION`


In order to test this, you can update the variables so you have the right region, ssh key (optional) and cluster name (this needs to be fairly unique), also check the right kind of instances are configured for your setup and the ports/protocols for the tasks are correct. Then:

```
cd terraform
terraform init
terraform plan
terraform apply
```

If this completes without errors (after you have confirmed it), you can then take the output ECR URLs and build a container with a tag which matches a repo URL and push it to the repo, this should then start running within a minute or so:

```
cd docker
docker build -t $endpoint_url_task_1 .
docker push $endpoint_url_task_1
```

# TODO

Paramerterise the load balancer port/type (application or network)/protocol
Both tasks currently run using the same IAM role, but this is probably not deisred (depends on the task)
