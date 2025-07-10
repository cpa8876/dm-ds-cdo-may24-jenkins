#  Minikube_B09) Deploying Nginx on Kubernetes: Exploring Various Methods > 7. Helm; Mastering Nginx Deployment in Kubernetes: A Comprehensive Guide to Pods, Deployments, and Beyond; Anvesh Muppeda; Anvesh Muppeda; 12 min read; Jan 13, 2024
## https://medium.com/@muppedaanvesh/deploying-nginx-on-kubernetes-a-quick-guide-04d533414967 
---
[200~{{/*
Expand the name of the chart.
*/}}
{{- define "nginx-chart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "nginx-chart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "nginx-chart.labels" -}}
helm.sh/chart: {{ include "nginx-chart.chart" . }}
{{ include "nginx-chart.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "nginx-chart.selectorLabels" -}}
app.kubernetes.io/name: {{ include "nginx-chart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app: {{ .Release.Name }}
{{- end }}
---
