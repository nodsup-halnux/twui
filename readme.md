## WUI: Web User Interface:

This repository documents an agent wrapper library  to be used to visualize Gall App states, for Hoon Academy 24'.

For students designing gameboard apps, this library will display such boards using a webpage interface, using minimal overhead and code boilerplate to students. 


### How WUI works:

WUI is a wrapper library that behaves in a similar manner to the `+dbug` library. The state and game app are fed into the wui library as a gate call, and wui acts as a wrapper between the Gall vane, and the app itself. Every request to/from Gall and the App itself is mediated by WUI, which interprets the pokes as either being for itself, or for the app.  

Most of the functionality for WUI is implemented in the++on-poke arm, with the rest of its implementation spread across ++on-arvo and ++on-init - for the webpage bindings for the web browser.


###  Using the Library:

WUI is implemented as a pair of /lib and /sur files, which are imported into a desk.

Currently, the library is split depending on the board game a user wishes to play - either *Tic-Tac-Toe* or *Minesweeper*. The files are named `ttt-wui` and `ms-wui`, respectively.

To use this library, setup your Tic-Tac-Toe or Minesweeper desk as follows:

```
%yourapp
├── app
│   ├── yourappname.hoon
│   └── frontend
│        └──  display.hoon
│
├── lib
│   └── *-wui.hoon
│
├── sur 
│   └── *-wui.hoon
│
├── mar
│    └── action ...
│    └── update ...
│...
```

In your app file, import the *-wui.hoon lib file. Some sample app code is below:

```hoon
/-  *ttt
/+  default-agent, twui, dbug
|%
    +$  versioned-state
    $%  state-0
    ==
    +$  state-0  appstate
    +$  card  card:agent:gall
--
	%-  agent:dbug
%-  agent:twui
=|  state-0  
=*  state  -
^-  agent:gall
|_  =bowl:gall
...
```


Notice that the `+dbug` wrapper has also been included.  **Yes**, you can still use +dbug, and wrap it around WUI!


###  Gameboard Format:

In order to display the gameboards properly, WUI assumes a particular state
structure, which is reads upon every interaction with the game app.  The two 
structures for tic-tac-toe and minesweeper, are listed below:

Generally speaking: a gameboard is a `n x m` grid that is reprsented by a map of coordinates to squares.  The sur files build up structures to support the board map, and have other structures to keep track of players, and other
game information.

Users can alter the structure files to **add additional** fields, as long as the basic fields that are provided are not altered in any way. In theory, as the long
as the state structure keeps its bindings and shapes, the front-end should not care if additional state fields have been added, for it simply was not designed to access these new fields.

#### Tic-Tac-Toe:

``` hoon
|%
+$  action
  $%
	  [%newgame ~]
      [%move r=@ud c=@ud ttype=tokensymbol]
  ==
+$  update
  $%  [%init values=(list @)]
  ==
+$  tokensymbol  $?  %x  %o  %e  ==
+$  playersymbol  $?  %p1x  %p2o  ==
+$  statussymbol  $?  %p1win  %p2win  %draw  %cont  ==
+$  dims  [rows=@ud cols=@ud]
+$  coord  [r=@ud c=@ud]
+$  square  tokensymbol
+$  boardmap  (map coord square)
+$  appstate  $:  
                %0 
                board=boardmap 
                bsize=dims 
                currplayer=playersymbol
                moves=@ud
                status=statussymbol
              ==
--

```

####  Minesweeper:

``` hoon
...
+$  boardmap  (map coord squarestate)
```


### References and Acknolwedgements:

This wrapper library is a derivative work. Speficially, its framework and design is heavily influenced by the following code repositories:

1) The [Squad App](https://github.com/urbit/docs-examples/tree/main/groups-app):  Code/Software design ideas from this was used achieve the following:
	- Bind a simple front end Sail Page to a browser url, using `++on-init` and `++on-arvo` arms. 
	Specifically, the bind call ``(~(arvo pass:agentio /bind) %e %connect /'gameuis %gameuis)``
	- Nesting a mini http server in a |^ arm, in the on-poke arm of the app

2)  The [+dbug library](https://docs.urbit.org/courses/app-school/3-imports-and-aliases#dbug):  The overall wrapper framework structure was mimic'ed in this app.  This involves passing in a state+app into a library gate call, and having wrapper arms route Gall requests either to themselves, or to the wrapped app. As this was the solution to the needs of this wrapper library, the same structure was reused.

A special thanks also goes out to `~tamlut-modnys`, and `~lagrev-nocfep` for assistance in the design, and help with state debugging.