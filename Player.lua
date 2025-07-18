anim8 = require("libraries/anim8")

local Player = {}

function Player:load()
    self.x = 100
    self.y = 0
    self.startX = self.x
    self.startY = self.y

    self.width = 20
    self.height = 20
    self.xVel = 0
    self.yVel = 0
    self.maxSpeed = 200
    self.acceleration = 4000
    self.friction = 3500
    self.gravity = 1500
    self.jumpAmount = -500

    self.color = {
        red = 1,
        green = 1,
        blue = 1,
        speed = 3,
    }

    self.graceTime = 0
    self.graceDuration = 0.1

    self.alive = true
    self.grounded = false
    self.hasDoubleJump = true
    
    self.direction = "right"

    self.coins = 0
    self.health = {current = 3, max = 3}

    self:loadAssets()

    self.physics = {}
    self.physics.body = love.physics.newBody(World, self.x, self.y, "dynamic")
    self.physics.body:setFixedRotation(true)
    self.physics.shape = love.physics.newRectangleShape(self.width, self.height)
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
    self.physics.body:setGravityScale(0)
end

function Player:loadAssets()
    self.animation = {}
    self.animation.rate = 0.25
    self.animation.spriteSheet = love.graphics.newImage("assets/knight.png")
    self.grid = anim8.newGrid(32, 32, self.animation.spriteSheet:getWidth(), self.animation.spriteSheet:getHeight())

    self.animation.idle = anim8.newAnimation(self.grid('1-4', 1), self.animation.rate)
    self.animation.run = anim8.newAnimation(self.grid('1-8', '3-4'), self.animation.rate)

    self.animation.draw = self.animation.idle
    self.animation.width = 32
    self.animation.height = 32
end

function Player:takeDamage(amount)
    self:tintRed()
    if self.health.current - amount > 0 then
        self.health.current = self.health.current - amount
    else
        self.health.current = 0
        self:die()
    end
    print("Player Health: "..self.health.current)
end

function Player:die()
    print("Player died")
    self.alive = false
end

function Player:respawn()
    if not self.alive then
        self.physics.body:setPosition(self.startX, self.startY)
        self.health.current = self.health.max
        self.alive = true
    end
end

function Player:tintRed()
    self.color.green = 0
    self.color.blue = 0
end

function Player:incrementCoins()
    self.coins = self.coins + 1
end

function Player:update(dt)
    self:untint(dt)
    self:respawn()
    self:setDirection()
    self:syncPhysics()
    self:move(dt)
    self:applyGravity(dt)
    self:decreaseGraceTime(dt)
    self.animation.draw:update(dt)
end

function Player:untint(dt)
    self.color.red = math.min(self.color.red + self.color.speed * dt, 1)
    self.color.green = math.min(self.color.green + self.color.speed * dt, 1)
    self.color.blue = math.min(self.color.blue + self.color.speed * dt, 1)
end

function Player:setDirection()
    if self.xVel < 0 then
        self.direction = "left"
    elseif self.xVel > 0 then
        self.direction = "right"
    end
end

function Player:decreaseGraceTime(dt)
    self.graceTime = self.graceTime - dt
end

function Player:applyGravity(dt)
    if not self.grounded then
        self.yVel = self.yVel + self.gravity * dt 
    end
end

function Player:move(dt)
    self.animation.draw = self.animation.idle
    if love.keyboard.isDown("d", "right") then
        self.animation.rate = 0.1
        self.animation.draw = self.animation.run
        if self.xVel < self.maxSpeed then
            if self.xVel + self.acceleration * dt < self.maxSpeed then
                self.xVel = self.xVel + self.acceleration * dt
            else
                self.xVel = self.maxSpeed
            end
        end
    elseif love.keyboard.isDown("a", "left") then
        self.animation.rate = 0.1
        self.animation.draw = self.animation.run
        if self.xVel > -self.maxSpeed then
            if self.xVel - self.acceleration * dt < self.maxSpeed then
                self.xVel = self.xVel - self.acceleration * dt
            else
                self.xVel = -self.maxSpeed
            end
        end
    else
        self:applyFriction(dt)
    end
end

function Player:applyFriction(dt)
    if self.xVel > 0 then
        if self.xVel - self.friction * dt > 0 then
            self.xVel = self.xVel - self.friction * dt
        else
            self.xVel = 0
        end
    elseif self.xVel < 0 then
        if self.xVel + self.friction * dt < 0 then
            self.xVel = self.xVel + self.friction * dt
        else
            self.xVel = 0
        end
    end
end

function Player:syncPhysics()
    self.x, self.y = self.physics.body:getPosition()
    self.physics.body:setLinearVelocity(self.xVel, self.yVel)
end

function Player:beginContact(a, b, collision)
    if self.grounded then return end
    local nx, ny = collision:getNormal()
    if a == self.physics.fixture then
        if ny > 0 then
            self:land(collision)
        end
    elseif b == self.physics.fixture then
        if ny < 0 then
            self:land(collision)
        end
    end
end

function Player:land(collision)
    self.currentGroundCollision = collision
    self.yVel = 0
    self.grounded = true
    self.hasDoubleJump = true
    self.graceTime = self.graceDuration
end

function Player:jump(key)
    if key == "w" or key == "up" then
        if self.grounded or self.graceTime > 0 then
            self.yVel = self.jumpAmount
            self.grounded = false
            self.graceTime = 0 
        elseif self.hasDoubleJump then
            self.hasDoubleJump = false
            self.yVel = self.jumpAmount * 0.8
        end
    end
end

function Player:endContact(a, b, collision)
    if a == self.physics.fixture or b == self.physics.fixture then
        if self.currentGroundCollision == collision then
            self.grounded = false
        end
    end
end

function Player:draw()
    local scaleX = self.direction == "left" and -1 or 1

    love.graphics.setColor(self.color.red, self.color.green, self.color.blue)
    self.animation.draw:draw(self.animation.spriteSheet, self.x, self.y, nil, scaleX, 1, self.animation.width/2, self.animation.height/2)

    love.graphics.setColor(1, 1, 1)
end

return Player