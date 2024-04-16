# TANK BATTLE
### Video Demo: 
### Description:

#### The Game
Tank Battle is a simple 2D two player game writting in Lua for use with the LÖVE gaming framework

In the game, two tanks are controlled independently by two players using the keyboard.  

Player 1 controls the Red tank:

  Left:  A
  Right: D
  Up:    W
  Down:  S
  Fire:  F

Player 2 controls the blue tank:

  Arrow keys to move
  Fire: /

Missiles will deflect from the top and bottom borders (except where they hit at 90 degrees) and terminate at the left and right borders.  
A point is scored for hitting the opposition tank and the winner is the first to reach three points

If the tanks collide, both explode and return to their starting positions without any points awarded.

#### The Code
LoveLua games follow a defined code structure, based around three main 'blocks' within main.lua

##### love.load() 
This runs at the start of the game and contains global variables.  Specifically, this is where the sprites and sounds relating to the tank, missile, and bang are defined and instances of these objects created

##### love.update()
This controls the main gameplay.  Effectively, code within this function is executed every game frame.  The game defaults as 60FPS so this code executes 60 times every second.  

The actions differ depending on the 'game state' which can be one of four values:

pregame - the first game has not started
end - the game has ended (i.e. a player has won)

In both these states, the main update function is just waiting for the escape key to be pressed which will start / restart the game

start - this is a transitory state where the game objects are reset before the gamestate is set to 'play'

play - this is the active gameplay state.  In this state, the function is looking for imput from the users to move the tank and/or fire missiles.  It is also looking for collisions between the two players or between a missile and a player.
When user input is detected, it results in updates to one or other object attributes.  For example, the direction of travel for the tank or missile.  Each of these objects has its own specific code which manages the changes in that object - tank.lua, missile.lua, bang.lua

wait - one final state is activated when there is a collistion detected.  This is to allow a sufficient delay to occur between the collision explosion and the reset back to the gameplay.

##### love.draw()
Like love.update() this functions runs every frame but is reserved for image management.  In this function, the initial play area is drawn, including the scoreboard,  the sprites are drawn, and any text is written to the screen for the 'pregame' and 'end' gameStates.


Object Control functions:

Each of the object control functions is divided into two blocks:

Object: init () 
- defined the initial state of the object

Object: update ()
- defines the actions to update / move the object


There are three objects defined

tank.lua
This controls the Tank / player objects, updating the positional coordinates and orientation based on user key input gathered in the main love.update() function.

Seperate functions also detect for tank to tank collisions, keeping the tank (players) score which is stored as attribute of the object.  

missile.lua
Similarly to tank.lua, this controls the movement o

bang.lua
