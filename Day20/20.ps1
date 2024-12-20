$DATA_INPUT = Get-Content .\Day20\20.txt
$MAX_Y = $DATA_INPUT.Length
$MAX_X = $DATA_INPUT[0].Length
$START = '?'
$END = '?'
$TRACK = @{}
$VISITED = @{}
$CHEAT_PAUSE = 2

function Get-NStepNeighbors([int]$x,[int]$y,[int]$n) {
  $neighbors = @{}
  for ($dx = 0; $dx -le $n; $dx++) {
    $dy = $n - $dx
    $neighbors["$($x+$dx),$($y+$dy)"] = $n
    $neighbors["$($x-$dx),$($y-$dy)"] = $n
    $neighbors["$($x+$dx),$($y-$dy)"] = $n
    $neighbors["$($x-$dx),$($y+$dy)"] = $n
  }
  return $neighbors.Keys
}

function Update-Neighbors([string]$key) {
  $TRACK[$key].next = $TRACK[$key].next | Where-Object { $TRACK[$_] -and $null -eq $VISITED[$_] }
  $TRACK[$key].jump = $TRACK[$key].jump | Where-Object { $TRACK[$_] -and $null -eq $VISITED[$_] }
}

for ($y = 0; $y -lt $MAX_Y; $y++) {
  for ($x = 0; $x -lt $MAX_X; $x++) {
    $fieldKey = "${x},${y}"
    switch ($DATA_INPUT[$x][$y]) {
      'S' { $START = $fieldKey }
      'E' { $END = $fieldKey }
      {$_ -ne '#'} {
        $TRACK[$fieldKey] = @{} 
        $TRACK[$fieldKey]['next'] = Get-NStepNeighbors $x $y 1
        $TRACK[$fieldKey]['jump'] = Get-NStepNeighbors $x $y $CHEAT_PAUSE
      }
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

$TRESHOLD = 100
$cheatsOverTresholdCount = 0
foreach($field in $TRACK.GetEnumerator()) {
  foreach($jump in $field.Value.jump) {
    if ($TRACK[$jump].time - $field.Value.time -$CHEAT_PAUSE -ge $TRESHOLD) {
      Write-Host $field.Key 'jumps to' $jump
      $cheatsOverTresholdCount++
    }
  }
}
Write-Host $cheatsOverTresholdCount