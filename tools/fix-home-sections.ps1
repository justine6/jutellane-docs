$ErrorActionPreference = "Stop"

function Read-Text([string]$Path) {
  Get-Content -LiteralPath $Path -Raw -Encoding UTF8
}
function Write-Text([string]$Path, [string]$Content) {
  Set-Content -LiteralPath $Path -Value $Content -Encoding UTF8
  Write-Host "✓ wrote $Path" -ForegroundColor Green
}

# ---------------- 1) Build "Latest updates" (top 10 by mtime) ----------------
$pages = Get-ChildItem -Path . -File -Include *.html -Recurse | Where-Object {
  $_.FullName -notmatch '\\templates\\' -and
  $_.Name -notin @('404.html','sitemap.html','docs.html')
}

function Get-Title([string]$file) {
  $html = Read-Text $file
  $h1 = [regex]::Match($html, '(?is)<h1[^>]*>(.+?)</h1>').Groups[1].Value.Trim()
  if ($h1) { return ($h1 -replace '\s+',' ').Trim() }
  $t  = [regex]::Match($html, '(?is)<title[^>]*>(.+?)</title>').Groups[1].Value.Trim()
  if ($t) { return ($t -replace '\s+',' ').Trim() }
  return [IO.Path]::GetFileNameWithoutExtension($file)
}

$lis = foreach ($p in ($pages | Sort-Object LastWriteTime -Descending | Select-Object -First 10)) {
  $href  = '/' + ($p.FullName | Resolve-Path -Relative | Split-Path -Leaf)
  $title = Get-Title $p.FullName
  $date  = $p.LastWriteTime.ToString('yyyy-MM-dd')
  "  <li><a href=""$href"">$title</a> <span class=""updated-on"">$date</span></li>"
}

$updatesHtml = @"
<section class="updates" aria-label="Latest updates">
  <div class="updates-head">
    <h2>Latest updates</h2>
    <a class="updates-more" href="/sitemap.xml" target="_blank" rel="noopener">View all</a>
  </div>
  <ul class="updates-list">
$(($lis -join "`r`n"))
  </ul>
</section>
"@

# ---------------- 2) Build "All Pages" (from sitemap.xml if present) ----------
$allLis = @()
if (Test-Path "sitemap.xml") {
  $smap = Read-Text "sitemap.xml"
  $locs = [regex]::Matches($smap, '(?is)<loc>(.+?)</loc>') | ForEach-Object { $_.Groups[1].Value }
  $allLis = foreach ($u in ($locs | Sort-Object)) {
    $label = ($u -replace '.*/','') -replace '\.html?$','' -replace '[-_/]+',' '
    if (-not $label) { $label = $u }
    "  <li><a href=""$u"">$label</a></li>"
  }
} else {
  $allLis = foreach ($p in ($pages | Sort-Object FullName)) {
    $href  = '/' + ($p.FullName | Resolve-Path -Relative | Split-Path -Leaf)
    $label = ($p.BaseName -replace '[-_]+',' ')
    "  <li><a href=""$href"">$label</a></li>"
  }
}

$allPagesHtml = @"
<section class="all-pages" aria-label="All pages">
  <div class="updates-head">
    <h2>All Pages</h2>
  </div>
  <ul class="updates-list">
$(($allLis -join "`r`n"))
  </ul>
</section>
"@

# ---------------- 3) Patch index.html ----------------------------------------
$homePath = "index.html"
$homeHtml = Read-Text $homePath
$homeHtml = [regex]::Replace($homeHtml, '(?is)<section[^>]*\bupdates\b[^>]*>.*?</section>', '')
$homeHtml = [regex]::Replace($homeHtml, '(?is)<section[^>]*\ball-pages\b[^>]*>.*?</section>', '')
$combined = "$updatesHtml`r`n$allPagesHtml"

if ([regex]::IsMatch($homeHtml, '(?is)(<div[^>]+class="hero[^"]*"[^>]*>.*?</div>)')) {
  $homeHtml = [regex]::Replace($homeHtml, '(?is)(<div[^>]+class="hero[^"]*"[^>]*>.*?</div>)', { param($m) $m.Groups[1].Value + "`r`n$combined" }, 1)
} elseif ([regex]::IsMatch($homeHtml, '(?is)<h1[^>]*>\s*Welcome to Jutellane Docs')) {
  $homeHtml = [regex]::Replace($homeHtml, '(?is)(<h1[^>]*>\s*Welcome to Jutellane Docs)', "<!-- home-sections -->`r`n$combined`r`n$1", 1)
} elseif ([regex]::IsMatch($homeHtml, '(?is)(<main[^>]*>)')) {
  $homeHtml = [regex]::Replace($homeHtml, '(?is)(<main[^>]*>)', { param($m) $m.Groups[1].Value + "`r`n$combined" }, 1)
} else {
  $homeHtml = [regex]::Replace($homeHtml, '(?is)</body>', "$combined`r`n</body>", 1)
}

Write-Text $homePath $homeHtml
Write-Host "✓ Homepage patched: SINGLE updates + SINGLE all-pages section." -ForegroundColor Green

