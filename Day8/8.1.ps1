$f = Get-Content .\Day8\8.txt

$antennas = @{}

class Point {
  [int]$x
  [int]$y
  Point([int]$x,[int]$y) {
    $this.x = $x
    $this.y = $y
  }
  [Point] Add ([Point]$p) {
    return [Point]::new($this.x+$p.x,$this.y+$p.y)
  }
  [string] ToString() {
    return "($($this.x),$($this.y))"
  }
  [bool] InBounds ([int]$maxX,[int]$maxY) {
    return ($this.x -ge 0 -and $this.y -ge 0 -and $this.x -lt $maxX -and $this.y -lt $maxY)
  }
}

for ($row = 0; $row -lt $f.Length; $row++) {
  for ($column = 0; $column -lt $f[$row].Length; $column++) {
    if ($f[$row][$column] -ne '.') {
      $antennas[$f[$row][$column]] += , [Point]::new($row,$column)
    }
  }
}

$antennas.keys | ForEach-Object {
  Write-Output $_
  foreach ($antenna in $antennas[$_]) {
    Write-Host $antenna.ToString()
  }
}

$antinodes = @{}
$antennas.keys | ForEach-Object {
  Write-Output $_
  for ($i = 0; $i -lt $antennas[$_].Length-1; $i++) {
    for ($j = $i+1; $j -lt $antennas[$_].Length; $j++) {
      $a = $antennas[$_][$i]
      $b = $antennas[$_][$j]
      Write-Host 'pair' $a.ToString() $b.ToString()
      $vector = [Point]::new($a.x-$b.x,$a.y-$b.y)
      $currentAntinode = $a
      while ($currentAntinode.InBounds($f.Length,$f[0].Length)) {
        $antinodes[$currentAntinode.ToString()] = , $_
        $currentAntinode = $currentAntinode.Add($vector)
      }
      $vector = [Point]::new($b.x-$a.x,$b.y-$a.y)
      $currentAntinode = $b
      while ($currentAntinode.InBounds($f.Length,$f[0].Length)) {
        $antinodes[$currentAntinode.ToString()] = , $_
        $currentAntinode = $currentAntinode.Add($vector)
      }
    }
  }
}
Write-Host $antinodes.keys
Write-Host $antinodes.keys.Count