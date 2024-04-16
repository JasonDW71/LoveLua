Missile = Class{}

function Missile:init(x, y, r, w, h, speed, sprite)
    self.x = x
    self.y = y
    self.width = w
    self.height = h
    self.speed = speed
    self.dx = 0
    self.dy = 0
    self.ox = w / 2
    self.oy = h / 2
    self.r = math.rad(r)
    self.active = 0
    self.sprite = sprite
    self.launch = 0
end

function Missile:update(dt)

    if self.launch == 1 then
        self.active = 1
        self.launch = 0
    end

   -- need to determine the direction of the missile
   -- based on the orientation of the tank
   dir = math.deg(self.r)

   if dir == 270 or dir == 315 or dir == 225 then
        self.dx = self.speed
   elseif dir == 45 or dir == 135 or dir == 90 then
        self.dx = -self.speed
   else
        self.dx = 0
   end

    if dir == 45 or dir == 315 or dir == 0 then
        self.dy = self.speed
     elseif dir == 225 or dir == 135 or dir == 180 then
        self.dy = -self.speed
    else
        self.dy = 0
   end
   
   if self.active == 1 then
    -- check for top and rebound
    if self.x < 0 or self.x > WINDOW_WIDTH then
      self.active = 0
    elseif self.y < 0  or self.y > WINDOW_HEIGHT then
      --self.dy = self.dy * -1
      --self.dx = self.dx * -1
      self.dy = -self.dy
      if dir == 45 then
        self.r = math.rad(135)
      elseif dir == 135 then
        self.r = math.rad(45)
      elseif dir == 225 then
        self.r = math.rad(315)
      elseif dir == 315 then
        self.r = math.rad(225)
      else
        self.active = 0
      end 
        
      self.y = self.y + self.dy
      self.x = self.x + self.dx
    else
      self.y = self.y + self.dy
      self.x = self.x + self.dx
    end
  end
end

function Missile:collides(player)
  
    --  offset detection as missile coords are bottom left of player tank.
    dir = math.deg(self.r)
  
    if dir == 90  then
      -- left
      pos_x = self.x + 5
      pos_y = self.y - 25
     
      -- up 
    elseif dir == 270 then
      pos_x = self.x + 5
      pos_y = self.y - 45
      
      -- down
    elseif dir == 0 then
      pos_x = self.x + 35
      pos_y = self.y - 5
    
      -- up 
    elseif dir == 180 then
      pos_x = self.x + 25
      pos_y = self.y - 5
  
      -- down / left
    elseif dir == 45 then
      pos_x = self.x + 5
      pos_y = self.y - 5
 
      -- up / right
    elseif dir == 225 then
      pos_x = self.x + 5
      pos_y = self.y - 5

      -- down / right
    elseif dir == 315 then
      pos_x = self.x + 50
      pos_y = self.y - 5

      -- up / left
    elseif dir == 135 then
      pos_x = self.x + 35
      pos_y = self.y - 5
    
    else
      pos_y = self.y - 20
      pos_x = self.x + 20
    end
    
  
    if pos_x > player.x + player.width or player.x > pos_x + self.width then
        return false
    end

    if pos_y < player.y - player.height or player.y < pos_y - self.width then
        return false
    end 

    -- if the above aren't true, they're overlapping
    return true
end

function Missile:fire(player)
  
    -- calculate the offset position for the missile
    self.launch = 1
  
    dir = math.deg(player.r)
  
    if dir == 90  then
      -- left
      self.x = player.x-15
      self.y = player.y-5
      -- right
    elseif dir == 270 then
      self.x = player.x+15
      self.y = player.y+5
      -- down
    elseif dir == 0 then
      self.x = player.x-5
      self.y = player.y+15
      -- up 
    elseif dir == 180 then
      self.x = player.x+5
      self.y = player.y-15
      -- down / left
    elseif dir == 45 then
      self.x = player.x-15
      self.y = player.y+5
      -- up / right
    elseif dir == 225 then
      self.x = player.x+15
      self.y = player.y-5
      -- down / right
    elseif dir == 315 then
      self.x = player.x+10
      self.y = player.y+15
      -- up / left
    elseif dir == 135 then
      self.x = player.x-5
      self.y = player.y-15
      -- down / left
    else
      self.x = player.x-10
      self.y = player.y+20
    end
      
    self.r = player.r
end

function Missile:reset(x, y)
    self.x = -1
    self.y = -1
    self.active = 0
    self.launch = 0
end