require "Player"
require("coin")

function beginContact(a, b, collision)
    Player:beginContact(a, b, collision)
    if Coin.beginContact(a, b, collision) then return end
end

function endContact(a, b, collision)
    Player:endContact(a, b, collision)
end


function newPlatform(x, y, w, h) 
    local platform = {
        x = x,
        y = y,
        w = w,
        h = h,
        tag = "platform",

        body = love.physics.newBody(World, x, y, "static"),
        shape = love.physics.newRectangleShape(w/2, h/2, w, h),
    }

    platform.fixture = love.physics.newFixture(platform.body, platform.shape)
    platform.fixture:setUserData(platform)
    table.insert(platforms, platform)
end

function love.load()

    World = love.physics.newWorld(0, 0)
    World:setCallbacks(beginContact, endContact)

    SCREEN_WIDTH = 1280
    SCREEN_HEIGHT = 720

    love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT,  {fullscreen=false, vsync=true})
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
    World:update(dt)
    Player:update(dt)
    Coin.updateAll(dt)
end

function love.keypressed(key, scancode, isrepeat)
    if key == "r" then
        love.event.quit("restart")
    end

    Player:jump(key)
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