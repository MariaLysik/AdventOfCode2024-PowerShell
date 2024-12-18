[int[]]$program = @(2,4,1,1,7,5,1,5,0,3,4,4,5,5,3,0)

function Get-ProgramOutput([long]$a) {
  $b = $a % 8
  $b = $b -bxor 1
  $c = $a -shr $b
  $b = $b -bxor 5
  $b = $b -bxor $c
  return ($b % 8)
}

$results = @{$program.Count=@(0)}
for ($i = $program.Count-1; $i -ge 0; $i--) {
  for($j = 0; $j -lt 8; $j++) {
    foreach ($possibleA in $results[$i+1]) {
      [long]$tempA = $possibleA * 8 + $j
      $tempOut = Get-ProgramOutput $tempA
      if ($tempOut -eq $program[$i]) {
        #Write-Host $tempA $tempOut
        $results[$i] += ,$tempA
      }
    }
  }
}
$A = $results[0] | Sort-Object | Select-Object -First 1
Write-Host $A