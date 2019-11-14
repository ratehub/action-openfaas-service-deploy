# Service deployment action for OpenFaaS

This action will deploy your service to an OpenFaaS gateway.

### Assumptions
1. You have `faas-cli` installed. It's a repo on GitHub, you can find it here: [https://github.com/openfaas/faas-cli](https://github.com/openfaas/faas-cli)
2. You're logged into your OpenFaaS gateway (`faas-cli login`)
3. Your service uses `.yml` files for its configuration. This action copies `env-staging.yml` or `env-prod.yml` to `env.yml` during its execution.†

### Usage
You can use this action by including it into an existing workflow. For example:
```
name: My application workflow
on:
  push:
    branches:
    - master
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@master
    - name: Get the executing environment
      shell: bash
      run: |
        echo "##[set-output name=env;]$(echo `[[ ${GITHUB_REF##*/} == 'master' ]] && echo 'production' || echo 'staging'`)"
      id: extract_meta
    - name: Run my tests
      run: |
        npm install
        npm test
    - name: Build, push, and deploy my action as a function
      if: success()
      uses: ratehub/action-openfaas-service-deploy@master
      env:
        faas_custom_templates_uri: https://faas-templates.example.com
        environment: ${{ steps.extract_meta.outputs.env }}
        gateway: https://faas.example.com
        container_registry: https://gcr.io
        gateway_username: gateway_user
        gateway_password: gateway_password
        docker_username: docker_username
        docker_password: docker_password
```

### Environment Configuration:
The following variables are required for this action:
* environment -- We currently use `production` or `staging`
* gateway -- The uri of the faas gateway
* container_registry -- Where we should do a docker login
* gateway_username -- Used with `faas-cli login`
* gateway_password -- Used with `faas-cli login`
* docker_username -- Used with `docker login`
* docker_password -- Used with `docker login`

The following variables are optional for this action:
* faas_custom_templates_uri -- Location for custom faas template pull

†: This is not best practice and is subject to change. It is what it is for now.
