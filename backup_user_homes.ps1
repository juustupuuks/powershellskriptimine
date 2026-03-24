# Varukoopiate kaust
$backupKaust = "C:\Backup"

# Loome Backup kausta, kui seda ei ole olemas
if (-not (Test-Path $backupKaust)) {
    New-Item -Path $backupKaust -ItemType Directory | Out-Null
}

# Tänane kuupäev
$kuupaev = Get-Date -Format "dd.MM.yyyy"

# Võtame kõik kohalikud kasutajad
$kasutajad = Get-LocalUser

foreach ($kasutaja in $kasutajad) {
    $kasutajanimi = $kasutaja.Name
    $kodukaust = "C:\Users\$kasutajanimi"

    # Kontrollime, kas kodukaust on olemas
    if (Test-Path $kodukaust) {
        $zipFail = Join-Path $backupKaust "$kasutajanimi-$kuupaev.zip"

        try {
            # Kui sama nimega zip on juba olemas, kustutame selle enne
            if (Test-Path $zipFail) {
                Remove-Item $zipFail -Force
            }

            Compress-Archive -Path "$kodukaust\*" -DestinationPath $zipFail -Force
            Write-Host "Varukoopia loodud: $zipFail" -ForegroundColor Green
        }
        catch {
            Write-Host "Viga kasutaja '$kasutajanimi' varundamisel: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    else {
        Write-Host "Kasutaja '$kasutajanimi' kodukausta ei leitud." -ForegroundColor Yellow
    }
}
