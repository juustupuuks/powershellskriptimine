# Ask the user for their name using Read-Host
$name = Read-Host -Prompt "Mis on teie nimi?"

# Display the answer in Green color using Write-Host
Write-Host "Tere, $name!" -ForegroundColor Green
