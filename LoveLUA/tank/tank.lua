Tank = Class{}

function Tank:init(x, y, r, width, height, speed, sprite)
    self.x = x
    self.y = y
    self.dy = 0
    self.dx = 0
    self.r = math.rad(r)
    self.height = height
    self.width = width
    self.ox = width / 2
    self.oy = height / 2
    self.speed = speed
    self.sprite = sprite
    self.hit = 0
end

function Tank:update(dt)
    -- set the angle of travel
    if self.dx < 0 and self.dy > 0 then
        self.r = math.rad(45)
    elseif self.dx > 0 and self.dy > 0 then
        self.r = math.rad(315)
    elseif self.dx < 0 and self.dy < 0 then
        self.r = math.rad(135)
    elseif self.dx > 0 and self.dy < 0 then
        self.r = math.rad(225)
    elseif self.dx == 0 and self.dy > 0 then
            self.r = math.rad(0)
    elseif self.dx == 0 and self.dy < 0 then
             self.r = math.rad(180)
    elseif self.dx < 0 and self.dy == 0 then
             self.r = math.rad(90)
    elseif self.dx > 0 and self.dy == 0 then
             self.r = math.rad(270)
    end

    -- Update y coords after checking its not off the screen
    if self.y < self.height / 2 then
        self.y = math.max(self.height / 2, self.y + self.dy)
    else
        self.y = math.min(WINDOW_HEIGHT - self.height / 2, self.y + self.dy)
    end

    -- Update x coords after checking its not off the screen
    if self.x < self.width / 2 then
        self.x = math.max(self.width / 2, self.x + self.dx)
    else
        self.x = math.min(WINDOW_WIDTH - self.width / 2, self.x + self.dx)
    end

    -- reset dy and dx
    self.dy = 0
    self.dx = 0
end

function Tank:addScore(dt)
    self.score = self.score + 1
end

function Tank:reset(x, y, r)
    self.x = x
    self.y = y
    self.r = math.rad(r)
    self.hit = 0
end

function Tank:collides(player)
  
    --  offset detection as missile coords are bottom left of player tank.
    if self.x > player.x + player.width or player.x > self.x + self.width then
        return false
    end

    if self.y < player.y - player.height or player.y < self.y - self.width then
        return false
    end 

    -- if the above aren't true, they're overlapping
    return true
end