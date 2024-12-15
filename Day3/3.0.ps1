
$f = Get-Content .\Day3\3.0.txt
function Get-Sum ([string]$s) {
  $sum = 0
  $pattern = [Regex]::new('mul\([+-]?\d{1,3},[+-]?\d{1,3}\)')
  $found = $pattern.Matches($s)
  foreach ($m in $found.Value) {
    $a, $b = $m.substring(4,$m.Length-5) -split ','
    Write-Host $a '*' $b
    $sum += ([int]$a*[int]$b)
  }
  return $sum
}

$total = 0
$currentString = $f -join ""
$disableIndex = $currentString.IndexOf("don't()")
while ($disableIndex -ge 0) {
  if ($disableIndex -ge 8) {
    $doString = $currentString.substring(0, $disableIndex)
    $total += Get-Sum $doString
    Write-Host 'counting' $doString
  }
  $currentString = $currentString.substring($disableIndex+7)
  $enableIndex = $currentString.IndexOf('do()')
  if ($enableIndex -ge 0) {
    $currentString = $currentString.substring($enableIndex)
  }
  else {
    $currentString = ""
  }
  $disableIndex = $currentString.IndexOf("don't()")
}
$total += Get-Sum $currentString

Write-Host $total
# 93465710