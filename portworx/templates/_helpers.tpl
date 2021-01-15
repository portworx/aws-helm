{{- define "px.getProductID" -}}
{{- $product := .Values.awsProduct | default "PX-ENTERPRISE" }}
    {{- if eq $product "PX-ENTERPRISE-DR" }}
        {{- cat "6a97e814-fbe5-4ae3-a3e2-14ca735b5e6b" }}
    {{- else }}
        {{- cat "3a3fcb1c-7ee5-4f3b-afe3-d293c3f9beb4" }}
    {{- end }}
{{- end -}}

{{- define "px.getImage" -}}
{{- $product := .Values.awsProduct | default "PX-ENTERPRISE" }}
{{- if (.Values.customRegistryURL) -}}
  {{- if (eq "/" (.Values.customRegistryURL | regexFind "/")) -}}
    {{- cat (trim .Values.customRegistryURL) "/px-enterprise:" (trim .Values.versions.enterprise) | replace " " ""}}
  {{- else -}}
    {{- cat (trim .Values.customRegistryURL) "/portworx/px-enterprise:" (trim .Values.versions.enterprise)| replace " " ""}}
  {{- end -}}
{{- else -}}
  {{- cat "portworx/px-enterprise:" (trim .Values.versions.enterprise) | replace " " ""}}
{{- end -}}
{{- end -}}

{{- define "px.getOCIImage" -}}
{{- $product := .Values.awsProduct | default "PX-ENTERPRISE" }}
{{- if (.Values.customRegistryURL) -}}
  {{- if (eq "/" (.Values.customRegistryURL | regexFind "/")) -}}
    {{- cat (trim .Values.customRegistryURL) "/oci-monitor:" (trim .Values.versions.ociMon) | replace " " ""}}
  {{- else -}}
    {{- cat (trim .Values.customRegistryURL) "/portworx/oci-monitor:" (trim .Values.versions.ociMon)| replace " " ""}}
  {{- end -}}
{{- else -}}
  {{- if eq $product "PX-ENTERPRISE-DR" }}
    {{- cat (trim .Values.repo.dr) "/oci-monitor:" (trim .Values.versions.ociMon) | replace " " ""}}
  {{- else }}
    {{- cat (trim .Values.repo.enterprise) "/oci-monitor:" (trim .Values.versions.ociMon) | replace " " ""}}
  {{- end }}
{{- end -}}
{{- end -}}

{{- define "px.getStorkImage" -}}
{{- $product := .Values.awsProduct | default "PX-ENTERPRISE" }}
{{- if (.Values.customRegistryURL) -}}
  {{- if (eq "/" (.Values.customRegistryURL | regexFind "/")) -}}
    {{- cat (trim .Values.customRegistryURL) "/stork:" (trim .Values.versions.stork)| replace " " ""}}
  {{- else -}}
    {{- cat (trim .Values.customRegistryURL) "/openstorage/stork:" (trim .Values.versions.stork) | replace " " ""}}
  {{- end -}}
{{- else -}}
  {{- if eq $product "PX-ENTERPRISE-DR" }}
    {{- cat (trim .Values.repo.dr) "/stork:" (trim .Values.versions.stork) | replace " " ""}}
  {{- else }}
    {{- cat (trim .Values.repo.enterprise) "/stork:" (trim .Values.versions.stork) | replace " " ""}}
  {{- end }}
{{- end -}}
{{- end -}}

{{- define "px.getAutopilotImage" -}}
{{- $product := .Values.awsProduct | default "PX-ENTERPRISE" }}
{{- if (.Values.customRegistryURL) -}}
  {{- if (eq "/" (.Values.customRegistryURL | regexFind "/")) -}}
    {{- cat (trim .Values.customRegistryURL) "/autopilot:" (trim .Values.versions.autoPilot) | replace " " ""}}
  {{- else -}}
    {{- cat (trim .Values.customRegistryURL) "/portworx/autopilot:" (trim .Values.versions.autoPilot) | replace " " ""}}
  {{- end -}}
{{- else -}}
  {{- if eq $product "PX-ENTERPRISE-DR" }}
    {{- cat (trim .Values.repo.dr) "/autopilot:" (trim .Values.versions.autoPilot) | replace " " ""}}
  {{- else }}
    {{- cat (trim .Values.repo.enterprise) "/autopilot:" (trim .Values.versions.autoPilot) | replace " " ""}}
  {{- end }}
{{- end -}}
{{- end -}}

{{- define "px.getOperatorImage" -}}
{{- $product := .Values.awsProduct | default "PX-ENTERPRISE" }}
{{- if (.Values.customRegistryURL) -}}
  {{- if (eq "/" (.Values.customRegistryURL | regexFind "/")) -}}
    {{- cat (trim .Values.customRegistryURL) "/px-operator:" (trim .Values.versions.operator) | replace " " ""}}
  {{- else -}}
    {{- cat (trim .Values.customRegistryURL) "/portworx/px-operator:" (trim .Values.versions.operator) | replace " " ""}}
  {{- end -}}
{{- else -}}
  {{- if eq $product "PX-ENTERPRISE-DR" }}
    {{- cat (trim .Values.repo.dr) "/px-operator:" (trim .Values.versions.operator) | replace " " ""}}
  {{- else }}
    {{- cat (trim .Values.repo.enterprise) "/px-operator:" (trim .Values.versions.operator) | replace " " ""}}
  {{- end }}
{{- end -}}
{{- end -}}
