$DATA_INPUT = Get-Content .\Day23\23.txt
$NETWORK_GRAPH = @{}
foreach($pair in $DATA_INPUT) {
  $left, $right = $pair.Split('-')
  if ($null -eq $NETWORK_GRAPH[$left]) {
    $NETWORK_GRAPH[$left] = @{}
  }
  $NETWORK_GRAPH[$left][$right] = $true
  if ($null -eq $NETWORK_GRAPH[$right]) {
    $NETWORK_GRAPH[$right] = @{}
  }
  $NETWORK_GRAPH[$right][$left] = $true
}

$LAN_PARTY = @{}
foreach ($node in $NETWORK_GRAPH.GetEnumerator()) {
  for ($i = 0; $i -lt $node.Value.Count -1; $i++) {
    for ($j = $i + 1; $j -lt $node.Value.Count; $j++) {
      if($NETWORK_GRAPH[([string[]] $node.Value.Keys)[$i]][([string[]] $node.Value.Keys)[$j]]) {
        $party = @($node.Key,([string[]] $node.Value.Keys)[$i],([string[]] $node.Value.Keys)[$j])
        if ($party | Where-Object {$_.StartsWith('t')}) {
          $LAN_PARTY[(($party | Sort-Object) -join ',')] = $true
        }
      }
    }
  }
}
Write-Host $LAN_PARTY.Count