# Tæller normalsider (1 normalside = 2400 tegn inkl. mellemrum)
# Brødtekst kun: stripper LaTeX-kommentarer og -kommandoer groft.
# Kør fra workspace-roden:  .\count-normalsider.ps1

$chapterFiles = @()
$mainTex = Join-Path $PSScriptRoot 'main.tex'
if (Test-Path $mainTex) {
    # Find kun de filer der faktisk er \include'd i main.tex
    $included = Select-String -Path $mainTex -Pattern '^\s*\\include\{([^}]+)\}' -AllMatches |
        ForEach-Object { $_.Matches.Groups[1].Value }
    foreach ($rel in $included) {
        $path = Join-Path $PSScriptRoot ($rel + '.tex')
        if (Test-Path $path) { $chapterFiles += Get-Item $path }
    }
} else {
    $chapterFiles = Get-ChildItem (Join-Path $PSScriptRoot 'Chapters\Chapter*.tex') | Sort-Object Name
}

$rows = foreach ($f in $chapterFiles) {
    $raw = Get-Content $f.FullName -Raw -Encoding UTF8
    $noCom = ($raw -split "`n" | ForEach-Object { $_ -replace '(?<!\\)%.*$','' }) -join "`n"
    $stripped = $noCom -replace '\\[a-zA-Z]+\*?(\[[^\]]*\])?(\{[^{}]*\})?',''
    $stripped = $stripped -replace '\\[a-zA-Z]+\*?',''
    $stripped = $stripped -replace '[{}]',''
    $stripped = ($stripped -replace '\s+',' ').Trim()
    [pscustomobject]@{
        Fil               = $f.Name
        TegnInklMellemrum = $stripped.Length
        Normalsider       = [math]::Round($stripped.Length/2400, 2)
    }
}

$rows | Format-Table -AutoSize
$total = ($rows | Measure-Object TegnInklMellemrum -Sum).Sum
Write-Host ""
Write-Host ("TOTAL brodtekst : {0} tegn inkl. mellemrum" -f $total)
Write-Host ("Normalsider     : {0:N2}  (af max 20)" -f ($total/2400))
Write-Host ("Tilbage         : {0:N2} normalsider" -f (20 - $total/2400))
