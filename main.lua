function newWall(x, y, w, h) 
    local wall = {
        x = x,
        y = y,
        w = w,
        h = h,
        tag = "wall",

        body = love.physics.newBody(world, x, y, "static"),
        shape = love.physics.newRectangleShape(w/2, h/2, w, h),
    }

    wall.fixture = love.physics.newFixture(wall.body, wall.shape)
    walls.insert(walls, wall)
end

function love.load()
    SCREEN_WIDTH = 1280
    SCREEN_HEIGHT = 720

    love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT,  {fullscreen=false, vsync=true})
end

function love.update(dt)
    
end

function love.draw()

end