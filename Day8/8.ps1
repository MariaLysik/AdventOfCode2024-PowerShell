$f = Get-Content .\Day8\8.txt

$antennas = @{}

class Point {
  [int]$x
  [int]$y
  Point([int]$x,[int]$y) {
    $this.x = $x
    $this.y = $y
  }
  [Point] Antinode ([Point]$p) {
    return [Point]::new(2*$this.x-$p.x,2*$this.y-$p.y)
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
      Write-Host 'pair' $antennas[$_][$i].ToString() $antennas[$_][$j].ToString()
      foreach ($antinode in $antennas[$_][$i].Antinode($antennas[$_][$j]), $antennas[$_][$j].Antinode($antennas[$_][$i])) {
        if ($antinode.InBounds($f.Length,$f[0].Length)) {
          $antinodes[$antinode.ToString()] = , $_
        }
      }
    }
  }
}
Write-Host $antinodes.keys
Write-Host $antinodes.keys.Count