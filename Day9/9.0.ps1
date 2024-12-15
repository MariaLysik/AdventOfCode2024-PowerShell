$f = Get-Content .\Day9\9.txt

$j = $f.Length-1
if ($j % 2 -eq 1) {
  $j--
}
$repeatJ = [System.Int32]::Parse($f[$j].ToString())
$index = 0
$checksum = 0
for ($i = 0; $i -lt $j; $i = $i+2) {
  $repeatI = [System.Int32]::Parse($f[$i].ToString())
  $repeatEmpty = [System.Int32]::Parse($f[$i+1].ToString())
  while ($repeatI -gt 0) {
    $checksum += $i/2*$index
    $index++
    $repeatI--
  }
  while ($repeatEmpty -gt 0) {
    if ($repeatJ -gt 0) {
      $checksum += $j/2*$index
      $index++
      $repeatEmpty--
      $repeatJ--
    }
    else {
      $j = $j-2
      $repeatJ = [System.Int32]::Parse($f[$j].ToString())
    }
  }
}
while ($repeatJ -gt 0) {
  $checksum += $j/2*$index
  $index++
  $repeatJ--
}
Write-Host $checksum