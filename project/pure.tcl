set ns[new Simulator]

$ns rtproto DV
$ns macType Mac/Sat/UnslottedAloha

set nf[open pure_aloha.nam w]
$ns namtrace-all $nf

set f0[open pure_aloha.tr w]
$ns trace-all $f0

proc finish{} {
    global ns f0 nf
    $ns flush-trace

    close $fo
    close $nf

    exec nam pure_aloha.nam &
    exit 0
}

set n0[$ns node]
set n1[$ns node]
set n2[$ns node]
set n3[$ns node]
set n4[$ns node]
set n5[$ns node]

$ns duplex-link $n0 $n4 1Mb 50ms DropTail
$ns duplex-link $n1 $n4 1Mb 50ms DropTail
$ns duplex-link $n2 $n5 1Mb 50ms DropTail
$ns duplex-link $n4 $n5 1Mb 50ms DropTail
$ns duplex-link $n3 $n5 1Mb 50ms DropTail

$ns duplex-link-op $n4 $n5 queuePos 0.5

set upd0[new Agent/UPD]
$ns attach-agent $n0 $upd0

set cbr0[new Application/Traffic/CBR]
$cbr0 set packetSize_500
$cbr0 set interval_0.005
$cbr0 attach-agent $upd0

set null0[new agent/Null]
$ns attach-agent $n2 $null0

$ns connect $upd0 $null0

$ns at 0.5 "$cbr0 start"
$ns rtmodel-at 1.0 down $n5 $n2
$ns rtmodel-at 2.0 up $n5 $n2
$ns at 4.5 "$cbr0 stop"

$ns at 5.0 "finish"

$ns run
