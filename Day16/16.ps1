$f = Get-Content .\Day16\16.txt
#$f = Get-Content .\Day16\16.test.txt

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

Write-Host 'start' $start 'end' $end

$predecessor = @{}
$direction = @{}
$distance = @{}
$visited = @{}
$neighbors.Keys | ForEach-Object {
  $distance[$_] = [double]::PositiveInfinity
  $visited[$_] = $false
}

$distance[$start] = 0
$direction[$start] = $right
while ($neighbors.Count -gt 0) {
  $currentNode = $distance.GetEnumerator() | Where-Object { $visited[$_.Key] -eq $false } | Sort-Object -Property "Value" | Select-Object -First 1
  Write-Host $currentNode
  $visited[$currentNode.Key] = $true
  foreach ($neighbor in $neighbors[$currentNode.Key].GetEnumerator()) {
    if ($visited[$neighbor.Key]) {
      continue
    }
    $cost = $direction[$currentNode.Key] -eq $neighbor.Value ? 1 : 1001
    if ($distance[$neighbor.Key] -gt $distance[$currentNode.Key] + $cost) {
      $distance[$neighbor.Key] = $distance[$currentNode.Key] + $cost
      $predecessor[$neighbor.Key] = $currentNode.Key
      $direction[$neighbor.Key] = $neighbor.Value
    }
  }
  $neighbors.Remove($currentNode.Key)
}

Write-Host $distance[$end]