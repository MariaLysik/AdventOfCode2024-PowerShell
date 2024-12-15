$f = Get-Content .\Day4\4.0.txt
$nOfRows = $f.Length
$nOfColumns = $f[0].Length

function Find-Mas {

  param (
    [int]$x,
    [int]$y,
    [int]$xInc,
    [int]$yInc
  )

  $mX = ($x+$xInc)
  $mY = ($y+$yInc)
  $aX = ($x+2*$xInc)
  $aY = ($y+2*$yInc)
  $sX = ($x+3*$xInc)
  $sY = ($y+3*$yInc)

  #Write-Host 'M' $mX $mY 'A' $aX $aY 'S' $sX $sY

  if ($mX -ge 0 -and $mY -ge 0 -and $aX -ge 0 -and $aY -ge 0 -and $sX -ge 0 -and $sY -ge 0 -and $mX -lt $nOfRows -and $mY -lt $nOfColumns  -and $aX -lt $nOfRows -and $aY -lt $nOfColumns  -and $sX -lt $nOfRows -and $sY -lt $nOfColumns) {
    if ($f[$mX][$mY] -eq 'M' -and $f[$aX][$aY] -eq 'A' -and $f[$sX][$sY] -eq 'S') {
      return $true
    }
  }
  return $false
}

function Find-AllMas ([int]$x,[int]$y) {
  $count = 0
  if (Find-Mas ($x) ($y) 0 -1) { $count++ }
  if (Find-Mas ($x) ($y) -1 0) { $count++ }
  if (Find-Mas ($x) ($y) 0 1) { $count++ }
  if (Find-Mas ($x) ($y) 1 0) { $count++ }
  if (Find-Mas ($x) ($y) 1 -1) { $count++ }
  if (Find-Mas ($x) ($y) -1 1) { $count++ }
  if (Find-Mas ($x) ($y) -1 -1) { $count++ }
  if (Find-Mas ($x) ($y) 1 1) { $count++ }
  return $count
}

$sum = 0
for ($i = 0; $i -lt $nOfRows; $i++)
{
  for ($j = 0; $j -lt $nOfColumns; $j++)
  {
    if ($f[$i][$j] -eq 'X') {
      $ij = Find-AllMas $i $j
      $sum += $ij
      #Write-Host 'X at [' $i ',' $j '] has' $ij 'MAS'
    }
  }
}

Write-Host $sum
#test result 18

function Is-XMas ([int]$x,[int]$y) {
  if ($x-1 -ge 0 -and $y-1 -ge 0 -and $x+1 -lt $nOfRows -and $y+1 -lt $nOfColumns) {
    $a1 = $f[$x-1][$y-1]
    $a2 = $f[$x+1][$y+1]
    $b1 = $f[$x-1][$y+1]
    $b2 = $f[$x+1][$y-1]
    if ((($a1 -eq 'M' -and $a2 -eq 'S') -or ($a1 -eq 'S' -and $a2 -eq 'M')) -and (($b1 -eq 'M' -and $b2 -eq 'S') -or ($b1 -eq 'S' -and $b2 -eq 'M'))) {
      return $true
    }
  }
  return $false
}

$sum = 0
for ($i = 0; $i -lt $nOfRows; $i++)
{
  for ($j = 0; $j -lt $nOfColumns; $j++)
  {
    if ($f[$i][$j] -eq 'A') {
      if (Is-XMas $i $j) {
        $sum++
        #Write-Host 'A at [' $i ',' $j '] is a middle of a proper X-MAS'
      }
    }
  }
}

Write-Host $sum
#test result 9