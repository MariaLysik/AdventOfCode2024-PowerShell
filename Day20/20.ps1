$DATA_INPUT = Get-Content .\Day20\20.txt
$MAX_Y = $DATA_INPUT.Length
$MAX_X = $DATA_INPUT[0].Length
$OBSTACLE = '#'
$START = '?'
$END = '?'
$TRACK = @{}
$VISITED = @{}
$CHEAT_PAUSE = 2 # PART 2 - 20
$TRESHOLD = 100

function Get-NStepNeighbors([int]$x,[int]$y,[int]$max,[int]$min) {
  $neighbors = @{}
  for ($n = $min; $n -le $max; $n++) {
    for ($dx = 0; $dx -le $n; $dx++) {
      $dy = $n - $dx
      if (($x+$dx) -lt $MAX_X -and ($y+$dy) -lt $MAX_Y -and $DATA_INPUT[$x+$dx][$y+$dy] -ne $OBSTACLE) {
        $neighbors["$($x+$dx),$($y+$dy)"] = $n
      }
      if (($x-$dx) -ge 0 -and ($y-$dy) -ge 0 -and $DATA_INPUT[$x-$dx][$y-$dy] -ne $OBSTACLE) {
        $neighbors["$($x-$dx),$($y-$dy)"] = $n
      }
      if (($x+$dx) -lt $MAX_X -and ($y-$dy) -ge 0 -and $DATA_INPUT[$x+$dx][$y-$dy] -ne $OBSTACLE) {
        $neighbors["$($x+$dx),$($y-$dy)"] = $n
      }
      if (($x-$dx) -ge 0 -and ($y+$dy) -lt $MAX_Y -and $DATA_INPUT[$x-$dx][$y+$dy] -ne $OBSTACLE) {
        $neighbors["$($x-$dx),$($y+$dy)"] = $n
      }
    }
  }
  return $neighbors
}

for ($y = 0; $y -lt $MAX_Y; $y++) {
  for ($x = 0; $x -lt $MAX_X; $x++) {
    $fieldKey = "${x},${y}"
    switch ($DATA_INPUT[$x][$y]) {
      'S' { $START = $fieldKey }
      'E' { $END = $fieldKey }
      {$_ -ne $OBSTACLE} {
        $TRACK[$fieldKey] = @{} 
        $TRACK[$fieldKey]['next'] = (Get-NStepNeighbors $x $y 1 1).Keys
        $TRACK[$fieldKey]['jump'] = Get-NStepNeighbors $x $y $CHEAT_PAUSE 2
      }
    }
  }
}

function Update-Neighbors([string]$key) {
  $TRACK[$key].next = $TRACK[$key].next | Where-Object { $null -eq $VISITED[$_] }
  $TRACK[$key].jump.Keys | ForEach-Object {
    if ($VISITED[$_]) {
      $TRACK[$key].jump.Remove($_)
    }
  }
}

Write-Host $START '=>' $END
$current = $START
$time = 0
while ($current -ne $END) {
  $VISITED[$current] = $true
  $TRACK[$current]['time'] = $time
  $time++
  Update-Neighbors $current
  $current = $TRACK[$current].next
}
$VISITED[$END] = $true
$TRACK[$END]['time'] = $time

$cheatsOverTresholdCount = 0
foreach($field in $TRACK.GetEnumerator()) {
  foreach($jump in $field.Value.jump.GetEnumerator()) {
    if (($TRACK[$jump.Key].time - $field.Value.time - $jump.Value) -ge $TRESHOLD) {
      $cheatsOverTresholdCount++
    }
  }
}
Write-Host $cheatsOverTresholdCount