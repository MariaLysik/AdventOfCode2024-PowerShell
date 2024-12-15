$minDif = 1
$maxDif = 3

$safe = 0
Get-Content .\Day2\2.0.txt | ForEach-Object {
  $arr = $_.split() | Where-Object {$_}
  if ($arr.count -eq 1) {
    $safe ++
    return
  }
  else {
    $modifier = 1
    $firstDif = [int]$arr[1] - [int]$arr[0]
    if ([Math]::Abs($firstDif) -lt $minDif -or [Math]::Abs($firstDif) -gt $maxDif) {
      Write-Host $_ 'found aberration' $firstDif
      return
    }
    if ($firstDif -lt 0) {
      $modifier = -1
    }
    for ($i = 1; $i -lt $arr.count - 1; $i++) {
      $dif = ([int]$arr[$i+1] - [int]$arr[$i])*$modifier
      if ($dif -lt $minDif -or $dif -gt $maxDif) {
        Write-Host $_ 'found aberration' $dif
        return
      }
    }
  }
  $safe ++
  Write-Host $_
}

Write-Host "safe: " $safe