$DATA_INPUT = Get-Content C:\Users\lysim\Projects\AdventOfCode2024-PowerShell\Day19\19.txt
[string[]]$patterns = $DATA_INPUT[0] -split ", "
$regexPattern = "^($($patterns -join '|'))*$"
$sum = 0
for ($i = 2; $i -lt $DATA_INPUT.Count; $i++) {
  if ($DATA_INPUT[$i] -match $regexPattern) {
  $sum++
  }
}
Write-Host $sum