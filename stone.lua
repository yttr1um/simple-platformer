local Stone = {img = love.graphics.newImage("assets/stone.png")}
Stone.__index = Stone
local ActiveStones = {}

Stone.width = Stone.img:getWidth()
Stone.height = Stone.img:getHeight()

function Stone.new(x, y)
    local instance = setmetatable({}, Stone)
    instance.x = x
    instance.y = y
    instance.r = 0

    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "dynamic")
    instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.body:setMass(50)

    table.insert(ActiveStones, instance)
end

function Stone:update(dt)
    self:syncPhysics()
end

function Stone:syncPhysics()
    self.x, self.y = self.physics.body:getPosition()
    self.r = self.physics.body:getAngle()
end

function Stone:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self.img, self.x, self.y, self.r, self.scaleX, 1, self.width/2, self.height/2)
end

function Stone.updateAll(dt)
    for i, instance in ipairs(ActiveStones) do
        instance:update(dt)
    end
end

function Stone.drawAll()
    for i, instance in ipairs(ActiveStones) do
        instance:draw()
    end
end

return Stone