$f = Get-Content .\Day18\18.txt
$nOfBytesToSimulate = 1024
$maxX = 70
$maxY = 70
$start = "0,0"
$end = "${maxX},${maxY}"

$memorySpace = @()
for ($y = 0; $y -le $maxY; $y++) {
  $row = @()
  for ($x = 0; $x-le $maxX; $x++) {
    $row += 1
  }
  $memorySpace += ,$row
}
for ($i = 0; $i -lt $nOfBytesToSimulate; $i++) {
  [int]$x, [int]$y = $f[$i].Split(',')
  $memorySpace[$y][$x] = 0
}

# A* algorithm
$graph = @{}
for ($x = 0; $x -le $maxX; $x++) {
  for ($y = 0; $y -le $maxY; $y++) {
    if ($memorySpace[$y][$x] -eq 0) {
      continue
    }
    $currentValue = "${x},${y}"
    if ($x+1 -le $maxX -and $memorySpace[$y][$x+1] -eq 1) {
      $neighborValue = "$($x+1),${y}"
      if ($null -eq $graph[$currentValue]) {
        $graph[$currentValue] = @{}
      }
      $graph[$currentValue][$neighborValue] = 1
      if ($null -eq $graph[$neighborValue]) {
        $graph[$neighborValue] = @{}
      }
      $graph[$neighborValue][$currentValue] = 1
    }
    if ($y+1 -le $maxY -and $memorySpace[$y+1][$x] -eq 1) {
      $neighborValue = "${x},$($y+1)"
      if ($null -eq $graph[$currentValue]) {
        $graph[$currentValue] = @{}
      }
      $graph[$currentValue][$neighborValue] = 1
      if ($null -eq $graph[$neighborValue]) {
        $graph[$neighborValue] = @{}
      }
      $graph[$neighborValue][$currentValue] = 1
    }
  }
}

# heuristic function for A*
function DistanceToEnd([string]$a) {
  [int]$ax, [int]$ay = $a.Split(',')
  return $maxX-$ax + $maxY-$aY
}

$openSet = @{}
$openSet[$start] = DistanceToEnd $start $end
$distance = @{}
$distance[$start] = 0
while ($openSet.Count -gt 0) {
  $currentNode = $openSet.GetEnumerator() | Sort-Object -Property "Value" | Select-Object -First 1
  if ($currentNode.Key -eq $end) {
    Write-Host 'end!'
    break
  }
  foreach ($neighbor in $graph[$currentNode.Key].GetEnumerator()) {
    if ($null -eq $distance[$neighbor.Key] -or $distance[$neighbor.Key] -gt $distance[$currentNode.Key] + 1) {
      $distance[$neighbor.Key] = $distance[$currentNode.Key] + 1
      $openSet[$neighbor.Key] = $distance[$currentNode.Key] + 1 + (DistanceToEnd $neighbor.Key $end)
    }
  }
  $openSet.Remove($currentNode.Key)
}
Write-Host $distance[$end]