+++
title = "{{ .Name | humanize | title }}"
date = {{ .Date }}
draft = false


[menu]
  [menu.habitat]
    title = "{{ .Name | humanize | title }}"
    identifier = "habitat/{{ .Name }}.md {{ .Name | humanize | title }}"
    parent = "habitat"
    weight = 10
+++
