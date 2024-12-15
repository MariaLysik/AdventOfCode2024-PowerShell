$f = Get-Content .\Day9\9.txt

#Write-Host $f
$holes = @{}
$fileSystem = @()
$i = 0
$empty = $false
$currentIndex = 0
while ($i -lt $f.Length) {
  $size = [System.Int32]::Parse($f[$i].ToString())
  $val = $empty ? 0 : $i/2
  if ($empty -and $size -gt 0) {
    $holes[$size] += ,$currentIndex
  }
  while ($size -gt 0) {
    $fileSystem += $val
    $currentIndex++
    $size--
  }
  $empty = -not $empty
  $i++
}
#Write-Host $fileSystem

$i = $fileSystem.Length-1
$minIndex = [System.Int32]::Parse($f[0].ToString())
$maxVal = $fileSystem[$i]+1
while ($i -ge $minIndex) {
  $val = $fileSystem[$i]
  $size = 0
  while($fileSystem[$i] -eq $val -and $i -ge $minIndex) {
    $i--
    $size++
  }
  if ($val -ne 0 -and $val -lt $maxVal) {
    $maxVal = $val
    #Write-Host 'handling' $val 'of size' $size 'min index' $minIndex
    $k = -1
    $index = -1
    $holes.GetEnumerator() | Where-Object { $_.Key -ge $size } | ForEach-Object {
      if ($index -eq -1 -or $index -gt $_.Value[0]) {
        $k = $_.Key
        $index = $_.Value[0]
      }
    }
    if ($index -ne -1 -and $index -le $i) {
      #Write-Host 'finding a proper hole for size' $size 'and val' $val 'at index' $index '(' $k ')'
      for ($j = $index; $j -lt $index + $size; $j++) {
        #Write-Host 'overriding' $fileSystem[$j] 'with val' $val 'at index' $j
        $fileSystem[$j] = $val
      }
      for ($j = $i + $size; $j -gt $i; $j--) {
        #Write-Host 'overriding' $fileSystem[$j] 'with 0 at index' $j
        $fileSystem[$j] = 0
      }
      if ($index -eq $minIndex) {
        $minIndex += $size
      }
      if ($holes[$k].Count -lt 2) {
        $holes.Remove($k)
        #Write-Host 'removed' $k 'from' $holes
      }
      else {
        $holes[$k] = $holes[$k][1..($holes[$k].Count-1)]
      }
      if ($k -gt $size) {
        $newSize = $k-$size
        $newIndex = $index+$size
        $holes[$newSize] += ,$newIndex
        $holes[$newSize] = $holes[$newSize] | Sort-Object
        #Write-Host 'new entry to' $newSize ':' $holes[$newSize]
      }
    }
    else {
      #Write-Host 'size' $size 'of val' $val 'is too big to fit'
    }
  }
}
#Write-Host $fileSystem

$checksum = 0
for ($i = 0; $i -lt $fileSystem.Count; $i++) {
  $checksum += $fileSystem[$i] * $i
}
Write-Host $checksum
# 6389911791746