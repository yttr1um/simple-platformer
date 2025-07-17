require "Player"
require("coin")

local PIXEL_PER_METER = 50
World = love.physics.newWorld(0, 9.81 * PIXEL_PER_METER)

function beginContact(a, b, contact)

    if Coin.beginContact(a, b, contact) then return end

    local obj1, obj2 = a:getUserData(), b:getUserData()
    player.contactPlatform(obj1, obj2)
end

function endContact(a, b, contact)
    local obj1, obj2 = a:getUserData(), b:getUserData()
    player.contactPlatform(obj1, obj2)
end

world:setCallbacks(beginContact, endContact)


function newPlatform(x, y, w, h) 
    local platform = {
        x = x,
        y = y,
        w = w,
        h = h,
        tag = "platform",

        body = love.physics.newBody(world, x, y, "static"),
        shape = love.physics.newRectangleShape(w/2, h/2, w, h),
    }

    platform.fixture = love.physics.newFixture(platform.body, platform.shape)
    platform.fixture:setUserData(platform)
    table.insert(platforms, platform)
end

function love.load()
    SCREEN_WIDTH = 1280
    SCREEN_HEIGHT = 720

    love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT,  {fullscreen=false, vsync=true})

    player = Player(world)
    Player:load()

    platforms = {}

    -- platforms
    newPlatform(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50) 
    newPlatform(200, SCREEN_HEIGHT-100, 200, 50)
    newPlatform(450, 545, 400, 30)

    --coins
    Coin.new(550, 520, world)
    Coin.new(650, 520, world)
    Coin.new(750, 520, world)
end

function love.update(dt)
    world:update(dt)
    Player:update(dt)
    Coin.updateAll(dt)
    player:move()
end

function love.keypressed(key, scancode, isrepeat)
    if key == "r" then
        love.event.quit("restart")
    end
end

function love.draw()    
    for i = 1, #platforms do
        local p = platforms[i]
        love.graphics.setColor(0.2, 0.6, 1)
        love.graphics.rectangle("fill", p.x, p.y, p.w, p.h)
    end

    Player:draw()
    Coin.drawAll()

    love.graphics.setBackgroundColor(0.6, 0.8, 1)

    love.graphics.setColor(1, 1, 1)
end