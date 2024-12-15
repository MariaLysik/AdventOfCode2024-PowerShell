$f = Get-Content .\Day12\12.test.txt
$neighbors = @{}
$fences = @{}
for ($x = 0; $x -lt $f.Length; $x++) {
  for ($y = 0; $y -lt $f[0].Length; $y++) {
    $currentKey = "${x}:${y}"
    $fences[$currentKey] = @{}
    if ($null -eq $neighbors[$currentKey]) {
      $neighbors[$currentKey] = @{}
    }
    if ($x -ge 1 -and $f[$x-1][$y] -eq $f[$x][$y]) {
      $neighbors[$currentKey]["$($x-1):${y}"] = $true
    }
    else {
      $fences[$currentKey]['U'] = $true
    }
    if ($x+1 -lt $f.Length -and $f[$x+1][$y] -eq $f[$x][$y]) {
      $neighbors[$currentKey]["$($x+1):${y}"] = $true
    }
    else {
      $fences[$currentKey]['D'] = $true
    }
    if ($y -ge 1 -and $f[$x][$y-1] -eq $f[$x][$y]) {
      $neighbors[$currentKey]["${x}:$($y-1)"] = $true
    }
    else {
      $fences[$currentKey]['L'] = $true
    }
    if ($y+1 -lt $f[0].Length -and $f[$x][$y+1] -eq $f[$x][$y]) {
      $neighbors[$currentKey]["${x}:$($y+1)"] = $true
    }
    else {
      $fences[$currentKey]['R'] = $true
    }
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

function Find-AllCorners ([hashtable]$fields) {
  $corners = 0
  foreach ($field in $fields.GetEnumerator()) {
    # inner corners
    if ($fences[$field.Key]['L'] -and $fences[$field.Key]['D']) {
      $corners++
    }
    if ($fences[$field.Key]['R'] -and $fences[$field.Key]['D']) {
      $corners++
    }
    if ($fences[$field.Key]['L'] -and $fences[$field.Key]['U']) {
      $corners++
    }
    if ($fences[$field.Key]['R'] -and $fences[$field.Key]['U']) {
      $corners++
    }
    # outer corners
    $x, $y = $field.Key.Split(':')
    if ($fences[$field.Key]['R'] -and $fields["$(1+$x):${y}"] -and $fields["$(1+$x):$(1+$y)"]) {
      $corners++
    }
    if ($fences[$field.Key]['L'] -and $fields["$(1+$x):${y}"] -and $fields["$(1+$x):$(-1+$y)"]) {
      $corners++
    }
    if ($fences[$field.Key]['L'] -and $fields["$(-1+$x):${y}"] -and $fields["$(-1+$x):$(-1+$y)"]) {
      $corners++
    }
    if ($fences[$field.Key]['R'] -and $fields["$(-1+$x):${y}"] -and $fields["$(-1+$x):$(1+$y)"]) {
      $corners++
    }
  }
  return $corners
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
  $size = $region.Value.Count
  $fence = ($size -le 2) ? 4 : (Find-AllCorners $region.Value)
  $totalPrice += $size * $fence
}
Write-Host $totalPrice
# 1206