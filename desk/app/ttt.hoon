:: Our structure file.
/-  *ttt
::  default-agent used to default un-implemented arms.
/+  default-agent, twui
:: Note:  Our state structure has been defined in /sur
:: This is done to aide the twui wrapper - this is not
:: standard practice in app development.
|%
    +$  versioned-state
    $%  state-0
    ==
    +$  state-0  appstate
    ::  shorthand to reference card type.
    +$  card  card:agent:gall
--
::  Our wrapper takes in our gall agent, with state-0
::  pinned to its subject.  TWUI wraps around our app.
::  To the Gall vane, this is just another app. As long
::  As a [this card] is returned after every arm call, 
::  Gall is none-the-wiser.
%-  agent:twui
::  Pin the state
=|  state-0  
::  Tis-tar deferred expression. state ref's state-0
::  Which is in the LH slot of our subject (-).
=*  state  -
::  Our sample app starts here (10 arm door).
^-  agent:gall
|_  =bowl:gall
+*  this     .
    default  ~(. (default-agent this %|) bowl)
::
++  on-init  on-init:default
::
++  on-save   !>(state)
::
++  on-load  
  |=  old=vase
  ^-  (quip card _this)
  ::  Shorthand for: Irregular form of cen-tis
  ::  ` creates a cell with a ~ in the front (no cards)
  `this(state !<(state-0 old))
::
++  on-poke
    |=  [=mark =vase]
        ^-  (quip card _this)
        ~&  '%ttt on-poke:'  ~&  mark
        =/  act  !<(action vase)
        ::  Unrecognized actions do nothing, instead
        ::  of crashing out.
        ?-  -.act
            ::Make a new game, or reset the game.
            %newgame
                ~&  "TTT has received a newgame poke."
                :: Manually form our board cell.
                =/  ntn  
                    :*
                        [[r=0 c=0] m=%e] 
                        [[r=0 c=1] m=%e]
                        [[r=0 c=2] m=%e]
                        [[r=1 c=0] m=%e] 
                        [[r=1 c=1] m=%e]
                        [[r=1 c=2] m=%e]
                        [[r=2 c=0] m=%e] 
                        [[r=2 c=1] m=%e]
                        [[r=2 c=2] m=%e]
                    ~
                ==
                ::  Our [state card] cell
                :_  
                    %=  
                        this  bsize  
                        [r=3 c=3]  
                        board  (my ntn)  
                        moves  0  
                        currplayer  %p1x  
                    status  %cont    
                ==  
            ~  :: End of %newgame case.
            %printstate
                ~&  'Board='  ~&  board
                ~&  'Dims='  ~&  bsize
                ~&  'currplayer='  ~&  currplayer
                ~&  'moves'  ~&  moves
                ~&  'status'  ~&  status
                `this
            %teststate
                =/  ntn  
                        :*
                            [[r=0 c=0] m=%o] 
                            [[r=0 c=1] m=%x]
                            [[r=0 c=2] m=%e]
                            [[r=1 c=0] m=%o] 
                            [[r=1 c=1] m=%x]
                            [[r=1 c=2] m=%x]
                            [[r=2 c=0] m=%o] 
                            [[r=2 c=1] m=%e]
                            [[r=2 c=2] m=%e]
                            ~
                        ==
                :_  
                    %=  
                    this  
                    bsize  [r=3 c=3]  
                    board  (my ntn)  
                    moves  6  
                    currplayer  %p1x  
                    status  %cont  
                ==  
            ~
            ::  End of %teststate case.
            %move  
            :_  
                %=  this  
                    board  (~(put by board) [[r.act c.act] [ttype.act]])  
                    moves  +(moves)  
                ==  
            ~
            ::End of %move case
            %testfe
            :_  
                %=  this  
                    currplayer  current.act  
                    status  stat.act  
                ==  
            ~
            ::  End of %testfe case.
        ==  ::  End of ?-::
::  All arms below just defaulted - no special
::  implementation for this app.
++  on-peek  on-peek:default
++  on-watch
  |=  =path
  ^-  (quip card _this)  `this
++  on-arvo   on-arvo:default
++  on-leave  on-leave:default
++  on-agent  on-agent:default
++  on-fail   on-fail:default
--