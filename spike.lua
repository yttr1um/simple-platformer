local Spike = {img = love.graphics.newImage("assets/spikes.png")}
Spike.__index = Spike
local ActiveSpikes = {}
local Player = require("Player")

Spike.width = Spike.img:getWidth()
Spike.height = Spike.img:getHeight()

function Spike.new(x, y)
    local instance = setmetatable({}, Spike)
    instance.x = x
    instance.y = y

    instance.damage = 1

    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "static")
    instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.fixture:setSensor(true)

    table.insert(ActiveSpikes, instance)
end

function Spike:update(dt)

end

function Spike:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self.img, self.x, self.y, 0, self.scaleX, 1, self.width/2, self.height/2)
end

function Spike.updateAll(dt)
    for i, instance in ipairs(ActiveSpikes) do
        instance:update(dt)
    end
end

function Spike.drawAll()
    for i, instance in ipairs(ActiveSpikes) do
        instance:draw()
    end
end

function Spike.beginContact(a, b, contact)
    for i, instance in ipairs(ActiveSpikes) do
        if a == instance.physics.fixture or b == instance.physics.fixture then
            if a == Player.physics.fixture or b == Player.physics.fixture then
                Player:takeDamage(instance.damage)
                return true
            end
        end
    end
end

return Spike