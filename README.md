# Portworx

[Portworx](https://portworx.com/) is a software defined persistent storage solution designed and purpose built for applications deployed as containers, via container orchestrators such as Kubernetes, Marathon and Swarm. It is a clustered block storage solution and provides a Cloud-Native layer from which containerized stateful applications programmatically consume block, file and object storage services directly through the scheduler.

## Limitations
* The portworx helm chart can only be deployed in the kube-system namespace. Hence use "kube-system" in the "Target namespace" during configuration.
* You can only deploy one portworx helm chart per Kubernetes cluster.

## Deploying the AWS Marketplace Portworx Enterprise image

Since we will be using the AWS Marketplace ECS Image Registry
We will ahve to first get the authorization token:

```bash
aws ecr --region=us-east-1 get-authorization-token --output text --query authorizationData[].authorizationToken | base64 -d | cut -d: -f2
```

Then we will use this to create the Secret. Don't forget to replace TOKEN and EMAIL
with your own values:

```bash
kubectl create secret docker-registry aws-marketplace-credentials \
 --docker-server=217273820646.dkr.ecr.us-east-1.amazonaws.com \
 --docker-username=AWS \
 --docker-password="TOKEN" \
 --docker-email="EMAIL"
```

To install the chart with the release name `my-release` run the following commands substituting relevant values for your setup:
Make sure tos et the customRegistry value and the registrySecret.

```bash
helm install my-release https://github.com/portworx/aws-helm/raw/master/portworx-2.5.3.tgz \
--set storage.drives="type=gp2\,size=100" --set customRegistryURL=217273820646.dkr.ecr.us-east-1.amazonaws.com/3a3fcb1c-7ee5-4f3b-afe3-d293c3f9beb4/cg-3746887092 --set registrySecret=aws-marketplace-credentials
```

##### NOTE:
`clusterName` should be a unique name identifying your Portworx cluster. The default value is `mycluster`, but it is suggested to update it with your naming scheme.

## Configuration
The following tables lists the configurable parameters of the Portworx chart and their default values.

| Parameter | Description |
|--------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `awsProductID` | Portworx Product Id, PX-Enterprise: 3a3fcb1c-7ee5-4f3b-afe3-d293c3f9beb4 , PX-Enterprise + DR: d9792c12-2f12-4baf-8b18-baee3245ccd9 |
| `clusterName` | Portworx Cluster Name |
| `imageVersion` | The image tag to pull |
| `usefileSystemDrive` | Should Portworx use an unmounted drive even with a filesystem ? |
| `usedrivesAndPartitions` | Should Portworx use the drives as well as partitions on the disk ? |
| `drives` | Semi-colon seperated list of drives to be used for storage (example: "/dev/sda;/dev/sdb"), to auto generate amazon disks use a list of drive specs (example: "type=gp2\,size=150";type=io1\,size=100\,iops=2000"). Make sure you escape the commas |
| `journalDevice` | Journal device for Portworx metadata |
| `metadataSize` | 0 |
| `dataInterface` | Name of the interface <ethX> |
| `managementInterface` | Name of the interface <ethX> |
| `secretType` | Secrets store to be used can be aws-kms/k8s/none defaults to: none |
| `envVars` | semi-colon-separated list of environment variables that will be exported to portworx. (example: MYENV1=val1;MYENV2=val2) |
| `advOpts` | advanced options, do not use unless instructed by portworx-support |
| `storkVersion` | The version of stork [Storage Orchestration for Hyperconvergence](https://github.com/libopenstorage/stork).  |
| `csi` | Enable CSI (Tech Preview only) defaults to: false |
| `internalKVDB` | Internal KVDB store defaults to: true (only option currently) |
| `changePortRange` | When set to true the new range starts at 17000 |
| `customRegistryURL` | Replace this with the custom registry from AWS |
| `registrySecret` | Name of the custom registry secret |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

> **Tip** > The Portworx configuration files under `/etc/pwx/` directory are preserved, and will not be deleted.

```
helm delete my-release
```
The command removes all the Kubernetes components associated with the chart and deletes the release.

## Documentation
* [Portworx docs site](https://docs.portworx.com/scheduler/kubernetes/)
* [Portworx interactive tutorials](https://docs.portworx.com/scheduler/kubernetes/px-k8s-interactive.html)

## Support

Please contact us at support@portworx.com with the generated log files.

We are always available on Slack. Join us on [Slack](http://slack.portworx.com)
