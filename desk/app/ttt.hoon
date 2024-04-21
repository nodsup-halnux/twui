:: This app uses the %squad page serving/index.hoon code, and %charlie as a Gall App template.
:: Our structure file. Standard action/update pattern is also used (in /mar)
/-  *ttt
/+  default-agent, twui
::Import FE file that we will serve up in ++on-poke
::/=  frontpage  /app/frontend/frontpage
::We call the agent arm from the core in the twui library
::The idea:  ++agent is fed our state and our agent together. So it
::has access to them, and can call them. Its just arm calls in the end,
::nested in a given subject tree...
::  This is our state core - twui needs to be able to see it!


|%
    +$  versioned-state
    $%  state-0
    ==
    +$  state-0
        :: A very basic state to test Sail with.
    $:  [%0 gameboard=board]
    ==
    +$  card  card:agent:gall
--

%-  agent:twui
:: Note this is the **input** to the %- call above.
=|  state-0  
=*  state  -
^-  agent:gall
::  Our sample app starts here (10 arm door)
|_  =bowl:gall
+*  this     .
    default  ~(. (default-agent this %|) bowl)
  ++  on-init  
    ~&  "ttt on-init called"  on-init:default
    :: :_  this  [(~(arvo pass:agentio /bind) %e %connect `/'frontpage' %ourapp)]~
++  on-save   !>(state)
++  on-load  
  |=  old=vase
  ^-  (quip card _this)
  `this(state !<(state-0 old))
++  on-poke
    |=  [=mark =vase]
    |^  ::reminder, actions come from /sur
        ^-  (quip card _this)
        ~&  'ttt on poke has been called.'
        ~&  'our mark is'  ~&  mark
        ~&  'our vase is'  ~&  vase
        ?+  mark  `this
            %ttt-action             
                (handle-action !<(action vase))
         ==  ::End ?+  ::End $-arm
        ++  handle-action
            |=  act=action
                ^-  (quip card _this)
                ?-    -.act
                    ::Here, we set a basic state using a poke via the terminal. This will test our Sail render gates
                    %teststate
                    ~&  "TTT has received a teststate poke. Set the board"  
                    =/  row1  ^-  boardrow  ~[[%o] [%e] [%e]]
                    =/  row2  ^-  boardrow  ~[[%o] [%x] [%x]]
                    =/  row3  ^-  boardrow  ~[[%e] [%e] [%e]]
                    =/  theboard  ^-  board  ~[row1 row2 row3]
                    :_  %=  this  gameboard  theboard  ==  ~
                    ::The state can also be reset with a poke, should be choose to. Tests the Sail Null Case.
                    %clearstate
                    ~&  "TTT has received a clearstate poke. Empty the board."
                    =/  row1  ^-  boardrow  ~[[%e] [%e] [%e]]
                    =/  row2  ^-  boardrow  ~[[%e] [%e] [%e]]
                    =/  row3  ^-  boardrow  ~[[%e] [%e] [%e]]
                    =/  theboard  ^-  board  ~[row1 row2 row3]
                    :_  %=  this  gameboard  theboard  ==  ~
                == ::End ?-
    --  ::End |^
++  on-peek  on-peek:default
++  on-watch
  |=  =path
  ^-  (quip card _this)  `this
++  on-arvo   on-arvo:default
++  on-leave  on-leave:default
++  on-agent  on-agent:default
++  on-fail   on-fail:default
--