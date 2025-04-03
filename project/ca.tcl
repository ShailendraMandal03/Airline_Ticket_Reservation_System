proc finish{} {
    global ns f0 nf
    $ns flush-trace

    close $fo
    close $nf

    exec xgraph f0.tr,f1.tr,f2.tr &
    exec nam csma_ca.nam &
    exit0
}

set val(chan) Channel/WirelessChannel
set val(iqtype) Queue/DropTail/PriQueue
set val(mac) Mac/802_11
set val(netif) Phy/WirelessPhy
set val(X) 500
set val(Y) 500
set val(ifqlen) 100
set val(nn) 5

set val(rp) AODV
set val(ll) LL
set val(ant) Antenna/OmniAntenna
set val(prop) Propagation/TwoRayGround

set ns[new Simulator]

$ns color 1 Red

set nf[open csma_ca.nam w]
$ns namtrace-all-wireless $nf $val(X) $val(Y)

set f0[open csma_ca.tr w]
$ns tarce-all $f0

set topo[new Topography]
$topo load_flatgrid $val(X) $val(Y)

create-god $val(nn)

$ns node-config-adhocRouting $val(rp)-channelType $val(chan)-llType $val(ll)-macType $val(mac)-antType $val(ant)-ifqLen $val(iqtype)-propType $val(prop)-ifqType $val(iqtype)-phyType $val(netif)-topoInstance $topo-agentTrace ON - routerTrace ON -macTrace ON - movementTrace ON


# $val(ll) -macType $val(mac) -ifqLen $val(ifqlen) -antType $val(ant) -ifqType $val(iqtype)-phyType $val(netif) -topoInstance $topo -agentTrace ON -routerTrace ON -macTrace ON-movementTrace ON


set n0[$ns node]
$n0 set X_300
$n0 set Y_900

set n1[$ns node]
$n1 set X_200
$n1 set Y_750

set n2[$ns node]
$n2 set X_300
$n2 set Y_600

set n3 [$ns node]
$n3 set X_ 300
$n3 set Y_ 750

set n4 [$ns node]
$n4 set X_ 300
$n4 set Y_ 450

$ns at [expr 15 +round(rand()*60)]"$n0 setdest[expr 10+round(rand()*480)][expr 10+round(rand()*380)][expr 2+round(rand()*15)]"
$ns at [expr 15 +round(rand()*60)]"$n1 setdest[expr 10+round(rand()*480)][expr 10+round(rand()*380)][expr 2+round(rand()*15)]"
$ns at [expr 15 +round(rand()*60)]"$n2 setdest[expr 10+round(rand()*480)][expr 10+round(rand()*380)][expr 2+round(rand()*15)]"
$ns at [expr 15 +round(rand()*60)]"$n3 setdest[expr 10+round(rand()*480)][expr 10+round(rand()*380)][expr 2+round(rand()*15)]"
$ns at [expr 15 +round(rand()*60)]"$n4 setdest[expr 10+round(rand()*480)][expr 10+round(rand()*380)][expr 2+round(rand()*15)]"

$n0 random-motion 1
$n1 random-motion 1
$n2 random-motion 1
$n3 random-motion 1
$n4 random-motion 1

set tcp0[new Agent/TCP]
set tcp1[new Agent/TCP]
set tcp2[new Agent/TCP]
set tcp3[new Agent/TCP]

set sink0[new Agent/TCPSink]
set sink1[new Agent/TCPSink]
set sink2[new Agent/TCPSink]
set sink3[new Agent/TCPSink]

$ns attach-agent $n0 $tcp0
$ns attach-agent $n3 $sink0

$ns attach-agent $n1 $tcp1
$ns attach-agent $n3 $sink1

$ns attach-agent $n2 $tcp2
$ns attach-agent $n3 $sink2

$ns attach-agent $n4 $tcp3
$ns attach-agent $n3 $sink3

$ns coonect $tcp0 $sink0
$ns coonect $tcp1 $sink1
$ns coonect $tcp2 $sink2
$ns coonect $tcp3 $sink3

set ftp0[new Application/FTP]
$ns attach-agent $tcp0

set ftp1[new Application/FTP]
$ns attach-agent $tcp1

set ftp2[new Application/FTP]
$ns attach-agent $tcp2

set ftp3[new Application/FTP]
$ns attach-agent $tcp3

set f0[open f0.tr w]
set f1[open f1.tr w]
set f2[open f2.tr w]

set hr1 0
set hr2 0
set hr3 0

proc record {} {
    global sink0 sink1 sink2 f0 f1 f2 hr1 hr2 hr3
    set ns [Simulator instance]
    set time 0.9
    set bw0 [$sink set bytes_]
    set bw1 [$sink1 set bytes_]
    set bw2 [$sink2 set bytes_]
    set now [$ns now]
    # Record the Bit Rate in Trace Files
    puts $f0 "$now [expr (($bw0+$hr1)*8)/(2*$time*1000000)]"
    puts $f1 "$now [expr (($bw1+$hr2)*8)/(2*$time*1000000)]"
    puts $f2 "$now [expr (($bw2+$hr3)*8)/(2*$time*1000000)]"
    $sink set bytes_ 0
    $sink1 set bytes_ 0
    $sink2 set bytes_ 0
    set hr1 $bw0
    set hr2 $bw1
    set hr3 $bw2
    $ns at [expr $now+$time] "record" 
}

$ns at 0 "record" 
$ns at 1.0 "$ftp0 start"
$ns at 1.0 "$ftp1 start"
$ns at 1.0 "$ftp2 start"
$ns at 1.0 "$ftp3 start"

$ns initial_node_pos $n0 30
$ns initial_node_pos $n1 30
$ns initial_node_pos $n2 30
$ns initial_node_pos $n3 30
$ns initial_node_pos $n4 30

$ns at 190.0 "$ftp0 stop"
$ns at 190.0 "$ftp1 stop"
$ns at 190.0 "$ftp2 stop"
$ns at 190.0 "$ftp3 stop"

$ns at 200.0 "finish"

$ns run




