$file = "C:\Users\Administrator\Documents\adusers.csv"
$users = Import-Csv $file -Encoding Default -Delimiter ";"

function Translit {
    param([string] $inputString)
    $Translit = @{
        [char]'ä' = "a"
        [char]'õ' = "o"
        [char]'ü' = "u"
        [char]'ö' = "o"
    }
    $outputString = ""
    foreach ($character in $inputString.ToCharArray()) {
        if ($Translit[$character] -cne $Null) {
            $outputString += $Translit[$character]
        } else {
            $outputString += $character
        }
    }
    Write-Output $outputString
}

foreach ($user in $users) {
    $username = $user.FirstName + "." + $user.LastName
    $username = $username.ToLower()
    $username = Translit($username)
    $upname = $username + "@sv-kool.local"
    $displayname = $user.FirstName + " " + $user.LastName
    $parool = ConvertTo-SecureString $user.Password -AsPlainText -Force
    New-ADUser -Name $username -DisplayName $displayname -GivenName $user.FirstName -Surname $user.LastName -Department $user.Department -Title $user.Role -UserPrincipalName $upname -AccountPassword $parool -Enabled $true
}
