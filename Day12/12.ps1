$f = Get-Content .\Day12\12.txt
$neighbors = @{}
$fences = @{}
for ($x = 0; $x -lt $f.Length; $x++) {
  for ($y = 0; $y -lt $f[0].Length; $y++) {
    $currentKey = "${x}:${y}"
    if ($null -eq $neighbors[$currentKey]) {
      $neighbors[$currentKey] = @{}
    }
    if ($x -ge 1 -and $f[$x-1][$y] -eq $f[$x][$y]) {
      $neighbors[$currentKey]["$($x-1):${y}"] = $true
    }
    if ($x+1 -lt $f.Length -and $f[$x+1][$y] -eq $f[$x][$y]) {
      $neighbors[$currentKey]["$($x+1):${y}"] = $true
    }
    if ($y -ge 1 -and $f[$x][$y-1] -eq $f[$x][$y]) {
      $neighbors[$currentKey]["${x}:$($y-1)"] = $true
    }
    if ($y+1 -lt $f[0].Length -and $f[$x][$y+1] -eq $f[$x][$y]) {
      $neighbors[$currentKey]["${x}:$($y+1)"] = $true
    }
    $fences[$currentKey] = 4 - $neighbors[$currentKey].Keys.Count
  }
}

function Merge-Neighbors ([string]$primary, [string]$secondary) {
  if ($null -eq $regions[$primary]) {
    $regions[$primary] = @{$primary = $true}
  }
  $regions[$primary][$secondary] = $true
  $neighbors[$secondary].Remove($primary)
  foreach ($key in $neighbors[$secondary].Keys) {
    $neighbors[$key].Remove($secondary)
    $neighbors[$key][$primary] = $true
    $neighbors[$primary][$key] = $true
  }
  $neighbors[$primary].Remove($secondary)
  $neighbors.Remove($secondary)
}

$regions = @{}
while ($neighbors.Count -gt 0) {
  $currentKey = ($neighbors.Count -eq 1) ? "$($neighbors.Keys)" : $($neighbors.Keys)[0]
  if ($neighbors[$currentKey].Count -eq 0) {
    if ($null -eq $regions[$currentKey]) {
      $regions[$currentKey] = @{$currentKey = $true}
    }
    $neighbors.Remove($currentKey)
  }
  else {
    $neighbors[$currentKey].Keys | % {
      Merge-Neighbors $currentKey $_
    }
  }
}
$totalPrice = 0
foreach ($region in $regions.GetEnumerator()) {
  Write-Host $region.Key $region.Value
  $fence = 0
  $size = 0
  foreach ($field in $region.Value.GetEnumerator()) {
    $fence += $fences[$field.Key]
    $size++
  }
  $totalPrice += $size * $fence
}
Write-Host $totalPrice
# 1930