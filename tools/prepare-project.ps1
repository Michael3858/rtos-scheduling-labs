[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [ValidateSet('LAB1','PA1','PA2','PA3')]
    [string]$Lab,
    [Parameter(Mandatory=$true)]
    [string]$Baseline,
    [string]$Destination
)
$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$baselineRoot = (Resolve-Path -LiteralPath $Baseline).Path
if (-not $Destination) {
    $Destination = Join-Path (Join-Path $repoRoot 'work') $Lab
}
$destinationRoot = [System.IO.Path]::GetFullPath($Destination)
if (Test-Path -LiteralPath $destinationRoot) {
    throw "Destination already exists: $destinationRoot. Choose a new empty destination."
}
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw 'Git is required to apply the assignment patch.'
}
$manifest = Get-Content -LiteralPath (Join-Path $repoRoot 'baseline-manifest.json') -Raw | ConvertFrom-Json
foreach ($entry in $manifest.files) {
    $sourceFile = Join-Path $baselineRoot $entry.path
    if (-not (Test-Path -LiteralPath $sourceFile -PathType Leaf)) {
        throw "Baseline is missing: $($entry.path)"
    }
    $actualHash = (Get-FileHash -LiteralPath $sourceFile -Algorithm SHA256).Hash
    if ($actualHash -ne $entry.sha256) {
        throw "Baseline differs from the original course template: $($entry.path)"
    }
}
New-Item -ItemType Directory -Path $destinationRoot | Out-Null
foreach ($entry in $manifest.files) {
    $sourceFile = Join-Path $baselineRoot $entry.path
    $targetFile = Join-Path $destinationRoot $entry.path
    $targetParent = Split-Path -Parent $targetFile
    New-Item -ItemType Directory -Path $targetParent -Force | Out-Null
    Copy-Item -LiteralPath $sourceFile -Destination $targetFile
}
$patchFile = Join-Path (Join-Path $repoRoot 'patches') ($Lab + '.patch')
& git -c core.autocrlf=false -C $destinationRoot apply --check $patchFile
if ($LASTEXITCODE -ne 0) { throw 'Patch preflight failed. The copied baseline was retained for inspection.' }
& git -c core.autocrlf=false -C $destinationRoot apply --whitespace=nowarn $patchFile
if ($LASTEXITCODE -ne 0) { throw 'Applying the patch failed. The copied files were retained for inspection.' }
Write-Output "Prepared $Lab in $destinationRoot"
Write-Output (Join-Path $destinationRoot 'Microsoft\Windows\Kernel\OS2\VS\OS2.sln')

