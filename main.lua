love.graphics.setDefaultFilter("nearest", "nearest")

local STI = require("libraries/sti")
local Player = require("Player")
local Coin = require("coin")
local GUI = require("gui")
local Spike = require("spike")
local Camera = require("camera")
local Stone = require("stone")

function beginContact(a, b, collision)
    if Coin.beginContact(a, b, collision) then return end
    if Spike.beginContact(a, b, collision) then return end

    Player:beginContact(a, b, collision)
end

function endContact(a, b, collision)
    Player:endContact(a, b, collision)
end

function love.load()

    World = love.physics.newWorld(0, 2000)
    World:setCallbacks(beginContact, endContact)

    Map = STI("map/1.lua", {"box2d"})
    Map: box2d_init(World)
    Map.layers.solid.visible = false
    Map.layers.entity.visible = false
    MapWidth = Map.layers.ground.width * 16

    SCREEN_WIDTH = love.graphics.getWidth()
    SCREEN_HEIGHT = love.graphics.getHeight()

    Player:load()
    spawnEntities()
    GUI:load()
end

function love.update(dt)
    World:update(dt)
    Player:update(dt)
    Coin.updateAll(dt)
    Spike.updateAll(dt)
    Stone.updateAll(dt)
    GUI:update(dt)
    Camera:setPosition(Player.x, 0)
end

function love.keypressed(key, scancode, isrepeat)
    if key == "r" then
        love.event.quit("restart")
    end

    Player:jump(key)
end 

function love.draw()   
    
    love.graphics.setBackgroundColor(0.6, 0.8, 1)

    Map:draw(-Camera.x, -Camera.y, Camera.scale)
    Camera:apply()

    Player:draw()
    Coin.drawAll()
    Spike.drawAll()
    Stone.drawAll()

    Camera:clear()

    GUI:draw()

    love.graphics.setColor(1, 1, 1)
end

function spawnEntities()
    for i, v in ipairs(Map.layers.entity.objects) do
        if v.type == "spike" then
            Spike.new(v.x + v.width / 2, v.y + v.height / 2)
        elseif v.type == "stone" then
            Stone.new(v.x + v.width / 2, v.y + v.height / 2)
        elseif v.type == "coin" then
            Coin.new(v.x, v.y)
        end
    end
end