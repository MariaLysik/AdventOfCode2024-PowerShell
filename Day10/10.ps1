$f = Get-Content .\Day10\10.txt

$maxX = $f.Length -1
$maxY = $f[0].Length -1
Write-Host $maxX $maxY

function Get-TrailHeads ([int]$x, [int]$y, [int]$val) {
  if ($val -eq 9) {
    $trailheads["${x}:${y}"] = $true
  }
  if ($x-1 -ge 0) {
    $valUp = [System.Int32]::Parse($f[$x-1][$y].ToString())
    if ($valUp -eq ($val+1)) {
      Get-TrailHeads ($x-1) $y ($val+1)
    }
  }
  if ($x+1 -le $maxX) {
    $valDown = [System.Int32]::Parse($f[$x+1][$y].ToString())
    if ($valDown -eq ($val+1)) {
      Get-TrailHeads ($x+1) $y ($val+1)
    }
  }
  if ($y-1 -ge 0) {
    $valLeft = [System.Int32]::Parse($f[$x][$y-1].ToString())
    if ($valLeft -eq ($val+1)) {
      Get-TrailHeads $x ($y-1) ($val+1)
    }
  }
  if ($y+1 -le $maxY) {
    $valRight = [System.Int32]::Parse($f[$x][$y+1].ToString())
    if ($valRight -eq ($val+1)) {
      Get-TrailHeads $x ($y+1) ($val+1)
    }
  }
}

$sum = 0
for ($row = 0; $row -le $maxX; $row++) {
  for ($column = 0; $column -le $maxY; $column++) {
    if ($f[$row][$column] -eq '0') {
      Write-Host 'starting point' $row $column
      $trailheads = @{}
      Get-TrailHeads $row $column 0
      Write-Host $trailheads.Keys
      $sum += $trailheads.Keys.Count
    }
  }
}
Write-Host $sum
# 5, 6, 5, 3, 1, 3, 5, 3, and 5 = 36