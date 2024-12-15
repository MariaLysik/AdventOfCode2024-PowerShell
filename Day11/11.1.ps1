$f = Get-Content .\Day11\11.txt

function Blink ([hashtable]$stones) {
  $newStones = @{}
  if ($stones[0]) {
    $newStones[1] += $stones[0]
    $stones.Remove(0)
  }
  $stones.GetEnumerator() | ForEach-Object {
    if ($splits[$_.Key]) {
      $newStones[($splits[$_.Key])[0]] += $_.Value
      $newStones[($splits[$_.Key])[1]] += $_.Value
    }
    elseif (($nofDigits = [Math]::Floor([Math]::Log10($_.Key))+1) % 2 -eq 0) {
      $left = [int]$_.Key.toString().substring(0,$nofDigits/2)
      $right = [int]$_.Key.toString().substring($nofDigits/2)
      $newStones[$left] += $_.Value
      $newStones[$right] += $_.Value
      $splits[$_.Key] = @($left, $right)
    }
    else {
      $newStones[$_.Key * 2024] += $_.Value
    }
  }
  return $newStones
}

Measure-Command {
$splits = @{} # global hashtable
$stones = @{}
$f.Split() | ForEach-Object {
  $stones[[int]::Parse($_)] += 1
}
$blinks = 75
for ($blink = 1; $blink -le $blinks; $blink++) {
  $stones = (Blink $stones)
}
Write-Host ($stones.Values | Measure-Object -Sum).Sum
}
# after 25 - 55312
# after 6 - 22
# after 25 - real 199986
# after 75 - ?