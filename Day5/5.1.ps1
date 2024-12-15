#$f = Get-Content .\Day5\5.test.txt
$f = Get-Content .\Day5\5.txt

function Is-InRightOrder ([string[]]$pages) {
  for ($i = 0; $i -lt $pages.Length-1; $i++) {
    for ($j = $i+1; $j -lt $pages.Length; $j++) {
      if ($order[$pages[$i]][$pages[$j]] -eq 'after') {
        return $false
      }
    }
  }
  return $true
}

$order = @{}
$corruptedUpdates = @()
foreach ($line in $f) {
  if ($line -and $line.Contains('|')) {
    $a, $b = $line.Split('|')
    if ($null -eq $order[$a]) {
      $order[$a] = @{}
    }
    if ($null -eq $order[$b]) {
      $order[$b] = @{}
    }
    $order[$a][$b] = 'before'
    $order[$b][$a] = 'after'
  }
  elseif ($line) {
    $update = $line.Split(',')
    if (-Not (Is-InRightOrder $update)) {
      $corruptedUpdates += , $update
    }
  }
}
$order.GetEnumerator() | ? { Write-Host $_.Key ':' $_.Value }

function Get-MiddleValue ([string[]]$pages) {
  return [int]$pages[[int] [Math]::Truncate($pages.Length / 2)]
}

function Correct-Order ([string[]]$pages) {
  if ($pages.Length -le 1) {
    return $pages
  }
  $before = @()
  $after = @()
  for ($i = 1; $i -lt $pages.Length; $i++) {
    if ($order[$pages[0]][$pages[$i]] -eq 'after') {
      $before += $pages[$i]
    }
    else {
      $after += $pages[$i]
    }
  }
  return @(Correct-Order $before) + @($pages[0]) + @(Correct-Order $after)
}

$sum = 0
foreach ($update in $corruptedUpdates) {
  Write-Host $update
  $update = Correct-Order $update
  Write-Host 'corrected:' $update
  $middleVal = Get-MiddleValue $update
  Write-Host $middleVal
  $sum += $middleVal
}

Write-Host $sum
# test 123