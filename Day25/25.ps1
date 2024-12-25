$DATA_INPUT = Get-Content .\Day25\25.txt

$LOCKS = @{}
$KEYS = @{}
$PAIRS = @{}

$i = 0
while ($i -lt $DATA_INPUT.Length) {
  $shape = @(0,0,0,0,0)
  for ($j = $i + 1; $j -le $i + 5; $j++) {
    for ($k = 0; $k -lt 5; $k++) {
      if ($DATA_INPUT[$j][$k] -eq '#') {
        $shape[$k]++
      }
    }
  }
  switch ($DATA_INPUT[$i]) {
    '#####' { $LOCKS[($shape -join ',')] = $shape }
    '.....' { $KEYS[($shape -join ',')] = $shape }
  }
  $i = $i + 8
}

foreach($lock in $LOCKS.GetEnumerator()) {
  foreach($key in $KEYS.GetEnumerator()) {
    $fit = $true
    for ($k = 0; $k -lt 5; $k++) {
      if ($lock.Value[$k] + $key.Value[$k] -gt 5) {
        $fit = $false
        break
      }
    }
    if ($fit) {
      $PAIRS[$lock.Key + ':' + $key.Key] = $true
    }
  }
}

$PAIRS.Count