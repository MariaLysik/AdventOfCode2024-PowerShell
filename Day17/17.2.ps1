$f = Get-Content .\Day17\17.txt
[int[]]$program = [Regex]::new('(\d+)').Matches($f[4]).Value

function Execute([long]$a) {
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
      $tempOut = Execute $tempA
      if ($tempOut -eq $program[$i]) {
        #Write-Host $tempA $tempOut
        $results[$i] += ,$tempA
      }
    }
  }
}
$A = $results[0] | Sort-Object | Select-Object -First 1
Write-Host $A