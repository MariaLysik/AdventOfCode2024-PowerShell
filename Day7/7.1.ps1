$f = Get-Content .\Day7\7.txt

function Concatenate ([Long]$x,[Long]$y) {
  return [Math]::Pow(10, "${y}".Length) * $x + $y
}

function Found-Function ([Long]$res, [Long[]]$numbers) {
  if ($numbers.Length -lt 2) {
    return ($numbers[0] -eq $res)
  }
  if ($numbers[0] -gt $res) {
    return $false
  }
  $add = ($numbers[0] + $numbers[1]) 
  $multiply = ($numbers[0] * $numbers[1])
  $concat = (Concatenate $numbers[0] $numbers[1])
  if ($numbers.Length -eq 2) {
    return (($add -eq $res) -or ($multiply -eq $res) -or ($concat -eq $res))
  }
  $lefover = $numbers[2..($numbers.Length-1)]
  return ((Found-Function $res (@($add)+$lefover)) -or (Found-Function $res (@($multiply)+$lefover)) -or (Found-Function $res (@($concat)+$lefover)))
}

$sum = 0
foreach ($row in $f) {
  $resultStr, $restStr = $row.Split(':')
  $result = [Long]$resultStr
  $arrStr = $restStr.Trim().Split()
  $arr = $arrStr | % {[Long]$_}
  if (Found-Function $result $arr) {
    Write-Host 'found' $result ':' $arr
    $sum += $result
  }
}
Write-Host $sum