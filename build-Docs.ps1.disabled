param(
  [string]$PagesDir = "pages",
  [string]$Template = "templates/base.html",
  [string]$Header   = "_partials/header.html",
  [string]$Footer   = "_partials/footer.html",
  [string]$OutDir   = "."
)

$ErrorActionPreference = "Stop"

function Say($m){ Write-Host "› $m" -ForegroundColor Cyan }
function Good($m){ Write-Host "✓ $m" -ForegroundColor Green }
function Bad($m){ Write-Host "✗ $m" -ForegroundColor Red }

if (!(Test-Path $Template)) { Bad "Missing $Template"; exit 1 }
if (!(Test-Path $Header))   { Bad "Missing $Header";   exit 1 }
if (!(Test-Path $Footer))   { Bad "Missing $Footer";   exit 1 }
if (!(Test-Path $PagesDir)) { Bad "Missing $PagesDir"; exit 1 }

$template = Get-Content $Template -Raw -Encoding UTF8
$header   = Get-Content $Header   -Raw -Encoding UTF8
$footer   = Get-Content $Footer   -Raw -Encoding UTF8

$pages = Get-ChildItem -Path $PagesDir -Filter *.html -File
if ($pages.Count -eq 0){ Bad "No pages found in $PagesDir"; exit 1 }

foreach ($p in $pages) {
  $content = Get-Content $p.FullName -Raw -Encoding UTF8

  # Title: first H1 text if available; else filename
  $title = ([regex]::Match($content, '<h1[^>]*>(?<t>.*?)</h1>', 'Singleline')).Groups['t'].Value
  if ([string]::IsNullOrWhiteSpace($title)) { $title = [IO.Path]::GetFileNameWithoutExtension($p.Name) }

  $html = $template
  $html = $html -replace '\{\{TITLE\}\}',   [regex]::Escape($title) -replace '\\', ''
  $html = $html -replace '\{\{HEADER\}\}',  [System.Text.RegularExpressions.Regex]::Escape($header).Replace('\r\n',"`n").Replace('\n',"`n") -replace '\\', ''
  $html = $html -replace '\{\{FOOTER\}\}',  [System.Text.RegularExpressions.Regex]::Escape($footer).Replace('\r\n',"`n").Replace('\n',"`n") -replace '\\', ''
  $html = $html -replace '\{\{CONTENT\}\}', [System.Text.RegularExpressions.Regex]::Escape($content).Replace('\r\n',"`n").Replace('\n',"`n") -replace '\\', ''

  $outPath = Join-Path $OutDir $p.Name
  Set-Content -Path $outPath -Value $html -Encoding UTF8
  Good "$($p.Name) -> $outPath"
}

Good "All pages built with shared header/footer."

# === Docs index & sitemap generation =========================================
Write-Host "› Generating docs index and sitemap..." -ForegroundColor Cyan

$HeaderHtml = Get-Content "_partials/header.html" -Raw
$FooterHtml = Get-Content "_partials/footer.html" -Raw

# Which files to include in the site list
$excluded = @("base.html","404.html","sitemap.html","docs.html")
$pages = Get-ChildItem -Path . -File -Filter *.html |
  Where-Object { $_.Name -notin $excluded -and $_.Name -notmatch '^\.' }

# Build list items with best-effort titles from <h1>
$items = foreach ($p in $pages) {
  $raw = Get-Content $p.FullName -Raw
  $title = if ($raw -match '<h1[^>]*>(.*?)</h1>') { $matches[1].Trim() } else { $p.BaseName }
  $href = "/" + ($p.Name -replace '\.html$','')
  "<li><a href=""$href"">$title</a></li>"
}

# Docs Index (docs.html)
$docsBody = @"
<main class="container">
  <h1>All Pages</h1>
  <ul>
    $(($items -join "`n    "))
  </ul>
</main>
"@
Set-Content "docs.html" ($HeaderHtml + "`n" + $docsBody + "`n" + $FooterHtml) -Encoding UTF8
Write-Host "✓ Wrote docs.html"

# Sitemap (HTML)
$smBody = @"
<main class="container">
  <h1>Sitemap</h1>
  <ul>
    <li><a href="/">Home</a></li>
    $(($items -join "`n    "))
  </ul>
</main>
"@
Set-Content "sitemap.html" ($HeaderHtml + "`n" + $smBody + "`n" + $FooterHtml) -Encoding UTF8
Write-Host "✓ Wrote sitemap.html"



