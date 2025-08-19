+++
title = '{{ .File.ContentBaseName | humanize | title }}'
draft = false

[menu.client]
title = "{{ .File.ContentBaseName | humanize | title }}"
identifier = "client/{{ .File.ContentBaseName | humanize | | title }}"
parent = "client"
weight = 10
+++

{{</* Run 'hugo new content path/to/new/page.md' to generate a new page. */>}}
