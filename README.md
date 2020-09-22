# Portworx

[Portworx](https://portworx.com/) is a software defined persistent storage solution designed and purpose built for applications deployed as containers, via container orchestrators such as Kubernetes, Marathon and Swarm. It is a clustered block storage solution and provides a Cloud-Native layer from which containerized stateful applications programmatically consume block, file and object storage services directly through the scheduler.

#### Preparing your EKS Cluster

Before we can create an IAMServiceAccount for Portworx so we can send metering data to AWS.
we need to enable the IAM OIDC Provider for your EKS cluster.
Make sure to replace `<clustername>` with your EKS cluster and change the `region` if you are not running in us-east-1
```
eksctl utils associate-iam-oidc-provider --region=us-east-1 --cluster=<clustername> --approve
```

Second we have to create the IAMServiceAccount with the appropriate permissions.
Make sure to change the namespace if you are not deploying in `kube-system` and make sure to replace `<clustername>` with your EKS cluster
```
eksctl create iamserviceaccount --name portworx-aws --namespace kube-system --cluster <clustername> --attach-policy-arn arn:aws:iam::aws:policy/AWSMarketplaceMeteringFullAccess \
--attach-policy-arn arn:aws:iam::aws:policy/AWSMarketplaceMeteringRegisterUsage --approve --override-existing-serviceaccounts
```

This will create an `IAMServiceAccount` on amazon `https://console.aws.amazon.com/iam/home?#/roles` and
will create a `ServiceAcccount` in the requested namespace, which we will pass to our helmchart.


#### Installation
To add the Portworx AWS Helm repository run the following command:
```
helm repo add portworx https://raw.githubusercontent.com/portworx/aws-helm/master/stable
```

To install the chart with the release name `my-release` run the following commands substituting relevant values for your setup
```
helm install my-release portworx/portworx --set storage.drives="type=gp2\,size=1000" --set namespace=kube-system --set serviceAccount="portworx-aws"
```

##### NOTE:
`clusterName` should be a unique name identifying your Portworx cluster. The default value is `mycluster`, but it is suggested to update it with your naming scheme.

## Configuration
The following tables lists the configurable parameters of the Portworx chart and their default values.

| Parameter | Description |
|--------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `awsProduct` | Portworx Product Name, PX-ENTERPRISE or PX-ENTERPRISE-DR (Defaults to PX-ENTERPRISE) |
| `clusterName` | Portworx Cluster Name |
| `namespace` | Namespace in which to deploy portworx (Defaults to kube-system) |
| `storage.usefileSystemDrive` | Should Portworx use an unmounted drive even with a filesystem ? |
| `storage.usedrivesAndPartitions` | Should Portworx use the drives as well as partitions on the disk ? |
| `storage.drives` | Semi-colon seperated list of drives to be used for storage (example: "/dev/sda;/dev/sdb"), to auto generate amazon disks use a list of drive specs (example: "type=gp2\,size=150";type=io1\,size=100\,iops=2000"). Make sure you escape the commas |
| `storage.journalDevice` | Journal device for Portworx metadata |
| `storage.maxStorageNodesPerZone` | Indicates the maximum number of storage nodes per zone. If this number is reached, and a new node is added to the zone, Portworx doesn’t provision drives for the new node. Instead, Portworx starts the node as a compute-only node. |
| `network.dataInterface` | Name of the interface <ethX> |
| `network.managementInterface` | Name of the interface <ethX> |
| `secretType` | Secrets store to be used can be aws-kms/k8s/none defaults to: none |
| `envVars` | semi-colon-separated list of environment variables that will be exported to portworx. (example: MYENV1=val1;MYENV2=val2) |
| `serviceAcccount` | Name of the created service account with required IAM permissions |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

## Un-installing Portworx

Edit the storage cluster.
```bash
kubectl -n <namespace> edit storagecluster <yourclustername>
```

Add the following yaml under `spec:`

```bash
deleteStrategy:
    type: UninstallAndWipe
```

Save the spec and exit out.
Then delete the storagecluster

```bash
kubectl -n <namespace> delete storagecluster <yourclustername>
```

Once all the portworx related pods are gone
un-install/delete the `my-release` deployment:

```
helm delete my-release
```
This command removes all the Kubernetes components associated with the chart and deletes the release.

## Documentation
* [Portworx docs site](https://docs.portworx.com/scheduler/kubernetes/)
* [Portworx interactive tutorials](https://docs.portworx.com/scheduler/kubernetes/px-k8s-interactive.html)

## Support

Please contact us at support@portworx.com with the generated log files.

We are always available on Slack. Join us on [Slack](http://slack.portworx.com)
