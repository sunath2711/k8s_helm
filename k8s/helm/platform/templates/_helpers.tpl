{{/* Common labels */}}
{{- define "platform.labels" -}}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" }}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/* Selector labels for API */}}
{{- define "platform.selectorLabels" -}}
app: {{ .Values.api.name }}
{{- end }}

{{/* Selector labels for Postgres */}}
{{- define "postgres.selectorLabels" -}}
app: {{ .Values.postgres.name }}
{{- end }}