$f = Get-Content .\Day11\11.txt

function Modify ([Long]$number, [Long]$blinksLeft) {
  if ($blinksLeft -lt 1) {
    return 1
  }
  if ($number -eq 0) {
    return (Modify 1 ($blinksLeft-1))
  }
  if ($splits[$number]) {
    return (Modify $splits[$number][0] ($blinksLeft-1)) + (Modify $splits[$number][1] ($blinksLeft-1))
  }
  $nofDigits = [Math]::Floor([Math]::Log10($number))+1
  if ($nofDigits%2 -eq 0) {
    $divider = [Math]::Pow(10,$nofDigits/2)
    $right = [Long] ($number % $divider)
    $left = [Long] (($number - $right) / $divider)
    $splits[$number] = @($left, $right)
    #Write-Host 'even number of digits' $number ':' $left $right
    return (Modify $left ($blinksLeft-1)) + (Modify $right ($blinksLeft-1))
  }
  return (Modify ($number*2024) ($blinksLeft-1))
}

$splits = @{} # global hashtable
$blinks = 25
$sum = 0
$f.Split() | ForEach-Object {
  $currentValue = [Long]::Parse($_)
  Write-Host 'value' $currentValue
  $sum += (Modify $currentValue $blinks)
  Write-Host $sum
}
Write-Host 'final' $sum
# avoid recurency! it uses up all memory! 
# try to do it with memorizing "$number:$blinks"=$result