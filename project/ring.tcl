set ns[new Simulator]

$ns color 1 Red 

set nf[open out.nam w]
$ns namtrace-all $nf

proc finish{} {
    global ns nf
    $ns flush-trace

    close $nf

    exec nam out.nam &
    exit0
}

set n0[$ns node]
set n1[$ns node]
set n2[$ns node]
set n3[$ns node]
set n4[$ns node]
set n5[$ns node]
set n6[$ns node]

$ns duplex-link $n0 $n1 1Mb 10ms DropTail
$ns duplex-link $n1 $n2 1Mb 10ms DropTail
$ns duplex-link $n2 $n3 1Mb 10ms DropTail
$ns duplex-link $n3 $n4 1Mb 10ms DropTail
$ns duplex-link $n4 $n5 1Mb 10ms DropTail
$ns duplex-link $n5 $n6 1Mb 10ms DropTail
$ns duplex-link $n6 $n0 1Mb 10ms DropTail

$ns duplex-link-op $n0 $n1 orient left
$ns duplex-link-op $n1 $n2 orient left
$ns duplex-link-op $n2 $n3 orient left-down
$ns duplex-link-op $n3 $n4 orient down
$ns duplex-link-op $n4 $n5 orient right
$ns duplex-link-op $n5 $n6 orient right
$ns duplex-link-op $n6 $n0 orient right-up


set tcp0[new Agent/TCP]
$ns set class_1
$ns attach-agent $n1 $tcp0

set sink0[new Agent/TCPSink]
$ns attach-agent $n4 $sink0

set cbr0[new Application/Traffic/CBR]
$cbr0 set packetSize_500
$cbr0 set interval_0.1
$cbr0 attach-agent $tcp0

$ns coonect $tcp0 $sink0

$ns at 0.5 "$cbr0 start"
$ns at 4.5 "$cbr0 stop"

$ns at 5.0 "finish"

$ns run


set ns 


#bus

set ns[new Simulator]
 $ns color 1 Blue

set nf[open out1.nam w]
$ns namtrace-all $nf

proc finish{} {
    global ns nf
    $ns flush-trace

    close $nf

    exec nam out1.nam &
    exit0
}

set n0[$ns node]
set n1[$ns node]
set n2[$ns node]
set n3[$ns node]
set n4[$ns node]
set n5[$ns node]


set lan0[$ns newLan "$n0 $n1 $n2 $n3 $n4 $n5" 0.5Mb 40ms LL Queue/DropTail MAC/Csma/Cd Channel]


set tcp0[new Agent/TCP]
$ns set class_1
$ns attach-agent $n1 $tcp0

set sink0[new Agent/TCPSink]
$ns attach-agent $n4 $sink0

$ns connect $tcp0 $sink0

set cbr0[new Application/Traffic/CBR]
$cbr0 set packetSize_500
$cbr0 set interval_0.01
$cbr attach-agent $tcp0

$ns at 0.5 "$cbr0 start"
$ns at 4.5 "$cbr0 stop"

$ns at 5.0 "finish"

$ns run





