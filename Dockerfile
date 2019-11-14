FROM openfaas/faas-cli:0.9.2

ARG faas_custom_templates_uri
ARG container_registry
ARG branch

ARG gateway
ARG environment

ARG gateway_username
ARG gateway_password

ARG docker_username
ARG docker_password
ARG github_username
ARG github_password

ENV faas_custom_templates_uri=${faas_custom_templates_uri}
ENV container_registry=${container_registry}
ENV branch=${branch}

ENV gateway=${gateway}
ENV environment=${environment}

ENV gateway_username=${gateway_username}
ENV gateway_password=${gateway_password}

ENV docker_username=${docker_username}
ENV docker_password=${docker_password}
ENV github_username=${github_username}
ENV github_password=${github_password}

RUN apk add docker
RUN apk add bash
RUN apk update

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
