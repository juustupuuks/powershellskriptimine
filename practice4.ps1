$i = Read-Host -Prompt "Insert a value: "
$g = Read-Host -Prompt "Insert another value: "

if ($i -gt $g)
{
    Write-Host "The higher number is: $i"
}
else {
    Write-Host "The higher number is: $g"
}

Write-Host "Select Country :" -ForegroundColor Green
Write-Host "1 : India" -ForegroundColor Yellow
Write-Host "2 : Austraalia" -ForegroundColor Yellow
Write-Host "3 : Hiina" -ForegroundColor Yellow

$choice = Read-Host -Prompt "Select one country: "
if ($choice -eq 1) {
    Write-Host "India's capitalis New Delhi."
}
elseif ($choice -eq 2) {
    Write-Host "Australia's capital is Canberra."
}
elseif ($choce -eq 3) {
    Write-Host "China's capital is Beijing."
}
else {
    Write-Host "Invalid input, please select 1, 2 or 3."
}
