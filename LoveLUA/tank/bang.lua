Bang = Class{}

function Bang:init(x, y, sprite)
    self.x = 0
    self.y = 0
    self.sprite = sprite
end

function Bang:update(dt)
    return true
end


function Bang:hit(player)
    self.x = player.x - 800
    self.y = player.y - 800

    return true
end

function Bang:reset(dt)
    self.x = -1
    self.y = -1
end

