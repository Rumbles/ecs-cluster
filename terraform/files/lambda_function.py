import boto3
import sys

def lambda_handler(event,context):

    ecs = boto3.client("ecs")

    repository_url = ""
    event_details = event.get("detail", None)

    if event_details:
        request_params = event_details.get("requestParameters", None)

        if request_params:
            print(str(request_params))

            repo_name = request_params.get("repositoryName")
            registry_id = request_params.get("registryId")
            image_tag = request_params.get("imageTag")

            ecr = boto3.client("ecr")

            response = ecr.describe_images(
                registryId=registry_id,
                repositoryName=repo_name,
            )

            if len(response['imageDetails']) > 1:

                response = ecr.describe_repositories(
                    registryId=registry_id,
                    repositoryNames=[
                        repo_name,
                    ]
                )

                repo_uri = response["repositories"][0]["repositoryUri"]
                repository_url = f"{repo_uri}:{image_tag}"
            else:
                print("First image, not running")
                sys.exit(0)

    # This is here for if you run the lambda from a test event, it will just
    # publish the latest image
    if not repository_url:
        print("Test event, publishing latest")
        repository_url = "${repository_url}:latest"

    response = ecs.register_task_definition(
        family="${cluster_name}",
        taskRoleArn="${ecs_task_role}",
        networkMode="bridge",
        containerDefinitions=[
            {
                "name": "${cluster_name}",
                "image": repository_url,
                "cpu": 128,
                "memoryReservation": 128,
                "portMappings": [
                    {
                        "containerPort": ${container_port},
                        "protocol": "${container_protocol}"
                    }
                ],
                "command": [
                    "nginx", "-g", "daemon off;"
                ],
                "essential": True
            }
        ],
        placementConstraints=[
            {
                "type": "memberOf",
                "expression": "${placement_expression}"
            },
        ],
        requiresCompatibilities=[
            "EC2",
        ]
    )

    task_definition = response["taskDefinition"]["family"] + ":" + str(response["taskDefinition"]["revision"])

    response = ecs.update_service(
        cluster="${cluster_arn}",
        service="${service_name}",
        desiredCount=${desired_count},
        taskDefinition=task_definition,
        deploymentConfiguration={
            'maximumPercent': 400,
            'minimumHealthyPercent': 50
        }
    )

    print("New container deployed.")
