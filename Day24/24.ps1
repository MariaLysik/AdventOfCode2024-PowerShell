$DATA_INPUT = Get-Content .\Day24\24.txt

function Compute([string]$operation,[string[]]$operands) {
  switch ($operation) {
    'AND' { return ($PROCESSED[$operands[0]] -band $PROCESSED[$operands[1]]) }
    'XOR' { return ($PROCESSED[$operands[0]] -bxor $PROCESSED[$operands[1]]) }
    'OR' { return ($PROCESSED[$operands[0]] -bor $PROCESSED[$operands[1]]) }
  }
}

$PROCESSED = @{} # value - true or false
$READY = @{} # value - number of operands processed
$TODO = @{} # op - AND|OR|XOR, operands - @()
$DEPENDENCY = @{} # input = @() of outputs

$i = 0
do {
  [string]$node, [int]$value = $DATA_INPUT[$i].Split(':')
  $PROCESSED[$node] = $value
  $i++
}
while($DATA_INPUT[$i])
$i++

while ($i -lt $DATA_INPUT.Count) {
  [string]$operand1, [string]$op, [string]$operand2, [string]$arrow, [string]$result  = $DATA_INPUT[$i].Split(' ')
  $TODO[$result] = @{ op = $op; operands = @($operand1, $operand2) }
  $DEPENDENCY[$operand1] += ,$result
  $DEPENDENCY[$operand2] += ,$result
  if ($null -ne $PROCESSED[$operand1]) {
    $READY[$result]++
  }
  if ($null -ne $PROCESSED[$operand2]) {
    $READY[$result]++
  }
  $i++
}

while ($TODO.Count -gt 0) {
  $READY.GetEnumerator() | Where-Object { $null -eq $PROCESSED[$_.Key] -and $_.Value -gt 1 } | ForEach-Object {
    $PROCESSED[$_.Key] = (Compute $TODO[$_.Key].op $TODO[$_.Key].operands)
    foreach($dep in $DEPENDENCY[$_.Key]) {
      $READY[$dep]++
    }
    $TODO.Remove($_.Key)
  }
}

$binaryResult = ''
$PROCESSED.GetEnumerator() | Where-Object { $_.Key.startsWith('z') } | Sort-Object Key -Descending | ForEach-Object {
  $binaryResult += $_.Value
}
[convert]::ToInt64($binaryResult,2)