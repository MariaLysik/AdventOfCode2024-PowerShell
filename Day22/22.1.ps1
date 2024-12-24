$DATA_INPUT = Get-Content .\Day22\22.txt
$ITERATIONS = 2000

function Get-ProgramOutput([long]$a) {
  $a = (($a -shl 6) -bxor $a) % 16777216 # Pow(2,24), gets only last 24 bits
  $a = (($a -shr 5) -bxor $a) % 16777216
  $a = (($a -shl 11) -bxor $a) % 16777216
  return $a
}

$CACHE = @{} # [SEQUENCE][BUYER] = MAX # I was wrong, it was never about the max, but FIRST ocurrence!
$SEQUENCE_FRAME = 4
[long] $sum = 0
$buyer = 0
foreach($number in $DATA_INPUT) {
  [long]$result = [long]$number
  $sequence = @()
  [int]$previousDigit = $result % 10 
  for($i = 0; $i -lt $SEQUENCE_FRAME; $i++) {
    $result = Get-ProgramOutput $result
    $currentDigit = $result % 10
    $sequence += ($currentDigit - $previousDigit)
    $previousDigit = $currentDigit
  }
  if ($null -eq $CACHE[($sequence -join ',')]) {
    $CACHE[($sequence -join ',')] = @{}
  }
  $CACHE[($sequence -join ',')][$buyer] = $currentDigit
  for($i = $SEQUENCE_FRAME; $i -lt $ITERATIONS; $i++) {
    $result = Get-ProgramOutput $result
    $currentDigit = $result % 10
    $currentDifference = $currentDigit - $previousDigit
    $sequence = $sequence[1..($sequence.Length-1)] + $currentDifference
    $currentSequenceKey = ($sequence -join ',')
    if ($null -eq $CACHE[$currentSequenceKey]) {
      $CACHE[$currentSequenceKey] = @{}
    }
    if ($null -eq $CACHE[$currentSequenceKey][$buyer]) {
      $CACHE[$currentSequenceKey][$buyer] = $currentDigit
    }
    $previousDigit = $currentDigit
  }
  #Write-Host $number ':' $result
  $sum += $result
  $buyer++
}
Write-Host $sum

$maxDeal = 0
foreach ($sequence in $CACHE.GetEnumerator()) {
  $deal = 0
  foreach ($buyer in $sequence.Value.GetEnumerator()) {
    $deal += $buyer.Value
  }
  if ($deal -gt $maxDeal) {
    Write-Host 'Better deal' $deal 'for' $sequence.Key $sequence.Value
    $maxDeal = $deal
  }
}
Write-Host $maxDeal

# 2362