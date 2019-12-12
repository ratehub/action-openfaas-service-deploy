#!/bin/bash -l

echo "Starting deployment process"

git diff HEAD HEAD~1 --name-only > differences.txt

#Assume staging
cp env-staging.yml env.yml

# Depending on which branch we want to choose a different set of environment variables and credentials
if [[ "${environment}" == "production" ]];
then
    cp env-prod.yml env.yml
fi
if [[ ! -z ${gateway} ]];
then
  echo "JACOBDEBUG"
  cat  env.yml
  echo "  GATEWAY: ${gateway}" >> env.yml
fi

docker login -u "${docker_username}" -p "${docker_password}" "${container_registry}"

faas-cli template pull

if [[ ! -z ${faas_custom_templates_uri} ]]; then
    echo "Pulling custom templates..."
    faas-cli template pull "${faas_custom_templates_uri}"
fi

faas-cli login --username="${gateway_username}" --password="$gateway_password" --gateway="${gateway}"


faas-cli build
faas-cli push
faas-cli deploy --gateway="${gateway}"

echo "Finished function deployment process"
