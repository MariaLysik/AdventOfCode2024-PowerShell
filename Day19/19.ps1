$DATA_INPUT = Get-Content C:\Users\lysim\Projects\AdventOfCode2024-PowerShell\Day19\19.txt
[string[]]$PATTERNS = $DATA_INPUT[0] -split ", "
$REGEX_WITH_PATTERNS = "^($($PATTERNS -join '|'))*$"

function Count-WaysToBuildFromPatterns([string]$design) {
  $countUntil = New-Object long[] ($design.Length + 1)
  $countUntil[0] = 1 # only 1 way to build from pattern of the same length as design
	for ($i = 1; $i -le $design.Length; $i++) {
		foreach($pattern in $PATTERNS) {
			if ($i -ge $pattern.Length -and $design.substring($i-$pattern.Length,$pattern.Length) -eq $pattern) {
        # this fit times ways to build design so far
				$countUntil[$i] += $countUntil[$i-$pattern.Length]
			}
		}
	}
	return $countUntil[$design.Length]
}

$count = 0
[long]$sum = 0
for ($i = 2; $i -lt $DATA_INPUT.Count; $i++) {
  if ($DATA_INPUT[$i] -match $REGEX_WITH_PATTERNS) {
    $sum += Count-WaysToBuildFromPatterns $DATA_INPUT[$i]
    $count++
  }
}
Write-Host 'PART 1:' $count
Write-Host 'PART 2:' $sum