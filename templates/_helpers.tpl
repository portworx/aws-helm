{{- define "px.getProductID" -}}
{{- $product := .Values.awsProduct | default "PX-ENTERPRISE" }}
    {{- if eq $product "PX-ENTERPRISE-DR" }}
        {{- cat "6a97e814-fbe5-4ae3-a3e2-14ca735b5e6b" }}
    {{- else }}
        {{- cat "3a3fcb1c-7ee5-4f3b-afe3-d293c3f9beb4" }}
    {{- end }}
{{- end -}}

{{- define "px.getImage" -}}
{{- $product := .Values.awsProductID | default "PX-ENTERPRISE" }}
{{- if (.Values.customRegistryURL) -}}
  {{- if (eq "/" (.Values.customRegistryURL | regexFind "/")) -}}
    {{- cat (trim .Values.customRegistryURL) "/px-enterprise:" (trim .Values.versions.enterprise) | replace " " ""}}
  {{- else -}}
    {{- cat (trim .Values.customRegistryURL) "/portworx/px-enterprise:" (trim .Values.versions.enterprise)| replace " " ""}}
  {{- end -}}
{{- else -}}
  {{- cat "portworx/px-enterprise:" (trim .Values.versions.enterprise) | replace " " "" }}
{{- end -}}
{{- end -}}

{{- define "px.getOCIImage" -}}
{{- $product := .Values.awsProductID | default "PX-ENTERPRISE" }}
{{- if (.Values.customRegistryURL) -}}
  {{- if (eq "/" (.Values.customRegistryURL | regexFind "/")) -}}
    {{- cat (trim .Values.customRegistryURL) "/oci-monitor:" (trim .Values.versions.ociMon) | replace " " ""}}
  {{- else -}}
    {{- cat (trim .Values.customRegistryURL) "/portworx/oci-monitor:" (trim .Values.versions.ociMon)| replace " " ""}}
  {{- end -}}
{{- else -}}
  {{- if eq $product "PX-ENTERPRISE+DR" }}
    {{- cat (trim .Values.aws.repos.dr) "/portworx/oci-monitor:" (trim .Values.aws.versions.dr) | replace " " ""}}
  {{- else }}
    {{- cat (trim .Values.aws.repos.enterprise) "/portworx/oci-monitor:" (trim .Values.aws.versions.enterprise) | replace " " ""}}
  {{- end -}}
{{- end -}}
{{- end -}}

{{- define "px.getStorkImage" -}}
{{- $product := .Values.awsProductID | default "PX-ENTERPRISE" }}
{{- if (.Values.customRegistryURL) -}}
  {{- if (eq "/" (.Values.customRegistryURL | regexFind "/")) -}}
    {{- cat (trim .Values.customRegistryURL) "/stork:" (trim .Values.versions.stork)| replace " " ""}}
  {{- else -}}
    {{- cat (trim .Values.customRegistryURL) "/openstorage/stork:" (trim .Values.versions.stork) | replace " " ""}}
  {{- end -}}
{{- else -}}
  {{- if eq $product "PX-ENTERPRISE+DR" }}
    {{- cat (trim .Values.aws.repos.dr) "/openstorage/stork:" (trim .Values.aws.versions.dr) | replace " " ""}}
  {{- else }}
    {{- cat (trim .Values.aws.repos.enterprise) "/openstorage/stork:" (trim .Values.aws.versions.enterprise) | replace " " ""}}
  {{- end -}}
{{- end -}}
{{- end -}}

{{- define "px.getAutopilotImage" -}}
{{- $product := .Values.awsProductID | default "PX-ENTERPRISE" }}
{{- if (.Values.customRegistryURL) -}}
  {{- if (eq "/" (.Values.customRegistryURL | regexFind "/")) -}}
    {{- cat (trim .Values.customRegistryURL) "/autopilot:" (trim .Values.versions.autoPilot) | replace " " ""}}
  {{- else -}}
    {{- cat (trim .Values.customRegistryURL) "/portworx/autopilot:" (trim .Values.versions.autoPilot) | replace " " ""}}
  {{- end -}}
{{- else -}}
  {{- if eq $product "PX-ENTERPRISE+DR" }}
    {{- cat (trim .Values.aws.repos.dr) "/portworx/autopilot:" (trim .Values.aws.versions.dr) | replace " " ""}}
  {{- else }}
    {{- cat (trim .Values.aws.repos.enterprise) "/portworx/autopilot:" (trim .Values.aws.versions.enterprise) | replace " " ""}}
  {{- end -}}
{{- end -}}
{{- end -}}

{{- define "px.getOperatorImage" -}}
{{- $product := .Values.awsProductID | default "PX-ENTERPRISE" }}
{{- if (.Values.customRegistryURL) -}}
  {{- if (eq "/" (.Values.customRegistryURL | regexFind "/")) -}}
    {{- cat (trim .Values.customRegistryURL) "/px-operator:" (trim .Values.versions.operator) | replace " " ""}}
  {{- else -}}
    {{- cat (trim .Values.customRegistryURL) "/portworx/px-operator:" (trim .Values.versions.operator) | replace " " ""}}
  {{- end -}}
{{- else -}}
  {{- if eq $product "PX-ENTERPRISE+DR" }}
    {{- cat (trim .Values.aws.repos.dr) "/portworx/px-operator:" (trim .Values.aws.versions.dr) | replace " " ""}}
  {{- else }}
    {{- cat (trim .Values.aws.repos.enterprise) "/portworx/px-operator:" (trim .Values.aws.versions.enterprise) | replace " " ""}}
  {{- end -}}
{{- end -}}
{{- end -}}
