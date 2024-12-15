$f = Get-Content .\Day6\6.txt

$obstacle = '#'
$up = '^'
$down = 'V'
$left = '<'
$right = '>'

$initRow = 0
$initColumn = 0
$initDirection = '?'

for ($row = 0; $row -lt $f.Length -and $initDirection -eq '?'; $row++) {
  for ($column = 0; $column -lt $f[$row].Length -and $initDirection -eq '?'; $column++) {
    if ($up,$down,$left,$right -contains $f[$row][$column]) {
      $initRow = $row
      $initColumn = $column
      $initDirection = $f[$row][$column]
      Write-Host 'guard found at position' $initRow $initColumn 'and moving' $initDirection
    }
  }
}
function Rotate ([string]$dir) {
  if ($dir -eq $up) {
    return $right
  }
  elseif ($dir -eq $down) {
    return $left
  }
  elseif ($dir -eq $left) {
    return $up
  }
  else {
    return $down
  }
}
function Get-RowAhead ([int]$row,[int]$col,[string]$dir) {
  return $dir -eq $up ? ($row -1) : $dir -eq $down ? ($row +1) : $row
}
function Get-ColumnAhead ([int]$row,[int]$col,[string]$dir) {
  return $dir -eq $left ? ($col -1) : $dir -eq $right ? ($col +1) : $col
}
function Is-Exit ([int]$row,[int]$col) {
  return $row -ge $f.Length -or $row -lt 0 -or $col -ge $f[0].Length -or $col -lt 0
}
function Is-Obstacle ([int]$row,[int]$col) {
  if (Is-Exit $row $col) {
    return $false
  }
  return ($f[$row][$col] -eq $obstacle)
}
function Is-LoopIfObstacleAhead ([int]$row,[int]$col,[string]$dir) {
  $hypoteticalObstacleRow = Get-RowAhead $row $col $dir
  $hypoteticalObstacleColumn = Get-ColumnAhead $row $col $dir
  $hypoteticallyVisited = @{}
  while(-Not (Is-Exit $row $col))
  {
    $hypoteticallyVisited["${row}:${col}:${dir}"] = $true
    $rowAhead = Get-RowAhead $row $col $dir
    $columnAhead = Get-ColumnAhead $row $col $dir
    if ((Is-Obstacle $rowAhead $columnAhead) -or (($rowAhead -eq $hypoteticalObstacleRow) -and ($columnAhead -eq $hypoteticalObstacleColumn))) {
      $dir = Rotate $dir
      #Write-Host 'hypotetically turned' $dir '(' $row $col ')'
    }
    else {
      $row = $rowAhead
      $col = $columnAhead
    }
    if ($hypoteticallyVisited["${row}:${col}:${dir}"] -or $currentlyVisited["${row}:${col}:${dir}"]) {
      #Write-Host 'visited, so loop!'
      return $true
    }
  }
  return $false
}

$currentRow = $initRow
$currentColumn = $initColumn
$currentDirection = $initDirection
$checked = @{"${initRow}:${initColumn}" = $false}
$currentlyVisited = @{}
while(-Not (Is-Exit $currentRow $currentColumn)) {
  $currentlyVisited["${currentRow}:${currentColumn}:${currentDirection}"] = $true
  $rowAhead = Get-RowAhead $currentRow $currentColumn $currentDirection
  $columnAhead = Get-ColumnAhead $currentRow $currentColumn $currentDirection
  if (Is-Obstacle $rowAhead $columnAhead) {
    $currentDirection = Rotate $currentDirection
    Write-Host 'turned' $currentDirection '(' $currentRow $currentColumn ')'
  }
  else {
    if ($null -eq $checked["${rowAhead}:${columnAhead}"]) {
      if (Is-Exit $rowAhead $columnAhead) {
        #$checked["${rowAhead}:${columnAhead}"] = $false
      }
      else {
        #Write-Host 'testing obstacle location' $rowAhead $columnAhead
        $checked["${rowAhead}:${columnAhead}"] = Is-LoopIfObstacleAhead $currentRow $currentColumn $currentDirection
      }
    }
    else {
      #Write-Host 'already checked'
    }
    $currentRow = $rowAhead
    $currentColumn = $columnAhead
  }
}
#Write-Host ($checked.GetEnumerator() | Where-Object { $_.Value -eq $true })
Write-Host ($checked.GetEnumerator() | Where-Object { $_.Value -eq $true }).Count
# 1915