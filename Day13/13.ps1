$f = Get-Content .\Day13\13.txt

$totalCost = 0
for ($line = 0; $line -lt $f.Length; $line = $line + 4) {
  $ax, $ay = [Regex]::new('(\d+)').Matches($f[$line]).Value
  $bx, $by = [Regex]::new('(\d+)').Matches($f[$line+1]).Value
  $px, $py = [Regex]::new('(\d+)').Matches($f[$line+2]).Value
  Write-Host $ax $ay '|' $bx $by '->' $px $py

  $cost = @{}
  $i = 1
  while ($i -le 100) {
    $cost["$($i*$ax),$($i*$ay)"] = $i*3
    $cost["$($i*$bx),$($i*$by)"] = $i
    $i++
  }

  $minimalCost = 0
  $cost.Keys | ForEach-Object {
    $dx, $dy = $_.Split(',')
    if ($cost["$($px-$dx),$($py-$dy)"]) {
      $currentCost = $cost[$_] + $cost["$($px-$dx),$($py-$dy)"]
      if ($minimalCost -eq 0 -or $minimalCost -gt $currentCost) {
        $minimalCost = $currentCost
      }
    }
  }
  if ($minimalCost -ne 0) {
    $totalCost += $minimalCost
  }
  Write-Host 'minimal cost for' $px $py 'is' $minimalCost
}
Write-Host $totalCost