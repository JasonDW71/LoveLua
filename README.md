# TANK BATTLE
### Video Demo: 
### Description:

#### The Game
Tank Battle is a simple 2D two player game writting in Lua for use with the LÖVE gaming framework

In the game, two tanks are controlled independently by two players using the keyboard.  

Player 1 controls the Red tank:

  - Left:  A
  - Right: D
  - Up:    W
  - Down:  S
  - Fire:  F

Player 2 controls the blue tank:

  - Arrow keys to move
  - Fire: /

Missiles will deflect from the top and bottom borders (except where they hit at 90 degrees) and terminate at the left and right borders.  A point is scored for hitting the opposition tank and the winner is the first to reach three points

If the tanks collide, both explode and return to their starting positions without any points awarded.

#### The Code - main.lua
LoveLua games follow a defined code structure, based around three main 'blocks' or functions within the file **main.lua**

##### love.load() 
*This runs at the start of the game and contains global variables.  Specifically, this is where the sprites and sounds relating to the tank, missile, and bang are defined and instances of these objects created*

*A decision was taken to keep the sprites simple, forgoing any animation, with focus on the core gameplay.  In future iterations of the game, animation can be added as well as other features such as internal walls/barracades within the play area.*

##### love.update()
*This controls the main gameplay.  Effectively, code within this function is executed every game frame.  The game defaults as 60FPS so this code executes 60 times every second.*

*The actions/updates differ depending on the 'game state' which can be one of five values:*

- pregame: when the first game has not started
- end: when a game has ended (i.e. a player has won)

*In both these two states, the main update function waits for the escape key to be pressed which will start / restart the game, moving initially to gameState = start*

- start: this is a transitory state where the game objects are reset before the game fully begins by setting the gameState = play*

- play: this is the active gameplay state where most the of code focuses.  In this state, the function is looking for input from the users to move the tank and/or fire missiles and checking for collisions between the two players or between a missile and a player.

*When user input is detected, it results in updates to either or both of the dx and dy (delta x, delta y) attributes which represent a movement along those coordinates.  It also initiates the appropriate sound associated with the movement unsing the sound:play() method.*

*Collision detections, between two players and between a missile and a player are also implementeted here, through methods on the player/tank objects and the missile objects respectively*  

_The update methods for the objects are then called.  Code for these objects is defined in **tank.lua** and **missile.lua** In the event of a collision, the gameState = wait_

- wait: one final state is activated only when there is a collistion detected to allow a sufficient pause to occur between the collision explosion and the reset back to the gameplay.

##### love.draw()
*Like love.update() this functions runs every frame but is reserved for image management.  In this function, the initial play area is drawn, including the scoreboard,  the sprites are drawn, and any text is written to the screen for the 'pregame' and 'end' gameStates.*


#### The Code - Object Control functions

Each of the object control functions is divided into two blocks:

- **Object: init()** defines the initial state of the object
- **Object: update()** defines the actions to update / move the object


There are three specific objects defined in the game:

- **tank.lua:**  controls the Tank / player objects, updating the positional coordinates and orientation based on user key input gathered in the main love.update() function.  Seperate methods also detect for tank to tank collisions, keeping the tank (players) score which is stored as attribute of the object.  

- **missile.lua:** Similarly to tank.lua, this controls the firing and movement of the missile and the detenction of collisions between the missile and the opponents tank.

- **bang.lua:** contains the initialisation and reset methods for the explosion sprite only

Finally, the game makes use of a public domain file **class.lua** which enables the use of object orientation with Lua. 
