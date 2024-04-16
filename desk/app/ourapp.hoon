:: This app uses the %squad page serving/index.hoon code, and %charlie as a Gall App template.
:: Our structure file. Standard action/update pattern is also used (in /mar)
/-  *ourapp
/+  default-agent, agentio, saildebug
::Import FE file that we will serve up in ++on-poke
/=  indexdebug  /app/frontend/indexdebug
|%
    +$  versioned-state
    $%  state-0
    ==
    +$  state-0
        :: A very basic state to test Sail with.
    $:  [%0 values=(list @ud) gameboard=board playmap=playerinfo]
    ==
    +$  card  card:agent:gall
--

::We call the agent arm from the core in the saildebug library

%-  agent:saildebug

:: Note this is the **input** to the %- call above.
=|  state-0
=*  state  -
^-  agent:gall
::  Our sample app starts here (10 arm door)
|_  =bowl:gall
+*  this     .
    default  ~(. (default-agent this %|) bowl)
  ++  on-init  
    ~&  "ourapp on-init called"
    ^-  (quip card _this)  ::do we need the alias (io for agentio??) [!!!]
    :_  this  [(~(arvo pass:agentio /bind) %e %connect `/'indexdebug' %ourapp)]~
++  on-save   !>(state)
++  on-load  
  |=  old=vase
  ^-  (quip card _this)
  `this(state !<(state-0 old))
++  on-poke
    |=  [=mark =vase]
    |^  ::reminder, where does action var come from?? Our /sur file, of course!
        ^-  (quip card _this)
        ?+  mark  `this
            %ourapp-action             
                (handle-action !<(action vase))
         ==  ::End ?+  ::End $-arm
        ++  handle-action
            |=  act=action
                ^-  (quip card _this)
                ?-    -.act
                    ::Dummied, remove later
                    %push  `this
                    %pop  `this
                    ::Here, we set a basic state using a poke via the terminal. This will test our Sail render gates
                    %teststate
                    ~&  "Our App has received a teststate poke"  
                    =/  p1  ^-  player  [~nodsup-sorlex 1 %spade %red]
                    =/  p2  ^-  player  [~miglex-todsup 2 %diamond %green]
                    =/  row1  ^-  boardrow  ~[[%white %empty] [%black %spade] [%white %diamond]]
                    =/  row2  ^-  boardrow  ~[[%black %spade] [%white %diamond] [%black %diamond]]
                    =/  row3  ^-  boardrow  ~[[%white %spade] [%black %empty] [%white %empty]]
                    =/  theboard  ^-  board  ~[row1 row2 row3]
                    =/  theplayermap  (my ~[[1 p1] [2 p2]])
                    :_  %=  this  playmap  theplayermap  gameboard  theboard  ==  ~
                    ::The state can also be reset with a poke, should be choose to. Tests the Sail Null Case.
                    %clearstate
                    ~&  "Our App has received a clearstate poke"
                    :_  %=  this  playmap  *playerinfo  gameboard  *board  ==  ~
                == ::End ?-
    --  ::End |^
++  on-peek  on-peek:default
++  on-watch  on-watch:default
++  on-arvo   on-arvo:default
++  on-leave  on-leave:default
++  on-agent  on-agent:default
++  on-fail   on-fail:default
--