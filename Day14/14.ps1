$maxX = 101
$maxY = 103
$time = 100

$f = Get-Content .\Day14\14.txt

$middleX = [Math]::Floor($maxX/2)
$middleY = [Math]::Floor($maxY/2)
$quadrantUpLeft = 0
$quadrantUpRight = 0
$quadrantDownLeft = 0
$quadrantDownRight = 0
for ($line = 0; $line -lt $f.Length; $line++) {
  [int]$x, [int]$y, [int]$dx, [int]$dy = [Regex]::new('(-?\d+)').Matches($f[$line]).Value
  #Write-Host $x $y '|' $dx $dy
  $x = ($x + $time * $dx) % $maxX 
  if ($x -lt 0) {
    $x += $maxX
  }
  $y = ($y + $time * $dy) % $maxY
  if ($y -lt 0) {
    $y += $maxY
  }
  #Write-Host '->' $x $y
  if ($x -lt $middleX) {
    if ($y -lt $middleY) {
      $quadrantUpLeft++
    }
    if ($y -gt $middleY) {
      $quadrantDownLeft++
    }
  }
  if ($x -gt $middleX) {
    if ($y -lt $middleY) {
      $quadrantUpRight++
    }
    if ($y -gt $middleY) {
      $quadrantDownRight++
    }
  }
}
$safetyFactor = $quadrantUpLeft * $quadrantUpRight * $quadrantDownLeft * $quadrantDownRight
Write-Host $safetyFactor