# ==========================================
# system_report.ps1
# Kokkuvõttev ülesanne – PowerShell
# ==========================================

# Raporti faili nimi
$reportFile = "report.txt"

# Alguses loome/tühjendame raporti faili
"" | Out-File $reportFile

# ------------------------------------------
# 1. Kasutaja sisend
# ------------------------------------------
# Kui kasutaja ei sisesta nime, kasutatakse vaikimisi "Joonas Puur"

$nameInput = Read-Host "Sisesta oma nimi (võid Enter vajutada, siis kasutatakse 'Joonas Puur')"
if ([string]::IsNullOrWhiteSpace($nameInput)) {
    $name = "Joonas Puur"
} else {
    $name = $nameInput
}

$countInput = Read-Host "Mitu korda tervitust kuvada? (arv)"

# Kontrollime, kas sisestati arv
if (-not ($countInput -as [int])) {
    Write-Host "Viga: Palun sisesta arv tervituste arvuks!"
    exit
}

$count = [int]$countInput

# ------------------------------------------
# 2. Tsükkel – tervitused
# ------------------------------------------

Write-Host "`n=== Tervitused ==="
"=== Tervitused ===" | Out-File $reportFile -Append

for ($i = 1; $i -le $count; $i++) {
    $greeting = "Tere, $name! ($i)"
    Write-Host $greeting
    $greeting | Out-File $reportFile -Append
}

# ------------------------------------------
# 3. Süsteemiinfo
# ------------------------------------------

$computerName = $env:COMPUTERNAME
$username     = $env:USERNAME
$psVersion    = $PSVersionTable.PSVersion

Write-Host "`n=== Süsteemiinfo ==="
Write-Host "Arvuti nimi: $computerName"
Write-Host "Kasutaja nimi: $username"
Write-Host "PowerShelli versioon: $psVersion"

"`n=== Süsteemiinfo ==="          | Out-File $reportFile -Append
"Arvuti nimi: $computerName"      | Out-File $reportFile -Append
"Kasutaja nimi: $username"        | Out-File $reportFile -Append
"PowerShelli versioon: $psVersion" | Out-File $reportFile -Append

# ------------------------------------------
# 4. Cmdlet’ide kasutamine – 3 protsessi ja 3 teenust
#    Ilma tabelipäisteta (Name / Id jne)
# ------------------------------------------

Write-Host "`n=== 3 töötavat protsessi ==="
"`n=== 3 töötavat protsessi ===" | Out-File $reportFile -Append

$processes = Get-Process | Select-Object -First 3

foreach ($proc in $processes) {
    $line = "Protsess: $($proc.Name) | ID: $($proc.Id)"
    Write-Host $line
    $line | Out-File $reportFile -Append
}

Write-Host "`n=== 3 teenust ja nende olek ==="
"`n=== 3 teenust ja nende olek ===" | Out-File $reportFile -Append

$services = Get-Service | Select-Object -First 3

foreach ($svc in $services) {
    $line = "Teenus: $($svc.Name) | Olek: $($svc.Status)"
    Write-Host $line
    $line | Out-File $reportFile -Append
}

# ------------------------------------------
# 5. Tingimuslause – PowerShelli versiooni kontroll
# ------------------------------------------

if ($PSVersionTable.PSVersion.Major -lt 5) {
    $versionMessage = "HOIATUS: PowerShelli versioon on alla 5!"
} else {
    $versionMessage = "PowerShelli versioon on sobiv."
}

Write-Host "`n=== Versiooni kontroll ==="
Write-Host $versionMessage

"`n=== Versiooni kontroll ===" | Out-File $reportFile -Append
$versionMessage                | Out-File $reportFile -Append

# ------------------------------------------
# 6. BOONUS – kuupäev ja kellaaeg raportisse
# ------------------------------------------

$dateTime = Get-Date

Write-Host "`nRaporti loomise aeg: $dateTime"
"`nRaporti loomise aeg: $dateTime" | Out-File $reportFile -Append

# ------------------------------------------
# 7. Vormindatud lõppteade
# ------------------------------------------

Write-Host "==========================="
Write-Host "Script finished successfully"
Write-Host "==========================="

"==========================="           | Out-File $reportFile -Append
"Script finished successfully"         | Out-File $reportFile -Append
"==========================="           | Out-File $reportFile -Append
