$arr1 = @()
$arr2 = @()

Get-Content .\Day1\1.0.txt | ForEach-Object {
  $pair = $_.split()| Where-Object {$_}
  $arr1 += [int]$pair[0]
  $arr2 += [int]$pair[1]
}

$arr2 = $arr2 | Sort-Object
$arr1 = $arr1 | Sort-Object

$distance = 0
for ($i = 0; $i -lt $arr1.count; $i++) {
  $distance += [Math]::Abs($arr1[$i]-$arr2[$i])
  $frequency = ($arr2 | Where-Object {$_ -eq $arr1[$i]}).count
  $similarity += $arr1[$i]*$frequency
}
Write-Host 'distance:' $distance
Write-Host 'similarity:' $similarity