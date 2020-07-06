
{{- define "px.getImage" -}}
{{- if (.Values.customRegistryURL) -}}
    {{- if (eq "/" (.Values.customRegistryURL | regexFind "/")) -}}
    	{{ cat (trim .Values.customRegistryURL) "/oci-monitor" | replace " " ""}}
    {{- else -}}
    	{{cat (trim .Values.customRegistryURL) "/portworx/oci-monitor" | replace " " ""}}
    {{- end -}}
{{- else -}}
	{{ "portworx/oci-monitor" }}
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
    {{ "openstorage/stork" }}
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
    {{ "portworx/autopilot" }}
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
    {{ "portworx/px-operator" }}
{{- end -}}
{{- end -}}
