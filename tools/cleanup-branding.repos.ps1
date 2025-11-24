# Cleanup repo names + old brand patterns across all text files
Write-Host "🔧 Cleaning repo names + old branding..." -ForegroundColor Cyan

$replacements = @{
    "justinelonglat-lane-docs"   = "justinelonglat-lane-docs"
    "justinelonglat-lane-blogs"  = "justinelonglat-lane-blogs"
    "JustineLonglaT-Lane Docs"   = "JustineLonglaT-Lane Docs"
    "JustineLonglaT-Lane Blog"   = "JustineLonglaT-Lane Blog"
    "JustineLonglaT-Lane"        = "JustineLonglaT-Lane"
    "justinelonglat-lane.com"    = "justinelonglat-lane.com"
}

# text file extensions to scan
$patterns = "*.html","*.md","*.json","*.xml","*.txt","*.yml","*.yaml","*.ps1","*.css"

$files = Get-ChildItem -Recurse -Include $patterns

$changed = @()

foreach ($f in $files) {
    $content = Get-Content -LiteralPath $f.FullName -Raw
    $orig    = $content

    foreach ($key in $replacements.Keys) {
        $content = $content.Replace($key, $replacements[$key])
    }

    if ($content -ne $orig) {
        Set-Content -LiteralPath $f.FullName -Value $content -Encoding UTF8
        $changed += $f.FullName
    }
}

if ($changed.Count -gt 0) {
    Write-Host "✅ Updated $($changed.Count) files:" -ForegroundColor Green
    $changed | ForEach-Object { Write-Host "  - $_" }
} else {
    Write-Host "✔ No matching patterns found." -ForegroundColor Yellow
}

