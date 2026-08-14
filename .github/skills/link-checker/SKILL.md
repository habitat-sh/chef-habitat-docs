---
name: Link Checker
description: "Reusable skill that runs linkchecker (a Python CLI tool) against a live URL to produce a structured list of broken and redirected links. Use when an agent needs to verify URLs in a documentation site without fetching each link individually. Requires linkchecker to be pre-installed — see Prerequisites."
---

# Skill: Link Checker

## When to use this skill

Use this skill when an agent needs to:

- Check all links on a published documentation site (or any live URL) for broken links, redirects, and errors
- Avoid the token cost of fetching each URL individually with a web tool
- Receive a structured, machine-readable report that the agent can then interpret and present to a human

## Prerequisites

**linkchecker must be installed before using this skill.** The agent will not install it automatically.

Install once using [pipx](https://pipx.pypa.io/) (recommended, isolates the package in its own environment):

```shell
pipx install linkchecker
```

Or using pip into a virtual environment:

```shell
pip install linkchecker
```

Requires Python 3.10 or later. See the [linkchecker installation guide](https://linkchecker.github.io/linkchecker/install.html) for platform-specific instructions.

**Why not auto-install?** Installing packages from PyPI at agent runtime — without explicit human awareness — is a supply chain security concern. The agent would be silently pulling in linkchecker and its dependencies (Requests, Beautiful Soup, dnspython) from the internet as a side effect of running a doc review. Requiring pre-installation means the human makes that decision deliberately.

## Step 1 — Verify linkchecker is available

```powershell
$lc = Get-Command linkchecker -ErrorAction SilentlyContinue
if (-not $lc) {
    throw @"
linkchecker is not installed or not on PATH.

Install it before running this skill:
  pipx install linkchecker   # recommended
  pip install linkchecker    # alternative (use a virtual environment)

See: https://linkchecker.github.io/linkchecker/install.html
"@
}
Write-Host "linkchecker found at: $($lc.Source)"
```

Stop and surface the error message to the user if linkchecker is not found. Do not attempt to install it.

## Step 2 — Run linkchecker against the target URL

Replace `<target-url>` with the URL to check (for example, `https://docs.chef.io/habitat/`).

```powershell
$targetUrl = "<target-url>"
# --no-robots   : ignore robots.txt (documentation sites may block crawlers)
# --output=csv  : structured output for easy parsing
# --check-extern: also check external links (not just internal)
# --timeout=10  : per-link timeout in seconds
# Linkchecker exits with non-zero when errors are found — capture output regardless
$lcOutput = & linkchecker --no-robots --output=csv --check-extern --timeout=10 $targetUrl 2>&1
Write-Host "linkchecker exit code: $LASTEXITCODE"
```

**Note:** For large sites, linkchecker recurses through all pages by default. To limit scope to a single
page (and its direct links only), use `--depth=1`.

## Step 3 — Parse the CSV output

The CSV output from linkchecker has this header:

```
urlname;parentname;base;result;warningstring;infostring;valid;url;line;col;name;dltime;size;checktime
```

Key fields:
- `urlname` — the URL that was checked
- `result` — HTTP result or error message (for example, `200 OK`, `404 Not Found`, `301 Moved Permanently`)
- `valid` — `True` or `False`
- `parentname` — the page that contained the link
- `line` / `col` — position in the parent page source

```powershell
# Skip comment lines (start with #) and blank lines
$csvLines = $lcOutput | Where-Object { $_ -notmatch "^#" -and $_.Trim() -ne "" }

# Parse into objects (linkchecker CSV uses semicolons as delimiters)
$results = $csvLines | ConvertFrom-Csv -Delimiter ";"

# Separate broken and redirected links
$broken     = $results | Where-Object { $_.valid -eq "False" }
$redirected = $results | Where-Object { $_.valid -eq "True" -and $_.result -match "^3\d\d" }

Write-Host "Broken links:     $($broken.Count)"
Write-Host "Redirected links: $($redirected.Count)"
```

## Step 4 — Return results to the calling agent

Pass `$broken` and `$redirected` to the agent report-generation step. The calling agent formats these
into a human-readable table grouped by parent page, with columns for URL, result, and parent page.

```powershell
# Example: display broken links
$broken | Format-Table urlname, result, parentname -AutoSize
```

## Notes for calling agents

- linkchecker crawls recursively by default. For a scoped check (single page), use `--depth=1`.
- The CSV output may include a header row as a comment line (starting with `#`). The parse step above handles this.
- linkchecker may report false positives for URLs that block automated crawlers (for example, LinkedIn). Flag these as "unverifiable" rather than broken.
- `--no-robots` is recommended for documentation site checks to avoid missing pages excluded by `robots.txt`.
- Do not treat a non-zero exit code from linkchecker as a script failure — it means errors were found, which is expected. Check `$broken.Count` instead.
- This skill checks the **published site** (live HTML). It will not catch broken links in Markdown source that have not yet been published. The calling agent should also run pattern-based checks on the raw Markdown files for common issues such as `http://` URLs, `master` branch references, and known outdated domains.