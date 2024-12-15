
#$f = Get-Content .\Day15\15.test1.txt
#$f = Get-Content .\Day15\15.test.txt
$f = Get-Content .\Day15\15.txt

$robot = '@'
$obstacle = '#'
$box = 'O'
$empty = '.'
$up = '^'
$down = 'V'
$left = '<'
$right = '>'

$initRow = 0
$initColumn = 0
$moves = @()
$map = @()

$readMoves = $false
for ($row = 0; $row -lt $f.Length; $row++) {
  if ($f[$row].Length -eq 0) {
    $readMoves = $true
  }
  $currentMapRow = @()
  for ($column = 0; $column -lt $f[$row].Length; $column++) {
    if ($readMoves) {
      $moves += $f[$row][$column]
    }
    else {
      $currentMapRow += $f[$row][$column]
      if ($f[$row][$column] -eq $robot) {
        $initRow = $row
        $initColumn = $column
      }
    }
  }
  if (-Not $readMoves) {
    $map += ,$currentMapRow
  }
}

function Get-RowAhead ([int]$row,[int]$col,[string]$dir) {
  return $dir -eq $up ? ($row -1) : $dir -eq $down ? ($row +1) : $row
}
function Get-ColumnAhead ([int]$row,[int]$col,[string]$dir) {
  return $dir -eq $left ? ($col -1) : $dir -eq $right ? ($col +1) : $col
}
function Is-Obstacle ([int]$row,[int]$col) {
  return ($map[$row][$col] -eq $obstacle)
}
function Is-Box ([int]$row,[int]$col) {
  return ($map[$row][$col] -eq $box)
}
function Is-Empty ([int]$row,[int]$col) {
  return ($map[$row][$col] -eq $empty)
}
function GPS-Coordinate([int]$row,[int]$col) {
  return 100 * $row + $col
}
function Next-Empty([int]$row,[int]$col,[string]$dir) {
  do {
    $row = Get-RowAhead $row $col $dir
    $col = Get-ColumnAhead $row $col $dir
  }
  while (Is-Box $row $col)
  if (Is-Empty $row $col) {
    return @{row = $row; column = $col}
  }
  return $false
}
function Display-Map {
  for ($row = 0; $row -lt $map.Length; $row++) {
    Write-Host $map[$row]
  }
}

$currentRow = $initRow
$currentColumn = $initColumn
foreach ($move in $moves) {
  #Write-Host $currentRow $currentColumn $move
  $rowAhead = Get-RowAhead $currentRow $currentColumn $move
  $columnAhead = Get-ColumnAhead $currentRow $currentColumn $move
  if (-Not (Is-Obstacle $rowAhead $columnAhead)) {
    if (Is-Box $rowAhead $columnAhead) {
      $foundEmpty = Next-Empty $rowAhead $columnAhead $move
      if ($foundEmpty) {
        $map[$currentRow][$currentColumn] = $empty
        $map[$foundEmpty.row][$foundEmpty.column] = $box
        $currentRow = $rowAhead
        $currentColumn = $columnAhead
        $map[$currentRow][$currentColumn] = $robot
      }
    }
    else {
      $map[$currentRow][$currentColumn] = $empty
      $currentRow = $rowAhead
      $currentColumn = $columnAhead
      $map[$currentRow][$currentColumn] = $robot
    }
  }
  #Display-Map
}
$sum = 0
for ($row = 0; $row -lt $map.Length; $row++) {
  for ($column = 0; $column -lt $map[$row].Length; $column++) {
    if (Is-Box $row $column) {
      $sum += GPS-Coordinate $row $column
    }
  }
}
Write-Host $sum
# 2028
# 10092
# 1438161