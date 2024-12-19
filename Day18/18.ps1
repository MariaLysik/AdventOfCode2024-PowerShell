$DATA_INPUT = Get-Content .\Day18\18.txt
$MAX_X = 70
$MAX_Y = 70
$START = "0,0"
$END = "${MAX_X},${MAX_Y}"

# heuristic function for A*
function DistanceToEnd([string]$a) {
  [int]$ax, [int]$ay = $a.Split(',')
  return $MAX_X-$ax + $MAX_Y-$aY
}

function Graph-AfterByteFall([int]$n) {
  $memorySpace = @()
  for ($y = 0; $y -le $MAX_Y; $y++) {
    $row = @()
    for ($x = 0; $x-le $MAX_X; $x++) {
      $row += 1
    }
    $memorySpace += ,$row
  }
  for ($i = 0; $i -lt $n; $i++) {
    [int]$x, [int]$y = $DATA_INPUT[$i].Split(',')
    $memorySpace[$y][$x] = 0
  }
  $graph = @{}
  for ($x = 0; $x -le $MAX_X; $x++) {
    for ($y = 0; $y -le $MAX_Y; $y++) {
      if ($memorySpace[$y][$x] -eq 0) {
        continue
      }
      $currentValue = "${x},${y}"
      if ($x+1 -le $MAX_X -and $memorySpace[$y][$x+1] -eq 1) {
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
      if ($y+1 -le $MAX_Y -and $memorySpace[$y+1][$x] -eq 1) {
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
  return $graph
}

function A-Star ([hashtable]$graph) {
  $openSet = @{}
  $openSet[$START] = DistanceToEnd $START $END
  $distance = @{}
  $distance[$START] = 0
  while ($openSet.Count -gt 0) {
    $currentNode = $openSet.GetEnumerator() | Sort-Object -Property "Value" | Select-Object -First 1
    if ($currentNode.Key -eq $END) {
      break
    }
    foreach ($neighbor in $graph[$currentNode.Key].GetEnumerator()) {
      if ($null -eq $distance[$neighbor.Key] -or $distance[$neighbor.Key] -gt $distance[$currentNode.Key] + 1) {
        $distance[$neighbor.Key] = $distance[$currentNode.Key] + 1
        $openSet[$neighbor.Key] = $distance[$currentNode.Key] + 1 + (DistanceToEnd $neighbor.Key $END)
      }
    }
    $openSet.Remove($currentNode.Key)
  }
  return $distance[$END]
}

function Solution([int]$n) {
  $graph = Graph-AfterByteFall $n
  return (A-Star $graph)
}

#PART 1
Write-Host (Solution 1024)

#PART 2
$N = $DATA_INPUT.Length
while($null -eq (Solution $N)) {
  $N--
}
Write-Host 'last byte' $DATA_INPUT[$N]