$f = Get-Content .\Day6\6.txt

$obstacle = '#'
$up = '^'
$down = 'V'
$left = '<'
$right = '>'

$currentRow = 0
$currentColumn = 0
$direction = '?'
$visited = @{}

for ($row = 0; $row -lt $f.Length -and $direction -eq '?'; $row++) {
  for ($column = 0; $column -lt $f[$row].Length -and $direction -eq '?'; $column++) {
    if ($up,$down,$left,$right -contains $f[$row][$column]) {
      $currentRow = $row
      $currentColumn = $column
      $direction = $f[$row][$column]
      Write-Host 'guard found at position' $currentRow $currentColumn 'and moving' $direction
    }
  }
}
function Is-ObstacleAhead {
  $rowAhead = $direction -eq $up ? ($currentRow -1) : $direction -eq $down ? ($currentRow +1) : $currentRow
  $columnAhead = $direction -eq $left ? ($currentColumn -1) : $direction -eq $right ? ($currentColumn +1) : $currentColumn
  if ($rowAhead -ge $f.Length -or $rowAhead -lt 0 -or $columnAhead -ge $f[0].Length -or $columnAhead -lt 0) {
    Write-Host 'exit ahead!'
    return $false
  }
  return ($f[$rowAhead][$columnAhead] -eq $obstacle)
}
function Rotate {
  if ($direction -eq $up) {
    return $right
  }
  elseif ($direction -eq $down) {
    return $left
  }
  elseif ($direction -eq $left) {
    return $up
  }
  else {
    return $down
  }
}

while ($currentRow -lt $f.Length -and $currentRow -ge 0 -and $currentColumn -lt $f[0].Length -and $currentColumn -ge 0) {
  if (Is-ObstacleAhead) {
    $direction = Rotate
    Write-Host 'turned' $direction '(' $currentRow $currentColumn ')'
  }
  else {
    $visited["${currentRow}:${currentColumn}"] = $true
    $currentRow = $direction -eq $up ? ($currentRow -1) : $direction -eq $down ? ($currentRow +1) : $currentRow
    $currentColumn = $direction -eq $left ? ($currentColumn -1) : $direction -eq $right ? ($currentColumn +1) : $currentColumn
  }
}

#Write-Host $visited.Keys
Write-host $visited.Keys.Count