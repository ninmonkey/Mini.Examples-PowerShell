# requires Ninmonkey.Console for parts

Label 'SetType Goup By'
$disc = [ordered]@{}
$allSets ??= Get-Counter -ListSet * # slow
$singleSets = $allSets | Where-Object CounterSetType -EQ SingleInstance
$multiSets = $allSets | Where-Object CounterSetType -EQ MultiInstance


$disc.CounterSetType = $allSets.CounterSetType | Sort-Object -Unique
$disc.MachineName = $allSets.MachineName | Sort-Object -Unique
$disc.Single_SetName = $singleSets.CounterSetName | Sort-Object -Unique
$disc.Multi_SetName = $MultiSets.CounterSetName | Sort-Object -Unique
$disc.All_SetName = $allSets.CounterSetName | Sort-Object -Unique
$Target = @{}

$Include_SetList = @{}
$Include_SetList.Network = 'Bluetooth Device', 'Bluetooth Radio', 'Client Side Caching', 'Distributed Routing Table', 'Event Log', 'Event Tracing for Windows', 'Event Tracing for Windows Session', 'HTTP Service', 'HTTP Service Request Queues', 'HTTP Service Url Groups', 'IPHTTPS Global', 'IPHTTPS Session', 'IPsec AuthIP IPv4', 'IPsec AuthIP IPv6', 'IPsec Connections', 'IPsec Driver', 'IPsec IKEv1 IPv4', 'IPsec IKEv1 IPv6', 'IPsec IKEv2 IPv4', 'IPsec IKEv2 IPv6', 'Network QoS Policy', 'Node.js', 'PacketDirect EC Utilization', 'PacketDirect Queue Depth', 'PacketDirect Receive Counters', 'PacketDirect Receive Filters', 'PacketDirect Transmit Counters', 'Peer Name Resolution Protocol', 'Per Processor Network Activity Cycles', 'Per Processor Network Interface Card Activity', 'Physical Network Interface Card Activity', 'SMB Client Shares', 'SMB Server', 'SMB Server Sessions', 'SMB Server Shares', 'TCPIP Performance Diagnostics', 'TCPIP Performance Diagnostics (Per-CPU)', 'Terminal Services', 'WFP', 'WFP Classify', 'WFP Reauthorization', 'WFPv4', 'WFPv6', 'Windows Time Service', 'WinNAT', 'WinNAT ICMP', 'WinNAT Instance', 'WinNAT TCP', 'WinNAT UDP'


$Target.Network = $allSets | Where-Object {
    $re = @(
        'web'
        'TCPIP'
        'network'
        # '(?-i)RAM(?i)'

    ) | Join-String -sep '|' { "($_)" }
    # ($_.CounterSetName -Match $re) -or
    # ($_.Paths -Match $re)

    ($_.CounterSetName -Match $re) -or
    ($_.Paths -Match $re)
}
$Target.EventTrace = $allSets | Where-Object {
    $re = @(
        'Event'
        'Event Log'
        'Event Tracing for Windows'
        'etw'
        'trace'
        # '(?-i)RAM(?i)'

    ) | Join-String -sep '|' { "($_)" }
    ($_.CounterSetName -Match $re) -or
    ($_.Paths -Match $re)
}

$Target.Memory = $allSets | Where-Object {
    $re = @(
        'memory'
        'usage'
        'share'
        '(?-i)SMB(?i)'

        'ram'
        '(?-i)RAM(?i)'
        'pages?'
    ) | Join-String -sep '|' { "($_)" }

    # Write-Host $re -ForegroundColor red
    ($_.Paths -match $re) -or
    ($_.CounterSetName -match $re)
}
$Target.WithInstances = $allSets | Where-Object { $_.PathsWithInstances } # Format-Table CounterSetName, PathsWithInstances


'---- summary ----'
$summary = [pscustomobject]$disc
$summary | Format-List
$summary | Format-Table -AutoSize
'---- Targets ----'
$target | Format-Table


'---- Memory ----'
$Target.Memory | Format-Table
$Target.EventTrace | Format-Table
$Target.Network | Format-Table

# $chooseSome = $disc.All_SetName | fzf -m
if ($False -and 'Expand all paths' ) {
    $FormatEnumerationLimit = -1
    $allSets | Select-Object CounterSetName, Counter, Paths | Format-List | less
    $FormatEnumerationLimit = 4
}
