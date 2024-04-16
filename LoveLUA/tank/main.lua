
-- Tank Battle V1.0 by Jason Williams
-- written for CS50 Introduction to CS 
-- April 2024

Class = require 'class'
require 'Tank'
require 'Missile'
require 'Bang'

-- size of window
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

gameState = 'pregame'
delay = 0
frame = 0

smallFont = love.graphics.newFont('font.ttf', 10)
largeFont = love.graphics.newFont('font.ttf', 20)
scoreFont = love.graphics.newFont('font.ttf', 50)

-- Load function.  Will run at start of game.  Global variables, windows etc.
function love.load()

    sounds = {
      ['fire'] = love.audio.newSource('sounds/fire.ogg', 'static'),
      ['hit'] = love.audio.newSource('sounds/hit.ogg', 'static'),
      ['tank'] = love.audio.newSource('sounds/tank.ogg', 'static'),
    }

    tank_red = love.graphics.newImage('sprites/tank1.png')
    tank_blue = love.graphics.newImage('sprites/tank2.png')
    missile = love.graphics.newImage('sprites/missile.png')
    bang = love.graphics.newImage('sprites/bang.png')

    -- sprite heights, widths
    local widthT = tank_red:getWidth()
    local heightT = tank_red:getHeight()

    local widthM = missile:getWidth()
    local heightM = missile:getHeight()

    -- create tanks for player1 and player2
    player1 = Tank(100, 100, 270, widthT, heightT, 3, tank_red)
    player2 = Tank(1170, 600, 90, widthT, heightT, 3, tank_blue)

    missile1 = Missile(0, 0, 270, widthM, heightM, 15, missile)
    missile2 = Missile(0, 0, 90, widthM, heightM, 15, missile)

    bang = Bang(1100,600,bang)

     -- initialize score variables
     p1Score = 0
     p2Score = 0

    MAX_SCORE = 3
end

-- Game loop.  Will be called every frame - default 60FPS
function love.update(dt)

  -- initialisations for start of 'round'
  if gameState == 'start' then
    player1:reset(100, 100, 270)
    player2:reset(1170, 620, 90)
    missile1:reset()
    missile2:reset()
    bang:reset()

    -- change gamestate back to play
    gameState = 'play'

  -- main gameplay state
  elseif gameState == 'play' then

    -- player tank movement input
    if love.keyboard.isDown("right") then
      player2.dx = player2.speed
      sounds['tank']:play()
    elseif love.keyboard.isDown("left") then
      player2.dx = -player2.speed
      sounds['tank']:play()
    end

    if love.keyboard.isDown("down") then
      player2.dy = player2.speed
      sounds['tank']:play()
    elseif love.keyboard.isDown("up") then
      player2.dy = -player2.speed
      sounds['tank']:play()
    end

    if love.keyboard.isDown("d") then
        player1.dx = player1.speed
        sounds['tank']:play()
    elseif love.keyboard.isDown("a") then
        player1.dx = -player1.speed
        sounds['tank']:play()
    end

    if love.keyboard.isDown("s") then
        player1.dy = player1.speed
        sounds['tank']:play()
    elseif love.keyboard.isDown("w") then
        player1.dy = -player1.speed
        sounds['tank']:play()
    end

      -- missile fire player 2
    if love.keyboard.isDown("/") then
        missile2:fire(player2)
        sounds['fire']:play()
    end

    if love.keyboard.isDown("f") then
        missile1:fire(player1)
        sounds['fire']:play()
    end
  
    -- update positions of missiles and players
    player1:update(dt)
    player2:update(dt)
    missile1:update(dt)
    missile2:update(dt)


    -- check for collisions between two tanks
    -- in a collision, both players explode
    -- no points scored but reset
    if player1:collides(player2) then
      player1.hit = true
      player2.hit = true
      sounds['hit']:play()
      gameState = 'wait'
    end

    -- check for collistions between missiles and players
    if missile1:collides(player2) then
      player2.hit = true
      sounds['hit']:play()
      p1Score = p1Score + 1
      if p1Score == MAX_SCORE then 
        gameState = 'end'
      else
        gameState = 'wait'
      end
    elseif missile2:collides(player1) then
      player1.hit = true
      sounds['hit']:play()
      p2Score = p2Score + 1
      if p2Score == MAX_SCORE then
        gameState = 'end'
      else
        gameState = 'wait'
      end
    end
  elseif gameState == 'end' or gameState == 'pregame' then
      if love.keyboard.isDown("escape") then
        gameState = 'start'
        p1Score = 0
        p2Score = 0
      end
  elseif gameState == 'wait' then
    if delay > 20 then
      delay = 0
      gameState = 'start'
    else
      delay = delay + 1
    end
  end
end

-- Drawing graphics to the screen.  Runs every frame but reserved for images
function love.draw()
  
    -- draw the borders
	  love.graphics.setLineWidth(5)
	  love.graphics.setColor({0, 255, 0})
	  love.graphics.rectangle( "line", 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT, 10, 10)

    -- draw the centre box
    love.graphics.setLineWidth(10)
	  love.graphics.setColor({0, 255, 0})
	  love.graphics.rectangle( "line", (WINDOW_WIDTH / 2) - 80, (WINDOW_HEIGHT / 2)-25, 180, 90, 5, 0)

    love.graphics.setLineWidth(10)
	  love.graphics.setColor({125, 125, 125})
	  love.graphics.rectangle( "fill", (WINDOW_WIDTH / 2) - 80, (WINDOW_HEIGHT / 2)-25, 180, 90, 5, 0)

    love.graphics.setColor({0, 0, 0})
    displayScore()

    -- set background color 
    local r, g, b = love.math.colorFromBytes(186, 166, 132)
    love.graphics.setBackgroundColor(r, g, b)

    love.graphics.setColor({255, 255, 255})

    
    love.graphics.draw(player1.sprite, player1.x, player1.y, player1.r, 1, 1, player1.ox, player1.oy)
    love.graphics.draw(player2.sprite, player2.x, player2.y, player2.r, 1, 1, player2.ox, player2.oy)
  
    if missile2.active == 1 then
      love.graphics.draw(missile2.sprite, missile2.x, missile2.y, missile2.r)
    end

    if missile1.active == 1 then
      love.graphics.draw(missile1.sprite, missile1.x, missile1.y, missile1.r)
    end
  
    if player1.hit == true then
      love.graphics.draw(bang.sprite, player1.x - player1.width, player1.y - player1.height)
    end

    if player2.hit == true then
      love.graphics.draw(bang.sprite, player2.x - player1.width, player2.y - player1.height)
    end
    
    if gameState == 'end' then
      love.graphics.setFont(largeFont)
      love.graphics.setColor({0, 0, 0})
      love.graphics.printf('Game Over!', 0, (WINDOW_HEIGHT / 4) - 30, WINDOW_WIDTH, 'center')

      if p1Score > p2Score then
        love.graphics.setColor({255, 0, 0})
        love.graphics.printf('Red wins', 0, (WINDOW_HEIGHT / 4), WINDOW_WIDTH, 'center')
      else
        love.graphics.setColor({0, 0, 255})
        love.graphics.printf('Blue wins',0, (WINDOW_HEIGHT / 4), WINDOW_WIDTH, 'center')
      end

      love.graphics.setColor({0, 0, 0})
      love.graphics.printf('Press Escape to restart!', 0, (WINDOW_HEIGHT / 4)+30, WINDOW_WIDTH, 'center')
    
    elseif gameState == 'pregame' then
      -- display instructions at start of game
      love.graphics.setFont(largeFont)
      love.graphics.setColor({0, 0, 0})
      love.graphics.printf('Welcome to Tank Battle', 0, (WINDOW_HEIGHT / 4) -50, WINDOW_WIDTH, 'center')
      love.graphics.setColor({0, 0, 255})
      love.graphics.printf('Blue Tank: use arrow keys to move and / to fire', 0, (WINDOW_HEIGHT / 4)-20, WINDOW_WIDTH, 'center')
      love.graphics.setColor({255, 0, 0})
      love.graphics.printf('Red Tank: use A, S, D, W for Left, Down, Right, Up and F to fire  ', 0, (WINDOW_HEIGHT / 4), WINDOW_WIDTH, 'center')
      love.graphics.setColor({0, 0, 0})
      love.graphics.printf('First to get three kills wins', 0, (WINDOW_HEIGHT / 4)+30, WINDOW_WIDTH, 'center')
      love.graphics.printf('Press Escape to start!', 0, (WINDOW_HEIGHT / 4)+60, WINDOW_WIDTH, 'center')
    end
end

function displayScore()
  -- score display
  love.graphics.setFont(scoreFont)

  love.graphics.setColor({255, 0, 0})
  love.graphics.print(tostring(p1Score), WINDOW_WIDTH / 2 - 40, WINDOW_HEIGHT / 2)
  love.graphics.setColor({0, 0, 255})
  love.graphics.print(tostring(p2Score), WINDOW_WIDTH / 2 + 40, WINDOW_HEIGHT / 2)
end

