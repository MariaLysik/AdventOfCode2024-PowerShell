$DATA_INPUT = Get-Content .\Day22\22.txt
$ITERATIONS = 2000

function Get-ProgramOutput([long]$a) {
  $a = (($a -shl 6) -bxor $a) % 16777216
  $a = (($a -shr 5) -bxor $a) % 16777216
  $a = (($a -shl 11) -bxor $a) % 16777216
  return $a
}

[long] $sum = 0
foreach($number in $DATA_INPUT) {
  [long]$result = [long]$number
  for($i = 0; $i -lt $ITERATIONS; $i++) {
    $result = Get-ProgramOutput $result
  }
  #Write-Host $number ':' $result
  $sum += $result
}
Write-Host $sum