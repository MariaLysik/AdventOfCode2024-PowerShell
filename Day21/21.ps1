$DATA_INPUT = Get-Content .\Day21\21.txt
$LEFT = '<'
$RIGHT = '>'
$UP = '^'
$DOWN = 'v'
$ACTIVATE = 'A'

$NUMERIC_KEYPAD_GRAPH = @{
  $ACTIVATE = @{'0'=$LEFT;'3'=$UP}
  '0' = @{$ACTIVATE=$RIGHT;'2'=$UP}
  '1' = @{'2'=$RIGHT;'4'=$UP}
  '2' = @{'1'=$LEFT;'3'=$RIGHT;'5'=$UP;'0'=$DOWN}
  '3' = @{'2'=$LEFT;'6'=$UP;$ACTIVATE=$DOWN}
  '4' = @{'5'=$RIGHT;'7'=$UP;'1'=$DOWN}
  '5' = @{'4'=$LEFT;'6'=$RIGHT;'8'=$UP;'2'=$DOWN}
  '6' = @{'5'=$LEFT;'9'=$UP;'3'=$DOWN}
  '7' = @{'8'=$RIGHT;'4'=$DOWN}
  '8' = @{'7'=$LEFT;'9'=$RIGHT;'5'=$DOWN}
  '9' = @{'8'=$LEFT;'6'=$DOWN}
}
$DIRECTIONAL_KEYPAD_GRAPH = @{
  $ACTIVATE = @{$UP=$LEFT;$RIGHT=$DOWN}
  $LEFT = @{$DOWN=$RIGHT}
  $RIGHT = @{$DOWN=$LEFT;$ACTIVATE=$UP}
  $UP = @{$ACTIVATE=$RIGHT;$DOWN=$DOWN}
  $DOWN = @{$LEFT=$LEFT;$RIGHT=$RIGHT;$UP=$UP}
}
function Dijkstra ([hashtable]$G,[string]$root,[bool]$weighted = $false) {
  $graph = $G.Clone()
  $distance = @{}
  $visited = @{}
  $predecessor = @{}
  $graph.Keys | ForEach-Object {
    $distance[$_] = [double]::PositiveInfinity
    $visited[$_] = $false
  }
  $distance[$root] = 0
  while ($graph.Count -gt 0) {
    $currentNode = $distance.GetEnumerator() | Where-Object { $visited[$_.Key] -eq $false } | Sort-Object -Property "Value" | Select-Object -First 1
    $visited[$currentNode.Key] = $true
    foreach ($neighbor in $graph[$currentNode.Key].GetEnumerator()) {
      if ($visited[$neighbor.Key]) {
        continue
      }
      $cost = $distance[$currentNode.Key] + 1
      if ($distance[$neighbor.Key] -eq $cost) {
        $predecessor[$neighbor.Key] += ,$currentNode.Key
      }
      if ($distance[$neighbor.Key] -gt $cost) {
        $distance[$neighbor.Key] = $cost
        $predecessor[$neighbor.Key] = @($currentNode.Key)
      }
    }
    $graph.Remove($currentNode.Key)
  }
  $shortestPath = @{}
  $G.Keys | Where-Object {$_ -ne $root} | ForEach-Object {
    $allPaths = Get-AllPaths $G $predecessor $_
    if ($allPaths.Count -eq 1) {
      $bestPath = $allPaths
    }
    else {
      $bestPath = $allPaths[0]
      $bestCost = RotationCost $bestPath $weighted
      for($i = 1; $i -lt $allPaths.Count; $i++) {
        $rotationCost = RotationCost $allPaths[$i] $weighted
        if ($rotationCost -lt $bestCost) {
          $bestCost = $rotationCost
          $bestPath = $allPaths[$i]
        }
      }
    }
    $shortestPath[$_] = $bestPath
  }
  return $shortestPath
}

function RotationCost([string]$path,[bool]$weighted) {
  $current = $path[0].ToString()
  $cost = 0
  for($j = 1; $j -lt $path.Length; $j++) {
    $next = $path[$j].toString()
    if ($next -ne $current) {
      if ($weighted) {
        $cost += $DIRECTIONAL_KEYPAD_SHORTEST_PATH[$current][$next].Length
      }
      else {
        $cost++
      }
    }
    $current = $next
  }
  if($weighted) {
    $cost += $DIRECTIONAL_KEYPAD_SHORTEST_PATH[$current][$ACTIVATE].Length
  }
  return $cost
}

function Get-AllPaths([hashtable]$G, [hashtable]$P, [string]$node) {
  $paths = @()
  foreach ($previous in $P[$node]) {
    if ($null -eq $P[$previous]) {
      $paths += $G[$previous][$node]
      continue
    }
    foreach ($prevPath in (Get-AllPaths $G $P $previous)) {
      $paths += ($prevPath + $G[$previous][$node])
    }
  }
  return $paths
}

$DIRECTIONAL_KEYPAD_SHORTEST_PATH = @{}
$DIRECTIONAL_KEYPAD_GRAPH.Keys | ForEach-Object {
  $DIRECTIONAL_KEYPAD_SHORTEST_PATH[$_] = Dijkstra $DIRECTIONAL_KEYPAD_GRAPH $_
  $DIRECTIONAL_KEYPAD_SHORTEST_PATH[$_][$_] = ''
}
$NUMERIC_KEYPAD_SHORTEST_PATH = @{}
$NUMERIC_KEYPAD_GRAPH.Keys | ForEach-Object {
  $NUMERIC_KEYPAD_SHORTEST_PATH[$_] = Dijkstra $NUMERIC_KEYPAD_GRAPH $_ $true
  $NUMERIC_KEYPAD_SHORTEST_PATH[$_][$_] = ''
}

function DisplayShortestPaths([hashtable]$H) {
  foreach ($from in $H.GetEnumerator()) {
    foreach ($to in $from.Value.GetEnumerator()) {
      Write-Host $from.Key '->' $to.Key ':' $to.Value
    }
  }
}
#DisplayShortestPaths $DIRECTIONAL_KEYPAD_SHORTEST_PATH
#DisplayShortestPaths $NUMERIC_KEYPAD_SHORTEST_PATH

function Get-InitialDirectionalSequence([string]$numericSequence) {
  $result = ''
  $numKeyPadPosition = $ACTIVATE
  for($i = 0; $i -lt $numericSequence.Length; $i++) {
    $current = $numericSequence[$i].toString()
    $result += ($NUMERIC_KEYPAD_SHORTEST_PATH[$numKeyPadPosition][$current] + $ACTIVATE)
    $numKeyPadPosition = $current
  }
  return $result
}

function Do-Robot ([hashtable]$sequences) {
  $newSequences = @{}
  foreach($sequence in $sequences.GetEnumerator()) {
    $previous = $ACTIVATE
    for($i = 0; $i -lt $sequence.Key.Length; $i++) {
      $current = $sequence.Key[$i].toString()
      $newSequences["$($DIRECTIONAL_KEYPAD_SHORTEST_PATH[$previous][$current] + $ACTIVATE)"] += $sequence.Value
      $previous = $current
    }
  }
  return $newSequences
}

$DIRECTIONAL_LOOP_COUNT = 2
$sum = 0
foreach ($line in $DATA_INPUT) {
  [int]$number = [Regex]::new('(\d+)').Matches($line).Value
  $initSequence = (Get-InitialDirectionalSequence $line)
  $sequenceMap = @{$initSequence = 1}
  for ($robot = 0; $robot -lt $DIRECTIONAL_LOOP_COUNT; $robot++) {
    $sequenceMap = (Do-Robot $sequenceMap)
  }
  $total = 0
  $sequenceMap.GetEnumerator() | ForEach-Object { $total += ($_.Key.Length * $_.value) }
  $sum += ($total  * $number)
}
Write-Host $sum

# Part 1, for 2 robots OK - 248684
# Part 2, for 25 too high - 307690647084640