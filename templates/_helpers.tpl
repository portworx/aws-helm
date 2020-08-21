{{- $awsRepo := "217273820646.dkr.ecr.us-east-1.amazonaws.com/3a3fcb1c-7ee5-4f3b-afe3-d293c3f9beb4/cg-3746887092/portworx/oci-monitor" }}

{{- define "px.getImage" -}}
{{- if (.Values.customRegistryURL) -}}
    {{- if (eq "/" (.Values.customRegistryURL | regexFind "/")) -}}
    	{{ cat (trim .Values.customRegistryURL) "/oci-monitor" | replace " " ""}}
    {{- else -}}
    	{{cat (trim .Values.customRegistryURL) "/portworx/oci-monitor" | replace " " ""}}
    {{- end -}}
{{- else -}}
	{{cat (trim $awsRepo) "/portworx/oci-monitor" | replace " " ""}}
{{- end -}}
{{- end -}}

{{- define "px.getStorkImage" -}}
{{- if (.Values.customRegistryURL) -}}
    {{- if (eq "/" (.Values.customRegistryURL | regexFind "/")) -}}
        {{ cat (trim .Values.customRegistryURL) "/stork" | replace " " ""}}
    {{- else -}}
        {{cat (trim .Values.customRegistryURL) "/openstorage/stork" | replace " " ""}}
    {{- end -}}
{{- else -}}
	{{cat (trim $awsRepo) "/portworx/stork" | replace " " ""}}
{{- end -}}
{{- end -}}


{{- define "px.getAutopilotImage" -}}
{{- if (.Values.customRegistryURL) -}}
    {{- if (eq "/" (.Values.customRegistryURL | regexFind "/")) -}}
        {{ cat (trim .Values.customRegistryURL) "/autopilot" | replace " " ""}}
    {{- else -}}
        {{cat (trim .Values.customRegistryURL) "/portworx/autopilot" | replace " " ""}}
    {{- end -}}
{{- else -}}
	{{cat (trim $awsRepo) "/portworx/autopilot" | replace " " ""}}
{{- end -}}
{{- end -}}

{{- define "px.getOperatorImage" -}}
{{- if (.Values.customRegistryURL) -}}
    {{- if (eq "/" (.Values.customRegistryURL | regexFind "/")) -}}
        {{ cat (trim .Values.customRegistryURL) "/px-operator" | replace " " ""}}
    {{- else -}}
        {{cat (trim .Values.customRegistryURL) "/portworx/px-operator" | replace " " ""}}
    {{- end -}}
{{- else -}}
	{{cat (trim $awsRepo) "/portworx/px-operator" | replace " " ""}}
{{- end -}}
{{- end -}}
