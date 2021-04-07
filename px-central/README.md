# PX-Central
PX-Central is a unified, multi-user, multi-cluster management interface.
This chart also supports following features but by default those are disabled.
  1. PX-Central
  2. PX-Backup

#### Installation
To add the Portworx AWS Helm repository run the following command:
```
helm repo add portworx https://raw.githubusercontent.com/portworx/aws-helm/master/stable
```

To install the chart with the release name `central` run the following commands substituting relevant values for your setup
```
helm install px-central portworx/px-central --namespace px-backup --set persistentStorage.enabled=true,persistentStorage.storageClassName=gp2,pxbackup.enabled=true,pxbackup.datastore=mongodb
```

#### Preparing your EKS Cluster

Before we can create an IAMServiceAccount for PX-Backup so we can send metering data to AWS,
we need to enable the IAM OIDC Provider for your EKS cluster.
Make sure to replace `<clustername>` with your EKS cluster and change the `region` if you are not running in us-east-1
```
eksctl utils associate-iam-oidc-provider --region=us-east-1 --cluster=<clustername> --approve
```

Second we have to create the IAMServiceAccount with the appropriate permissions.
Make sure to change the namespace if you are not deploying in `px-backup` and make sure to replace `<clustername>` with your EKS cluster
```
eksctl create iamserviceaccount --name px-backup-account  --namespace px-backup --cluster <clustername> --attach-policy-arn arn:aws:iam::aws:policy/AWSMarketplaceMeteringFullAccess \
--attach-policy-arn arn:aws:iam::aws:policy/AWSMarketplaceMeteringRegisterUsage --approve --override-existing-serviceaccounts
```

This will create an `IAMServiceAccount` on amazon `https://console.aws.amazon.com/iam/home?#/roles` and
will update existing `ServiceAcccount (px-backup-account)`

## Parameters

The following tables lists the configurable parameters of the PX-Backup chart and their default values.

### PX-Central parameters

Parameter | Description | Default
--- | --- | ---
`persistentStorage` | Persistent storage for all px-central components | `""`
`persistentStorage.enabled` | Enable persistent storage | `false`
`persistentStorage.storageClassName` | Provide storage class name which exists | `""`
`persistentStorage.mysqlVolumeSize` | MySQL volume size | `"100Gi"`
`persistentStorage.etcdVolumeSize` | ETCD volume size | `"64Gi"`
`persistentStorage.keycloakThemeVolumeSize` | Keycloak frontend theme volume size | `"5Gi"`
`persistentStorage.keycloakBackendVolumeSize` | Keycloak backend volume size | `"10Gi"`
`storkRequired` | Scheduler name as stork | `false`
`pxcentralDBPassword` | PX-Central cluster store mysql database password | `Password1`
`caCertsSecretName` | Name of the Kubernetes Secret, which contains the CA Certificates. | `""`
`oidc` | Enable OIDC for PX-Central and PX-backup for RBAC | `""`
`oidc.centralOIDC` | PX-Central OIDC | `""`
`oidc.centralOIDC.enabled` | PX-Central OIDC | `true`
`oidc.centralOIDC.defaultUsername` | PX-Central OIDC username | `admin`
`oidc.centralOIDC.defaultPassword` | PX-Central OIDC admin user password | `admin`
`oidc.centralOIDC.defaultEmail` | PX-Central OIDC admin user email | `admin@portworx.com`
`oidc.centralOIDC.keyCloakBackendUserName` | Keycloak backend store username | `keycloak`
`oidc.centralOIDC.keyCloakBackendPassword` | Keycloak backend store password | `keycloak`
`oidc.centralOIDC.clientId` | PX-Central OIDC client id | `pxcentral`
`oidc.centralOIDC.updateAdminProfile` | Enable/Disable admin profile update action | `true`
`oidc.externalOIDC` | Enable external OIDC provider | `""`
`oidc.externalOIDC.enabled` | Enabled external OIDC provider | `false`
`oidc.externalOIDC.clientID` | External OIDC client ID | `""`
`oidc.externalOIDC.clientSecret` | External OIDC client secret | `""`
`oidc.externalOIDC.endpoint` | External OIDC endpoint | `""`
`securityContext` | Security context for the pod | `{runAsUser: 1000, fsGroup: 1000, runAsNonRoot: true}`
`images.pullSecrets` | Image pull secrets | `docregistry-secret`
`images.pullPolicy` | Image pull policy | `Always`
`images.pxcentralApiServerImage.registry` | API server image registry | `docker.io`
`images.pxcentralApiServerImage.repo` | API server image repo | `portworx`
`images.pxcentralApiServerImage.imageName` | API server image name | `pxcentral-onprem-api`
`images.pxcentralApiServerImage.tag` | API server image tag | `1.2.1`
`images.pxcentralFrontendImage.registry` | PX-Central frontend image registry | `docker.io`
`images.pxcentralFrontendImage.repo` | PX-Central frontend image repo | `portworx`
`images.pxcentralFrontendImage.imageName` | PX-Central frontend image name | `pxcentral-onprem-ui-frontend`
`images.pxcentralFrontendImage.tag` | PX-Central frontend image tag | `1.2.2`
`images.pxcentralBackendImage.registry` | PX-Central backend image registry | `docker.io`
`images.pxcentralBackendImage.repo` | PX-Central backend image repo | `portworx`
`images.pxcentralBackendImage.imageName` | PX-Central backend image name | `pxcentral-onprem-ui-backend`
`images.pxcentralBackendImage.tag` | PX-Central backend image tag | `1.2.2`
`images.pxcentralMiddlewareImage.registry` | PX-Central middleware image registry | `docker.io`
`images.pxcentralMiddlewareImage.repo` | PX-Central middleware image repo | `portworx`
`images.pxcentralMiddlewareImage.imageName` | PX-Central middleware image name | `pxcentral-onprem-ui-lhbackend`
`images.pxcentralMiddlewareImage.tag`| PX-Central middleware image tag | `1.2.2`
`images.postInstallSetupImage.registry` | PX-Backup post install setup image registry | `docker.io`
`images.postInstallSetupImage.repo` | PX-Backup post install setup image repo | `portworx`
`images.postInstallSetupImage.imageName` | PX-Backup post install setup image name | `pxcentral-onprem-post-setup`
`images.postInstallSetupImage.tag` | PX-Backup post install setup image tag | `1.2.2`
`images.keycloakBackendImage.registry` | PX-Backup keycloak backend image registry | `docker.io`
`images.keycloakBackendImage.repo` | PX-Backup keycloak backend image repo | `bitnami`
`images.keycloakBackendImage.imageName` | PX-Backup keycloak backend image name | `postgresql`
`images.keycloakBackendImage.tag` | PX-Backup keycloak backend image tag | `11.7.0-debian-10-r9`
`images.keycloakFrontendImage.registry` | PX-Backup keycloak frontend image registry | `docker.io`
`images.keycloakFrontendImage.repo` | PX-Backup keycloak frontend image repo | `jboss`
`images.keycloakFrontendImage.imageName` | PX-Backup keycloak frontend image name | `keycloak`
`images.keycloakFrontendImage.tag` | PX-Backup keycloak frontend image tag | `9.0.2`
`images.keycloakLoginThemeImage.registry` | PX-Backup keycloak login theme image registry | `docker.io`
`images.keycloakLoginThemeImage.repo` | PX-Backup keycloak login theme image repo | `portworx`
`images.keycloakLoginThemeImage.imageName` | PX-Backup keycloak login theme image name | `keycloak-login-theme`
`images.keycloakLoginThemeImage.tag` | PX-Backup keycloak login theme image tag | `1.0.4`
`images.keycloakInitContainerImage.registry` | PX-Backup keycloak init container image registry | `docker.io`
`images.keycloakInitContainerImage.repo` | PX-Backup keycloak init container image repo | `library`
`images.keycloakInitContainerImage.imageName` | PX-Backup keycloak init container image name | `busybox`
`images.keycloakInitContainerImage.tag` | PX-Backup keycloak init container image tag | `1.31`
`images.mysqlImage.registry` | PX-Central cluster store mysql image registry | `docker.io`
`images.mysqlImage.repo` | PX-Central cluster store mysql image repo | `library`
`images.mysqlImage.imageName` | PX-Central cluster store mysql image name | `mysql`
`images.mysqlImage.tag` | PX-Central cluster store mysql image tag | `5.7.22`

### PX-Backup parameters

Parameter | Description | Default
--- | --- | ---
`images` | PX-Backup deployment images | `""`
`pxbackup.enabled` | Enabled PX-Backup | `false`
`pxbackup.orgName` | PX-Backup organization name | `default`
`pxbackup.nodeAffinityLabel` | Label for node affinity for px-central components| `""`
`images.pxBackupImage.registry` | PX-Backup image registry | `docker.io`
`images.pxBackupImage.repo` | PX-Backup image repo | `portworx`
`images.pxBackupImage.imageName` | PX-Backup image name | `px-backup`
`images.pxBackupImage.tag` | PX-Backup image tag | `1.2.2`
`images.etcdImage.registry` | PX-Backup etcd image registry | `docker.io`
`images.etcdImage.repo` | PX-Backup etcd image repo | `bitnami`
`images.etcdImage.imageName` | PX-Backup etcd image name | `etcd`
`images.etcdImage.tag` | PX-Backup etcd image tag | `3.4.13-debian-10-r22`
`images.mongodbImage.registry` | PX-Backup etcd image registry | `docker.io`
`images.mongodbImage.repo` | PX-Backup etcd image repo | `bitnami`
`images.mongodbImage.imageName` | PX-Backup etcd image name | `mongodb`
`images.mongodbImage.tag` | PX-Backup etcd image tag | `4.4.4-debian-10-r30`

## Documentation
[TO be added]

## Support

Please contact us at support@portworx.com with the generated log files.

We are always available on Slack. Join us on [Slack](http://slack.portworx.com)
