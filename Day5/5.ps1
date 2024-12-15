$f = Get-Content .\Day5\5.txt

$after = @{}
$sum = 0

function Is-InRightOrder ([string[]]$pages) {
  if ($pages.Length -eq 1) {
    return $true
  }
  $order = @{}
  for ($i = 0; $i -lt $pages.Length; $i++) {
    foreach ($page in $after[$pages[$i]]) {
      if ($null -ne $order[$page]) {
        return $false
      }
    }
    $order[$pages[$i]] = $i
  }
  return $true
}

function Get-MiddleValue ([string[]]$pages) {
  return [int]$pages[[int] [Math]::Truncate($pages.Length / 2)]
}

foreach ($line in $f) {
  if ($line -and $line.Contains('|')) {
    $a, $b = $line.Split('|')
    $after[$a] = $after[$a] ? $after[$a] + $b : @($b)
  }
  elseif ($line) {
    $update = $line.Split(',')
    Write-Host $update
    if (Is-InRightOrder $update) {
      $middleVal = Get-MiddleValue $update
      Write-Host $middleVal
      $sum += $middleVal
    }
  }
}

Write-Host $sum
# test 143
#Write-Host ($after.Keys.ForEach({"$_ : $($after.$_)"}) -join ' | ')