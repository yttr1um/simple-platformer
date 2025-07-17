Player = {}

function Player:load()
    self.x = 100
    self.y = 0
    self.width = 50
    self.height = 50
    self.xVel = 0
    self.yVel = 0
    self.maxSpeed = 200
    self.acceleration = 4000
    self.friction = 3500

    self.physics = {}
    self.physics.body = love.physics.newBody(World, self.x, self.y, "dynamic")
    self.physics.body:setFixedRotation(true)
    self.physics.shape = love.physics.newRectangleShape(self.width/2, self.height/2, self.width, self.height)
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)

end

function Player:update(dt)

end

function Player:draw()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

-- function Player(world) 

--     _width = 50
--     _height = 50

--     local player = {
--         x = 100,
--         y = 200,
--         w = _width,
--         h = _height,
--         speed = 300,
--         canJump = false,
--         tag = "player",
--         body = love.physics.newBody(world, 100, 200, "dynamic"),
--         shape = love.physics.newRectangleShape(_width/2, _height/2, _width, _height),
--         coins = 0,

--         move = function(self) 

--             local dx, dy = player.body:getLinearVelocity()
--             dx = 0

--             if love.keyboard.isDown("d") then
--                 dx = self.speed
--             elseif love.keyboard.isDown("a") then
--                 dx = -self.speed
--             end

--             if love.keyboard.isDown("s") then
--                 dy = self.speed
--             elseif love.keyboard.isDown("w") then
--                 if self.canJump then
--                     dy = -self.speed
--                 end
--             end

--             self.body:setLinearVelocity(dx, dy)
--             self.x, self.y = self.body:getPosition()
--         end,

--         draw = function(self)
--             love.graphics.setColor(1, 1, 1)
--             love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
--         end,

--         contactPlatform = function(obj1, obj2)
--             if obj1 and obj2 then
--                 if (obj1.tag == "player" or obj2.tag == "player") and (obj1.tag == "platform" or obj2.tag == "platform") then
--                     local player = obj1.tag == "player" and obj1 or obj2
--                     player.canJump = not player.canJump
--                 end
--             end
--         end,

--         incrementCoins = function(self)
--             self.coins = self.coins + 1
--         end,
--     }

--     player.body:setFixedRotation(true)
--     player.fixture = love.physics.newFixture(player.body, player.shape)
--     player.fixture:setUserData(player)

--     return player
-- end

-- return Player