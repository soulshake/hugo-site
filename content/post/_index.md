{{ range .Data.Pages }}
  {{ .Title }}
  {{ .RelPermalink }}
{{ end }}
