local STI = require("libraries/sti")
require("Player")
require("coin")
require("gui")

love.graphics.setDefaultFilter("nearest", "nearest")

function beginContact(a, b, collision)
    if Coin.beginContact(a, b, collision) then return end
    Player:beginContact(a, b, collision)
end

function endContact(a, b, collision)
    Player:endContact(a, b, collision)
end

function love.load()

    World = love.physics.newWorld(0, 0)
    World:setCallbacks(beginContact, endContact)

    Map = STI("map/1.lua", {"box2d"})
    Map: box2d_init(World)
    Map.layers.solid.visible = false

    SCREEN_WIDTH = love.graphics.getWidth()
    SCREEN_HEIGHT = love.graphics.getHeight()

    Player:load()
    GUI:load()

    platforms = {}

    --coins
    Coin.new(150, 150, world)
    Coin.new(200, 150, world)
    Coin.new(250, 150, world)
end

function love.update(dt)
    World:update(dt)
    Player:update(dt)
    Coin.updateAll(dt)
    GUI:update(dt)
end

function love.keypressed(key, scancode, isrepeat)
    if key == "r" then
        love.event.quit("restart")
    end

    Player:jump(key)
end 

function love.draw()   
    
    love.graphics.setBackgroundColor(0.6, 0.8, 1)

    Map:draw(0, 0, 2)
    love.graphics.push()
    love.graphics.scale(2, 2)

    Player:draw()
    Coin.drawAll()

    love.graphics.pop()
    GUI:draw()

    love.graphics.setColor(1, 1, 1)
end