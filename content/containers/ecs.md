+++
title = "Amazon Elastic Container Service and Elastic Container Registry"
description = "Amazon ECS registry service and Chef Habitat"


[menu.containers]
    title = "Amazon container services"
    identifier = "containers/ecs EC2 Container Service"
    parent = "containers"
    weight = 50
+++

Amazon Web Services provides a container management service called [Elastic Container Service (ECS)](https://aws.amazon.com/ecs/). ECS provides a Docker registry, container hosting, and tooling to make deploying Docker-based containers straightforward. ECS schedules and deploys your Docker containers within a task while Chef Habitat manages the applications.

## Elastic Container Registry (ECR)

[Elastic Container Registry (ECR)](https://aws.amazon.com/ecr/) is a fully managed Docker registry from Amazon Web Services. Applications exported to Docker with `hab pkg export container` put the containers into namespaced repositories, so you'll need to create these within ECR. For example, if you were building `core/mongodb` containers, you would use the following command:

```bash
aws ecr create-repository --repository-name core/mongodb
```

To tag and push the images to the ECR you will use your repository URI:

```bash
docker tag core/mongodb:latest <AWS_ACCOUNT_ID>.dkr.ecr.<AWS_REGION>.amazonaws.com/core/mongodb:latest
docker push <AWS_ACCOUNT_ID>.dkr.ecr.<AWS_REGION>.amazonaws.com/core/mongodb:latest
```

In the previous commands, replace the following:

- `<AWS_ACCOUNT_ID>` with your AWS account ID.
- `<AWS_REGION>` with your AWS region, for example, `ap-southeast-2`.

## Elastic Container Service (ECS)

Once Docker images are pushed to ECR, you can run them on Amazon ECS within a [task definition](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_defintions.html) that can be expressed as a [Docker Compose file](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/cmd-ecs-cli-compose.html).

Here is an example of a Tomcat application using a Mongo database demonstrating using Chef Habitat-managed containers:

```yaml docker-compose.yml
version: '2'
services:
  mongo:
    image: <AWS_ACCOUNT_ID>.dkr.ecr.<AWS_REGION>.amazonaws.com/username/mongodb:latest
    hostname: "mongodb"
  national-parks:
    image: <AWS_ACCOUNT_ID>.dkr.ecr.<AWS_REGION>.amazonaws.com/username/national-parks:latest
    ports:
      - "8080:8080"
    links:
      - mongo
    command: --peer mongodb --bind database:mongodb.default
```

From the example, the `mongo` and `national-parks` services use the Docker images from Amazon ECR. The `links` entry manages the deployment order of the container and according to the [Docker Compose documentation](https://docs.docker.com/engine/userguide/networking/default_network/dockerlinks/#/updating-the-etchosts-file), `links` creates `/etc/hosts` entries. This doesn't currently work with ECS, so we assign the `hostname: "mongodb"`.

The `command` entry for the National Parks Tomcat application allows the Chef Habitat Supervisor to `--peer` to the `mongo` gossip ring and `--bind` applies `database` entries to its Mongo configuration.

## Related reading

- [A Journey with Chef Habitat on Amazon ECS, Part 1](https://www.chef.io/blog/a-journey-with-habitat-on-amazon-ecs-part-1)
- [A Journey with Chef Habitat on Amazon ECS, Part 2](https://www.chef.io/blog/a-journey-with-habitat-on-amazon-ecs-part-2)
