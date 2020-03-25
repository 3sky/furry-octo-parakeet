# Furry Octo Parakeet

The name of project is random repo name and I like it.

This action support interaction with Google Cloud Run. 
Docker is based on `google/cloud-sdk:alpine` so it's quite fast and stable. 
For authentication only auth JSON file is needed, Rest of information like project ID
or accounts e-mail is taken from encoded JSON file.

To encode file run:

```bash
cat auth.json | base64
```

Then store it as a GitHub Secret.

## Inputs

### `auth_file`

**Required** Authentication file, stored as a secret. Default `""`.

### `action`

**Required** Supported Cloud Run action. Available actions are `run`, `update` and `delete`. Default `update`.

### `name`

**Required** Name of service. Default `My-service`.

### `region`

**Required** Region for deployment. Default `europe-west1`.

### `allow`

**Not Required** If true you will allow unauthenticated traffic. Default `false`.

### `port`

**Not Required** Port used by container. Default `80`.

### `image`

**Not Required** Container images to deploy. Default `gcr.io/cloud-marketplace/google/nginx1:latest`.


## Example usage

- Run new service

    ```yaml
    - name: Run new service  
      uses: 3sky/furry-octo-parakeet@master
      with:
        auth_file: ${{ secrets.gcp_sa_key }}
        action: 'run'
        name: 'basic-nginx'
        region: 'europe-west1'
        allow: true
        image: 'gcr.io/cloud-marketplace/google/nginx1:latest'
    ```

- Update service

    ```yaml
    - name: update app
      uses: 3sky/furry-octo-parakeet@master
      with:
        auth_file: ${{ secrets.gcp_sa_key }}
        action: 'update'
        name: 'basic-nginx'
        region: 'europe-west1'
        image: 'gcr.io/cloud-marketplace/google/nginx:1.15'
    ```

- Delete service

    ```yaml
    - name: Delete service
      uses: 3sky/furry-octo-parakeet@master
      with:
        auth_file: ${{ secrets.gcp_sa_key }}
        action: 'delete'
        name: 'basic-nginx'
        region: 'europe-west1'
    ```

