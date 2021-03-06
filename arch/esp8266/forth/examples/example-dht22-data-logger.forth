exception: EGAVEUP
variable: data
variable: server

: measure ( -- temperature humidity | throws:EGAVEUP )
    10 0 do
        ['] dht-measure catch ?dup 0<> 
        if
            ex-type cr
            5000 ms
        else
            unloop exit
        then
    loop
    EGAVEUP throw ;

: data! ( temperature humidity -- ) 16 lshift swap or data ! ;
: connect ( -- ) 8007 str: "192.168.0.10" UDP netcon-connect server ! ;
: dispose ( -- ) server @ netcon-dispose ;
: send ( -- ) server @ data 4 netcon-send-buf ;
    
: log ( temperature humidity -- )
    data! 
    connect
    ['] send catch dispose throw ;
    
: log-measurement ( -- )
    { 
        measure 
        2dup log 500 ms log 
    } 
    catch ?dup 0<> if
        ex-type cr
    then ;

: main ( -- )
    log-measurement
    600000000 deep-sleep ;
    
' boot is: main
turnkey abort