
$maxX = 101
$maxY = 103
$f = Get-Content .\Day14\14.txt

function Variance([int[]]$values) {
  $sumOfSquares = 0
  $avgCount = $values | Measure-Object -Average | Select-Object Average, Count
  foreach($number in $values) {
    $sumOfSquares += [Math]::Pow(($number - $avgCount.Average), 2)
  }
  # sum of squares would be enough, as the guard count is constant
  return $sumOfSquares / ($values.Count-1)
}

function TimeWithLowestVariance([hashtable]$varianceInTime) {
  $tMinVariance = -1
  $minVariance = -1
  $varianceInTime.Keys | ForEach-Object {
    $currentVariance = (Variance $varianceInTime[$_])
    Write-Host $_ $currentVariance
    if ($minVariance -eq -1 -or $minVariance -gt $currentVariance) {
      $minVariance = $currentVariance
      $tMinVariance = $_
    }
  }
  return $tMinVariance % $maxX
}

$xVarianceInTime = @{}
$yVarianceInTime = @{}
for ($line = 0; $line -lt $f.Length; $line++) {
  [int]$x, [int]$y, [int]$dx, [int]$dy = [Regex]::new('(-?\d+)').Matches($f[$line]).Value
  for ($t = 1; $t -le $maxY; $t++) {
    $x += $dx 
    while ($x -ge $maxX) {
      $x -= $maxX
    }
    while ($x -lt 0) {
      $x += $maxX
    }
    $xVarianceInTime[$t] += , $x
    $y += $dy
    while ($y -ge $maxY) {
      $y -= $maxY
    }
    while ($y -lt 0) {
      $y += $maxY
    }
    $yVarianceInTime[$t] += , $y
  }
}

$tx = TimeWithLowestVariance $xVarianceInTime
$ty = TimeWithLowestVariance $yVarianceInTime
Write-Host $tx $ty

$i = 0
$j = 0
$loopInterval = $maxX * $maxY
# find such i for which j is an integer
while ($i -le $loopInterval) {
  $j = ($tx - $ty + $i * $maxX)/$maxY
  if ([Math]::Floor($j) -eq $j) {
    Write-Host 'found i' $i 'and j' $j
    break
  }
  $i++
}
$offset = $ty + $j * $maxY
#$offset = $tx + $i * $maxX
Write-Host $offset
# easter egg occurs after each $loopInterval with $offset
# 7371 (mod 10403)

$guards = @{}
for ($line = 0; $line -lt $f.Length; $line++) {
  [int]$x, [int]$y, [int]$dx, [int]$dy = [Regex]::new('(-?\d+)').Matches($f[$line]).Value
  $x = ($x + $offset * $dx) % $maxX 
  if ($x -lt 0) {
    $x += $maxX
  }
  $y = ($y + $offset * $dy) % $maxY
  if ($y -lt 0) {
    $y += $maxY
  }
  $guards["${x}:${y}"] = $true
}
for ($y = 0; $y -lt $maxY; $y++) {
  $currentRow = ""
  for ($x = 0; $x -lt $maxX; $x++) {
    if ($guards["${x}:${y}"]) {
      $currentRow += 'x'
    }
    else {
      $currentRow += '.'
    }
  }
  Write-Host $currentRow
}