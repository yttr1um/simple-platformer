Coin = {}
Coin.__index = Coin
ActiveCoins = {}

function Coin.new(x, y, world)
    local instance = setmetatable({}, Coin)
    instance.x = x
    instance.y = y
    instance.img = love.graphics.newImage("sprites/coin .png")
    instance.width = instance.img:getWidth()
    instance.height = instance.img:getHeight()
    instance.scaleX = 1

    instance.physics = {}
    instance.physics.body = love.physics.newBody(world, instance.x, instance.y, "static")
    instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    table.insert(ActiveCoins, instance)
end

function Coin:update(dt)
    self:spin(dt)
end

function Coin:spin(dt)
    self.scaleX = math.sin(love.timer.getTime() * 2)
end

function Coin:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self.img, self.x, self.y, 0, self.scaleX, 1, self.width/2, self.height/2)
end

function Coin.updateAll(dt)
    for i, instance in ipairs(ActiveCoins) do
        instance:update(dt)
    end
end

function Coin.drawAll()
    for i, instance in ipairs(ActiveCoins) do
        instance:draw()
    end
end