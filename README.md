# Portworx

[Portworx](https://portworx.com/) is a software defined persistent storage solution designed and purpose built for applications deployed as containers, via container orchestrators such as Kubernetes, Marathon and Swarm. It is a clustered block storage solution and provides a Cloud-Native layer from which containerized stateful applications programmatically consume block, file and object storage services directly through the scheduler.

## Limitations
* You can only deploy one portworx helm chart per Kubernetes cluster.

## Deploying the AWS Marketplace Portworx Enterprise image

Since we will be using the AWS Marketplace ECS Image Registry
We will have to first get the authorization token:

```bash
aws ecr --region=us-east-1 get-authorization-token --output text --query authorizationData[].authorizationToken | base64 -d | cut -d: -f2
```

Then we will use this to create the Secret. Don't forget to replace TOKEN and EMAIL
with your own values and change the namespace if you are deploying portworx outside of `kube-system`:

```bash
kubectl create secret docker-registry aws-marketplace-credentials -n kube-system \
 --docker-server=217273820646.dkr.ecr.us-east-1.amazonaws.com \
 --docker-username=AWS \
 --docker-password="TOKEN" \
 --docker-email="EMAIL"
```

Next we have to make sure we create an IAMServiceAccount for Portworx so we can send metering data to AWS.
First we enable the IAM OIDC Provider for your EKS cluster.
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

Finally,
To install the chart with the release name `my-release` run the following commands substituting relevant values for your setup:
Make sure to set the registrySecret.

```bash
helm install my-release https://github.com/portworx/aws-helm/raw/master/portworx-2.6.1.tgz \
--set storage.drives="type=gp2\,size=100" --set registrySecret=aws-marketplace-credentials \
--set namespace=kube-system --set aws.serviceAccount.name="portworx-aws"
```

##### NOTE:
`clusterName` should be a unique name identifying your Portworx cluster. The default value is `mycluster`, but it is suggested to update it with your naming scheme.

## Configuration
The following tables lists the configurable parameters of the Portworx chart and their default values.

| Parameter | Description |
|--------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `awsProduct` | Portworx Product Name, PX-ENTERPRISE or PX-ENTERPRISE+DR (Defaults to PX-ENTERPRISE) |
| `clusterName` | Portworx Cluster Name |
| `namespace` | Namespace in which to deploy portworx (Defaults to kube-system) |
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
| `changePortRange` | When set to true the new range starts at 17000 |
| `customRegistryURL` | Replace this with the custom registry from AWS |
| `registrySecret` | Name of the custom registry secret |
| `aws.serviceAcccount` | Name of the created service account with required IAM permissions |

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
