# create_ad_users_with_passwords.ps1

# Laadi vajalik assembly parooli genereerimiseks
Add-Type -AssemblyName System.Web

# Defineeri kasutajate nimekiri
$UserList = @(
    "Mari Maasikas",
    "Jaan Jõesaar", 
    "Kadri Kask",
    "Peeter Pärn",
    "Liisa Lill",
    "Andres Ader",
    "Tiina Tamm",
    "Mart Mets",
    "Anne Aas",
    "Toomas Tuul"
)

$Domain = "kontor.local"
$Results = @()

foreach ($User in $UserList) {
    $Nimed = $User -split ' '
    $Eesnimi = $Nimed[0]
    $Perenimi = $Nimed[1]
    
    # Transliteratsioon eestikeelsete tähtede jaoks
    $EesnimiLatin = $Eesnimi -replace 'ä','a' -replace 'ö','o' -replace 'ü','u' -replace 'õ','o' -replace 'Ä','A' -replace 'Ö','O' -replace 'Ü','U' -replace 'Õ','O'
    $PerenimiLatin = $Perenimi -replace 'ä','a' -replace 'ö','o' -replace 'ü','u' -replace 'õ','o' -replace 'Ä','A' -replace 'Ö','O' -replace 'Ü','U' -replace 'Õ','O'
    
    $KasutajaNimi = ($EesnimiLatin + "." + $PerenimiLatin).ToLower()
    
    # Genereeri 10-kohaline parool vähemalt 2 erimärgiga
    $ParoolPlain = [System.Web.Security.Membership]::GeneratePassword(10, 2)
    $Parool = ConvertTo-SecureString $ParoolPlain -AsPlainText -Force
    
    try {
        $Kasutaja = Get-ADUser -Filter "SamAccountName -eq '$KasutajaNimi'" -ErrorAction Stop
        Write-Host "User $KasutajaNimi already exists - can not add this users" -ForegroundColor Yellow
        $Result = [PSCustomObject]@{
            Username = $KasutajaNimi
            FullName = $User
            Password = $ParoolPlain
            Status = "Already exists"
        }
        $Results += $Result
    }
    catch {
        try {
            New-ADUser -Name "$Eesnimi $Perenimi" `
                      -GivenName $Eesnimi `
                      -Surname $Perenimi `
                      -SamAccountName $KasutajaNimi `
                      -UserPrincipalName "$KasutajaNimi@$Domain" `
                      -AccountPassword $Parool `
                      -Enabled $true `
                      -ChangePasswordAtLogon $true `
                      -PassThru `
                      -ErrorAction Stop
            
            if ($?) {
                Write-Host "New user $KasutajaNimi added succesfully" -ForegroundColor Green
                $Result = [PSCustomObject]@{
                    Username = $KasutajaNimi
                    FullName = $User
                    Password = $ParoolPlain
                    Status = "Created"
                }
                $Results += $Result
            } else {
                Write-Host "Failed to create user $KasutajaNimi" -ForegroundColor Red
                $Result = [PSCustomObject]@{
                    Username = $KasutajaNimi
                    FullName = $User
                    Password = $ParoolPlain
                    Status = "Failed"
                }
                $Results += $Result
            }
        }
        catch {
            Write-Host "Error creating user $KasutajaNimi : $_" -ForegroundColor Red
            $Result = [PSCustomObject]@{
                Username = $KasutajaNimi
                FullName = $User
                Password = $ParoolPlain
                Status = "Error: $_"
            }
            $Results += $Result
        }
    }
}

# Salvesta tulemused CSV-faili
$Results | Export-Csv -Path "kasutajanimi.csv" -NoTypeInformation -Encoding UTF8

Write-Host "`nKasutajate loomise protsess lõpetatud!" -ForegroundColor Cyan
Write-Host "Tulemused salvestatud faili: kasutajanimi.csv" -ForegroundColor Cyan
