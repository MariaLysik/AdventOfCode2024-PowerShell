$f = Get-Content .\Day13\13.txt

[Int64]$totalCost = 0
for ($line = 0; $line -lt $f.Length; $line = $line + 4) {
  [Int64]$ax, [Int64]$ay = [Regex]::new('(\d+)').Matches($f[$line]).Value
  [Int64]$bx, [Int64]$by = [Regex]::new('(\d+)').Matches($f[$line+1]).Value
  [Int64]$px, [Int64]$py = [Regex]::new('(\d+)').Matches($f[$line+2]).Value
  [Int64]$px += 10000000000000
  [Int64]$py += 10000000000000
  #Write-Host $ax $ay '|' $bx $by '->' $px $py

  [double]$A = ($py*$bx - $px*$by)/($bx*$ay -$by*$ax)
  if ($A -ge 0 -and $A -eq [Math]::Floor($A)) {
    $B = ($px-$A*$ax)/$bx
    $totalCost += (3*$A + $B)
  }
}
Write-Host $totalCost
# 101406661266314