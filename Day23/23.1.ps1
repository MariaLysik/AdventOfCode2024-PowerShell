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

$CLIQUES = @{}
function Find-Cliques {

  param(
    [string[]]$remainingNodes,
    [string[]]$potentialClique = @(),
    [string[]]$skipNodes = @(),
    [int] $depth = 0
  )

  #Write-Host $depth 'potentialClique:' $potentialClique
  #Write-Host $depth 'remainingNodes:' $remainingNodes
  #Write-Host $depth 'skipNodes:' $skipNodes

  if ($remainingNodes.Count -eq 0 -and $skipNodes.Count -eq 0) {
    $key = (($potentialClique | Sort-Object) -join ',')
    #Write-Host 'This is a clique:' $key
    $CLIQUES[$key] = $potentialClique.Count
    return
  }
  foreach ($node in $remainingNodes) {
    $newPotentialClique = $potentialClique + $node
    $newRemainingNodes = $remainingNodes | Where-Object { $_ -and $NETWORK_GRAPH[$node].Keys -contains $_ }
    $newSkipNodes = $skipNodes | Where-Object {$_ -and $NETWORK_GRAPH[$node].Keys -contains $_ }
    Find-Cliques $newRemainingNodes $newPotentialClique $newSkipNodes ($depth+1)
    $remainingNodes = $remainingNodes | Where-Object {$_ -ne $node}
    $skipNodes += $node
  }
}

#Find Largest Complete Subgraph
[System.Collections.Generic.HashSet[string]] $allNodes = [string[]]$NETWORK_GRAPH.Keys
Find-Cliques $allNodes
$result = $CLIQUES.GetEnumerator() | Sort-Object -property:Value -Descending | Select-Object -first 1
Write-Host $result.Key $result.Value