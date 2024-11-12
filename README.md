# Nexus OSS

[Nexus][Docs] — platform for storing build artifacts

> [Docs] | [GitHub]

Building [image][] Nexus3 based on `eclipse-temurin:17-jre`, with
fix to issue requiring permissions on mount directories.

## Deployment

* [Deployment](#deployment)
* [Preparation and installation](#preparation-and-installation)
  * [Preparing overlays](#preparing-overlays)
  * [Creating a secret](#creating-a-secret)
  * [Deploy](#deploy)

This deployment is based on [kustomize][]. It features logging to disk, all logs
are redirected to the console.

## Preparation and installation

### Preparing overlays

If you need to make any changes to the basic configuration, then you must to
create a project with the configuration.

* Create a project with a configuration and create an overlay there referring to
  this base
* If necessary, you can apply a patch to change:
* Resource request and limit
* Storage class
* Storage size
* You can also make changes to the configuration files.

At the current moment, the deployment of this database is maximally configured
to work with the current resource values.

### Creating a secret

Create a secret with an [encryption key][]

```bash
export NAMESPACE=nexus
cat << EOF >> secret.json
{
  "active": "secret-key",
  "keys": [
    {
      "id": "secret-key",
      "key": "you-secret-key"
    }
  ]
}
EOF
kubectl create secret -n $NAMESPACE generic nexus-secret-key --from-file secret.json
```

### Deploy

Deploy Nexus using the example base

```bash
kubectl create -n $NAMESPACE -k deploy/
```

<!-- Links -->

[Docs]: https://help.sonatype.com/en/sonatype-nexus-repository.html
[GitHub]: https://github.com/sonatype/nexus-public/
[image]: https://github.com/sonatype/docker-nexus3
[kustomize]: https://kubectl.docs.kubernetes.io/
[encryption key]: https://help.sonatype.com/en/re-encryption-in-nexus-repository.html
