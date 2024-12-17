$f = Get-Content .\Day16\16.txt
# A* algorithm

$right = '>'
$left = '<'
$up = '^'
$down = 'v'
$start = 'S'
$end = 'E'
$obstacle = '#'
$neighbors = @{} #graph

for ($x = 0; $x -lt $f.Length; $x++) {
  for ($y = 0; $y -lt $f[$x].Length; $y++) {
    if ($f[$x][$y] -eq $obstacle) {
      continue
    }
    $currentValue = "${x},${y}"
    if ($f[$x][$y] -eq $start) {
      $start = $currentValue
    }
    elseif ($f[$x][$y] -eq $end) {
      $end = $currentValue
    }
    if ($y+1 -lt $f[$x].Length -and $f[$x][$y+1] -ne $obstacle) {
      $neighborValue = "${x},$($y+1)"
      if ($null -eq $neighbors[$currentValue]) {
        $neighbors[$currentValue] = @{}
      }
      $neighbors[$currentValue][$neighborValue] = $right
      if ($null -eq $neighbors[$neighborValue]) {
        $neighbors[$neighborValue] = @{}
      }
      $neighbors[$neighborValue][$currentValue] = $left
    }
    if ($x+1 -lt $f.Length -and $f[$x+1][$y] -ne $obstacle) {
      $neighborValue = "$($x+1),${y}"
      if ($null -eq $neighbors[$currentValue]) {
        $neighbors[$currentValue] = @{}
      }
      $neighbors[$currentValue][$neighborValue] = $down
      if ($null -eq $neighbors[$neighborValue]) {
        $neighbors[$neighborValue] = @{}
      }
      $neighbors[$neighborValue][$currentValue] = $up
    }
  }
}

# heuristic function for A*
function DistanceInStraightLine([string]$a,[string]$b) {
  [int]$ax, [int]$ay = $a.Split(',')
  [int]$bx, [int]$by = $b.Split(',')
  return [Math]::Sqrt([Math]::Pow($ax-$bx,2) + [Math]::Pow($ay-$by,2))
}

Write-Host 'start' $start 'end' $end

$openSet = @{}
$openSet[$start] = DistanceInStraightLine $start $end
$predecessor = @{}
$direction = @{}
$distance = @{}
$distance[$start] = 0
$direction[$start] = $right
while ($openSet.Count -gt 0) {
  $currentNode = $openSet.GetEnumerator() | Sort-Object -Property "Value" | Select-Object -First 1
  Write-Host $currentNode
  if ($currentNode.Key -eq $end) {
    Write-Host 'end!'
    break
  }
  foreach ($neighbor in $neighbors[$currentNode.Key].GetEnumerator()) {
    $cost = $direction[$currentNode.Key] -eq $neighbor.Value ? 1 : 1001
    if ($null -eq $distance[$neighbor.Key] -or $distance[$neighbor.Key] -gt $distance[$currentNode.Key] + $cost) {
      $distance[$neighbor.Key] = $distance[$currentNode.Key] + $cost
      $predecessor[$neighbor.Key] = $currentNode.Key
      $direction[$neighbor.Key] = $neighbor.Value
      $openSet[$neighbor.Key] = $distance[$currentNode.Key] + $cost + (DistanceInStraightLine $neighbor.Key $end)
    }
  }
  $openSet.Remove($currentNode.Key)
}

$currentNode = $end
while($predecessor[$currentNode]) {
  Write-Host $predecessor[$currentNode]
  $currentNode = $predecessor[$currentNode]
}

Write-Host $distance[$end]