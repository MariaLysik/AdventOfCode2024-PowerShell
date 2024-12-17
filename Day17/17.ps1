$f = Get-Content .\Day17\17.txt

[int]$A = [Regex]::new('(\d+)').Matches($f[0]).Value
[int]$B = [Regex]::new('(\d+)').Matches($f[1]).Value
[int]$C = [Regex]::new('(\d+)').Matches($f[2]).Value
[int[]]$program = [Regex]::new('(\d+)').Matches($f[4]).Value

$output = @()
$pointer = 0
while ($pointer -lt $program.Count) {
  $opCode = $program[$pointer]
  $operand = $program[$pointer+1]
  if ($opCode -eq 3 -and $A -ne 0) {
    $pointer = $operand
  }
  else {
    $comboValue = $operand -eq 4 ? $A : $operand -eq 5 ? $B : $operand -eq 6 ? $C : $operand
    if ($opCode -eq 0) {
      $A = [Math]::Floor($A/[Math]::Pow(2,$comboValue))
    }
    elseif ($opCode -eq 1) {
      $B = $B -bxor $operand
    }
    elseif ($opCode -eq 2) {
      $B = $comboValue % 8
    }
    elseif ($opCode -eq 4) {
      $B = $B -bxor $C
    }
    elseif ($opCode -eq 5) {
      $output += ($comboValue % 8)
    }
    elseif ($opCode -eq 6) {
      $B = [Math]::Floor($A/[Math]::Pow(2,$comboValue))
    }
    elseif ($opCode -eq 7) {
      $C = [Math]::Floor($A/[Math]::Pow(2,$comboValue))
    }
    $pointer = $pointer +2
  }
}
Write-Host ($output -join ',')