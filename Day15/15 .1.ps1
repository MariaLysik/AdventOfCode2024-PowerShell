#$f = Get-Content .\Day15\15.test1.txt
#$f = Get-Content .\Day15\15.test.txt
$f = Get-Content .\Day15\15.txt

$robot = '@'
$obstacle = '#'
$box = 'O'
$boxLeft = '['
$boxRight = ']'
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
      if ($f[$row][$column] -eq $box) {
        $currentMapRow += $boxLeft
        $currentMapRow += $boxRight
      }
      elseif ($f[$row][$column] -eq $robot) {
        $initRow = $row
        $initColumn = $currentMapRow.Length
        $currentMapRow += $robot
        $currentMapRow += $empty
      }
      else {
        $currentMapRow += $f[$row][$column]
        $currentMapRow += $f[$row][$column]
      }
    }
  }
  if (-Not $readMoves) {
    $map += ,$currentMapRow
  }
}

function Display-Map {
  for ($row = 0; $row -lt $map.Length; $row++) {
    Write-Host $map[$row]
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
  return (Is-BoxLeft $row $col) -or (Is-BoxRight $row $col)
}
function Is-BoxLeft ([int]$row,[int]$col) {
  return ($map[$row][$col] -eq $boxLeft)
}
function Is-BoxRight ([int]$row,[int]$col) {
  return ($map[$row][$col] -eq $boxRight)
}
function Get-BoxBlock ([int]$row,[int]$col) {
  if (Is-BoxLeft $row $col) {
    return @{Row = $row; LeftColumn = $col; RightColumn = (Get-ColumnAhead $row $col $right)}
  }
  return @{Row = $row; LeftColumn = (Get-ColumnAhead $row $col $left); RightColumn = $col}
}
function Is-Empty ([int]$row,[int]$col) {
  return ($map[$row][$col] -eq $empty)
}
function GPS-Coordinate([int]$row,[int]$col) {
  return 100 * $row + $col
}
function Can-MoveBox ([hashtable]$box,[string]$dir) {
  $pointsToCheck = @()
  if ($dir -ne $right) {
    $pointsToCheck += @{x = (Get-RowAhead $box.Row $box.LeftColumn $dir); y = (Get-ColumnAhead $box.Row $box.LeftColumn $dir)}
  }
  if ($dir -ne $left) {
    $pointsToCheck += @{x = (Get-RowAhead $box.Row $box.RightColumn $dir); y = (Get-ColumnAhead $box.Row $box.RightColumn $dir)}
  }
  foreach ($point in $pointsToCheck) {
    if (Is-Obstacle $point.x $point.y) {
      return $false
    }
    if (Is-Box $point.x $point.y) {
      if (-Not (Can-MoveBox (Get-BoxBlock $point.x $point.y) $dir)) {
        return $false
      }
    }
  }
  return $true
}
function Move-Box ([hashtable]$box,[string]$dir) {
  $boxesAhead = @{}
  if ($dir -ne $right) {
    $x = (Get-RowAhead $box.Row $box.LeftColumn $dir)
    $y = (Get-ColumnAhead $box.Row $box.LeftColumn $dir)
    if (Is-Box $x $y) {
      $boxAhead = (Get-BoxBlock $x $y)
      $boxesAhead["$($boxAhead.Row),$($boxAhead.LeftColumn),$($boxAhead.RightColumn)"] = $boxAhead
    }
  }
  if ($dir -ne $left) {
    $x = (Get-RowAhead $box.Row $box.RightColumn $dir)
    $y = (Get-ColumnAhead $box.Row $box.RightColumn $dir)
    if (Is-Box $x $y) {
      $boxAhead = (Get-BoxBlock $x $y)
      $boxesAhead["$($boxAhead.Row),$($boxAhead.LeftColumn),$($boxAhead.RightColumn)"] = $boxAhead
    }
  }
  $boxesAhead.Keys | ForEach-Object {
    Move-Box $boxesAhead[$_] $dir
  }
  $row = Get-RowAhead $box.Row $box.LeftColumn $dir
  $col = Get-ColumnAhead $box.Row $box.LeftColumn $dir
  $map[$row][$col] = $boxLeft
  $row = Get-RowAhead $box.Row $box.RightColumn $dir
  $col = Get-ColumnAhead $box.Row $box.RightColumn $dir
  $map[$row][$col] = $boxRight
  if ($dir -ne $left) {
    $map[$box.Row][$box.LeftColumn] = $empty
  }
  if ($dir -ne $right) {
    $map[$box.Row][$box.RightColumn] = $empty
  }
}

$currentRow = $initRow
$currentColumn = $initColumn
foreach ($dir in $moves) {
  #Write-Host $currentRow $currentColumn $dir
  $rowAhead = Get-RowAhead $currentRow $currentColumn $dir
  $columnAhead = Get-ColumnAhead $currentRow $currentColumn $dir
  if (Is-Obstacle $rowAhead $columnAhead) {
    continue
  }
  if (Is-Box $rowAhead $columnAhead) {
    $boxAhead = (Get-BoxBlock $rowAhead $columnAhead)
    if (Can-MoveBox $boxAhead $dir) {
      Move-Box $boxAhead $dir
    }
    else {
      continue
    }
  }
  $map[$currentRow][$currentColumn] = $empty
  $currentRow = $rowAhead
  $currentColumn = $columnAhead
  $map[$currentRow][$currentColumn] = $robot
  #Display-Map
}
$sum = 0
for ($row = 0; $row -lt $map.Length; $row++) {
  for ($column = 0; $column -lt $map[$row].Length; $column++) {
    if (Is-BoxLeft $row $column) {
      $sum += GPS-Coordinate $row $column
    }
  }
}
Write-Host $sum
# 2028
# 9021
# 1437981