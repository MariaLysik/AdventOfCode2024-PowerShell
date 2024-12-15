$f = Get-Content .\Day10\10.txt

$maxX = $f.Length -1
$maxY = $f[0].Length -1

function TrailHead-Score ([int]$x, [int]$y, [int]$expected) {
  $val = [System.Int32]::Parse($f[$x][$y].ToString())
  if ($val -ne $expected) {
    return 0
  }
  if ($val -eq 9) {
    return 1
  }
  $score = 0
  if ($x-1 -ge 0) {
    $score += (TrailHead-Score ($x-1) $y ($val+1))
  }
  if ($x+1 -le $maxX) {
    $score += (TrailHead-Score ($x+1) $y ($val+1))
  }
  if ($y-1 -ge 0) {
    $score += (TrailHead-Score $x ($y-1) ($val+1))
  }
  if ($y+1 -le $maxY) {
    $score += (TrailHead-Score $x ($y+1) ($val+1))
  }
  return $score
}

$sum = 0
for ($row = 0; $row -le $maxX; $row++) {
  for ($column = 0; $column -le $maxY; $column++) {
    if ($f[$row][$column] -eq '0') {
      $sum += (TrailHead-Score $row $column 0)
    }
  }
}
Write-Host $sum
# 81