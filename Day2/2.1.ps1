$minDif = 1
$maxDif = 3

function Get-FirstAberrationIndex {

  param (
    [string[]]$levels
  )

  if ($levels.count -eq 1) {
    return -1
  }

  $modifier = 1
  $minDif = 1
  $maxDif = 3

  $firstDif = [int]$levels[1] - [int]$levels[0]
  if ([Math]::Abs($firstDif) -lt $minDif -or [Math]::Abs($firstDif) -gt $maxDif) {
    Write-Host $levels 'found aberration' $firstDif 'at index 0'
    return 0
  }

  if ($firstDif -lt 0) {
    $modifier = -1
  }
  for ($i = 1; $i -lt $levels.count - 1; $i++) {
    $dif = ([int]$levels[$i+1] - [int]$levels[$i])*$modifier
    if ($dif -lt $minDif -or $dif -gt $maxDif) {
      Write-Host $levels 'found aberration' $dif 'at index' $i
      return $i
    }
  }
  return -1
}

$safe = 0
Get-Content .\2.0.txt | ForEach-Object {
  $arr = $_.split() | where {$_}
  $indexOfFirstAberration = Get-FirstAberrationIndex $arr
  if ($indexOfFirstAberration -eq -1) {
    Write-Host $arr
    $safe ++
    return
  }
  foreach ($index in $indexOfFirstAberration,($indexOfFirstAberration+1),($indexOfFirstAberration-1)) {
    if ($index -ge 0) {
      Write-Host 'testing without element at index:' $index
      if ($index -eq 0) {
        $arrExceptAberration = $arr[($index+1)..($arr.Length-1)]
      }
      elseif ($index -eq ($arr.Length-1)) {
        $arrExceptAberration = $arr[0..($index-1)]
      }
      else {
        $arrExceptAberration = $arr[0..($index-1)] + $arr[($index+1)..($arr.Length-1)]
      }
      $indexOfSecondAberration = Get-FirstAberrationIndex $arrExceptAberration
      if ($indexOfSecondAberration -eq -1) {
        Write-Host $arr 'without element at index' $index 'is safe'
        $safe ++
        return
      }
    }
  }
}

Write-Host "safe: " $safe