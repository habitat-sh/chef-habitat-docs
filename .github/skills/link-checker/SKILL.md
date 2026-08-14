---
name: Link Checker
description: "Reusable skill that installs linkchecker (a Python CLI tool) and runs it against a live URL to produce a structured list of broken and redirected links. Use when an agent needs to verify URLs in a documentation site without fetching each link individually."
---

# Skill: Link Checker

## When to use this skill

Use this skill when an agent needs to:

- Check all links on a published documentation site (or any live URL) for broken links, redirects, and errors
- Avoid the token cost of fetching each URL individually with a web tool
- Receive a structured, machine-readable report that the agent can then interpret and present to a human

## Prerequisites

- Python 3.10 or later must be available in the environment
- `pip` or `pipx` must be available for installation

## Step 1 — Check whether linkchecker is installed

```powershell
$lc = Get-Command linkchecker -ErrorAction SilentlyContinue
if (-not $lc) {
    Write-Host "linkchecker not found — installing with pipx..."
    pipx install linkchecker
    # After install, ensure pipx bin dir is on PATH for this session
    $env:PATH = "$env:USERPROFILE\.local\bin;$env:PATH"
}
$lc = Get-Command linkchecker -ErrorAction SilentlyContinue
if (-not $lc) { throw "linkchecker installation failed. Ask the user to install it manually: pipx install linkchecker" }
Write-Host "linkchecker available at: $($lc.Source)"
```

If installation fails, stop and ask the user to install linkchecker manually before continuing.

## Step 2 — Run linkchecker against the target URL

Replace `<target-url>` with the URL to check (for example, `https://docs.chef.io/habitat/`).

```powershell
$targetUrl = "<target-url>"
# --no-robots   : ignore robots.txt (documentation sites may block crawlers)
# --output=csv  : structured output for easy parsing
# --check-extern: also check external links (not just internal)
# --timeout=10  : per-link timeout in seconds
# Linkchecker exits with code 0 (all OK) or non-zero (errors found) — capture output regardless
$lcOutput = & linkchecker --no-robots --output=csv --check-extern --timeout=10 $targetUrl 2>&1
Write-Host "linkchecker exit code: $LASTEXITCODE"
```

**Note:** For large sites, linkchecker recurses through all pages by default. To limit scope to a single
page (and its direct links only), add `--no-follow-url=<target-url>` or use `--depth=1`.

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
# Split output into lines; skip comment lines (start with #) and blank lines
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