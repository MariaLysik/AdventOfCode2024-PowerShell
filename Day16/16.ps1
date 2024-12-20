$DATA_INPUT = Get-Content .\Day16\16.txt
$START = 'S'
$END = 'E'
$RIGHT = '>'
$LEFT = '<'
$UP = '^'
$DOWN = 'v'
$OBSTACLE = '#'

function Add-RotationNodes([hashtable]$g,[int]$x,[int]$y,[int]$cost = 1000) {
  $u,$d,$l,$r = @($UP,$DOWN,$LEFT,$RIGHT) | ForEach-Object {"${x},${y},"+$_}
  @($u,$d,$l,$r) | ForEach-Object {
    if ($null -eq $g[$_]) {
      $g[$_] = @{}
    }
  }
  $g[$u][$r] = $cost
  $g[$r][$u] = $cost
  $g[$d][$r] = $cost
  $g[$r][$d] = $cost
  $g[$d][$l] = $cost
  $g[$l][$d] = $cost
  $g[$u][$l] = $cost
  $g[$l][$u] = $cost
}

$graph = @{}
for ($x = 0; $x -lt $DATA_INPUT.Length; $x++) {
  for ($y = 0; $y -lt $DATA_INPUT[$x].Length; $y++) {
    if ($DATA_INPUT[$x][$y] -eq $OBSTACLE) {
      continue
    }
    $currentValue = "${x},${y}"
    $rotationCost = 1000
    if ($DATA_INPUT[$x][$y] -eq $START) {
      $START = "$currentValue,$RIGHT"
    }
    elseif ($DATA_INPUT[$x][$y] -eq $END) {
      $END= "$currentValue,$RIGHT"
      $rotationCost = 0
    }
    Add-RotationNodes $graph $x $y $rotationCost
    if ($y+1 -lt $DATA_INPUT[$x].Length -and $DATA_INPUT[$x][$y+1] -ne $OBSTACLE) {
      $graph["$currentValue,$RIGHT"]["${x},$($y+1),$RIGHT"] = 1
      $neighborLeftValue = "${x},$($y+1),$LEFT"
      if ($null -eq $graph[$neighborLeftValue]) {
        $graph[$neighborLeftValue] = @{}
      }
      $graph[$neighborLeftValue]["$currentValue,$LEFT"] = 1
    }
    if ($x+1 -lt $DATA_INPUT.Length -and $DATA_INPUT[$x+1][$y] -ne $OBSTACLE) {
      $graph["$currentValue,$DOWN"]["$($x+1),${y},$DOWN"] = 1
      $neighborUpValue = "$($x+1),${y},$UP"
      if ($null -eq $graph[$neighborUpValue]) {
        $graph[$neighborUpValue] = @{}
      }
      $graph[$neighborUpValue]["$currentValue,$UP"] = 1
    }
  }
}

# Dijkstra
Write-Host $START $END
$distance = @{}
$visited = @{}
$predecessor = @{}
$graph.Keys | ForEach-Object {
  $distance[$_] = [double]::PositiveInfinity
  $visited[$_] = $false
}
$distance[$start] = 0
while ($graph.Count -gt 0) {
  $currentNode = $distance.GetEnumerator() | Where-Object { $visited[$_.Key] -eq $false } | Sort-Object -Property "Value" | Select-Object -First 1
  Write-Host $currentNode
  $visited[$currentNode.Key] = $true
  foreach ($neighbor in $graph[$currentNode.Key].GetEnumerator()) {
    if ($visited[$neighbor.Key]) {
      continue
    }
    if ($distance[$neighbor.Key] -eq $distance[$currentNode.Key] + $neighbor.Value) {
      $predecessor[$neighbor.Key] += ,$currentNode.Key
    }
    elseif ($distance[$neighbor.Key] -gt $distance[$currentNode.Key] + $neighbor.Value) {
      $distance[$neighbor.Key] = ($distance[$currentNode.Key] + $neighbor.Value)
      $predecessor[$neighbor.Key] = @($currentNode.Key)
    }
  }
  $graph.Remove($currentNode.Key)
}

Write-Host $distance[$END]

$toBeVisited = @{$END = $true}
$visited = @{}
while ($toBeVisited.Count -gt 0) {
  $currentNode = $toBeVisited.GetEnumerator() | Select-Object -First 1
  foreach($previousNode in $predecessor[$currentNode.Key]) {
    if ($null -eq $visited[$previousNode]) {
      $toBeVisited[$previousNode] = $true
    }
  }
  $visited[$currentNode.Key] = $true
  $toBeVisited.Remove($currentNode.Key)
}

$result = @()
$visited.Keys | ForEach-Object {
  $x, $y, $d = $_.Split(',')
  $result += "${x},${y}"
}
$uniqueCells = $result | Select-Object -Unique
Write-Host $uniqueCells.Count