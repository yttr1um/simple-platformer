function Player(world) 

    _width = 50
    _height = 50


    local player = {
        x = 100,
        y = 200,
        w = _width,
        h = _height,
        speed = 300,
        tag = "player",
        body = love.physics.newBody(world, 100, 200, "dynamic"),
        shape = love.physics.newRectangleShape(_width/2, _height/2, _width, _height),

        move = function(self) 

            local dx, dy = 0, 0

            if love.keyboard.isDown("d") then
                dx = self.speed
            elseif love.keyboard.isDown("a") then
                dx = -self.speed
            end

            if love.keyboard.isDown("s") then
                dy = self.speed
            elseif love.keyboard.isDown("w") then
                dy = -self.speed
            end

            self.body:setLinearVelocity(dx, dy)
            self.x, self.y = self.body:getPosition()
        end,

        draw = function(self)
            love.graphics.setColor(1, 1, 1)
            love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
        end,
    }

    player.fixture = love.physics.newFixture(player.body, player.shape)

    return player
end

return Player