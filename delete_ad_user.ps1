# delete_ad_user.ps1

# Transliteratsiooni funktsioon eestikeelsete tähtede asendamiseks
function Convert-ToLatin {
    param([string]$Text)
    
    $Translit = @{
        'ä' = 'a'
        'ö' = 'o'
        'ü' = 'u'
        'õ' = 'o'
        'Ä' = 'A'
        'Ö' = 'O'
        'Ü' = 'U'
        'Õ' = 'O'
        'š' = 's'
        'ž' = 'z'
        'Š' = 'S'
        'Ž' = 'Z'
    }
    
    foreach ($key in $Translit.Keys) {
        $Text = $Text -replace $key, $Translit[$key]
    }
    
    return $Text
}

# Küsi kasutajalt ees- ja perenimi
$Eesnimi = Read-Host "Please enter user firstname"
$Perenimi = Read-Host "Please enter user lastname"

# Kontrolli, et nimed pole tühjad
if ([string]::IsNullOrWhiteSpace($Eesnimi) -or [string]::IsNullOrWhiteSpace($Perenimi)) {
    Write-Host "Error: Firstname and lastname cannot be empty!" -ForegroundColor Red
    exit 1
}

# Rakenda transliteratsioon
$EesnimiLatin = Convert-ToLatin $Eesnimi
$PerenimiLatin = Convert-ToLatin $Perenimi

# Loo kasutajanimi formaadis ees.perenimi (väikeste tähtedega)
$KasutajaNimi = ($EesnimiLatin + "." + $PerenimiLatin).ToLower()

# Peida veateated
$ErrorActionPreference = "SilentlyContinue"

# Proovi kasutajat kustutada
try {
    # Kontrolli esmalt, kas kasutaja eksisteerib
    $Kasutaja = Get-ADUser -Filter "SamAccountName -eq '$KasutajaNimi'" -ErrorAction Stop
    
    # Kui kasutaja eksisteerib, proovi kustutada
    Remove-ADUser -Identity $KasutajaNimi -Confirm:$false -ErrorAction Stop
    
    # Taasta vaikimisi veakäsitlus
    $ErrorActionPreference = "Continue"
    
    # Kui siia jõuti, siis kustutamine õnnestus
    Write-Host "User $Eesnimi $Perenimi is removed succesfully" -ForegroundColor Green
}
catch {
    # Taasta vaikimisi veakäsitlus
    $ErrorActionPreference = "Continue"
    
    # Kuvada ainult üldine veateade
    Write-Host "User not exists or problem is occuring during user removing, please try again" -ForegroundColor Red
}
