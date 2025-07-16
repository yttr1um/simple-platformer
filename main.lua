walls = {}

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
    table.insert(walls, wall)
end

function love.load()
    SCREEN_WIDTH = 1280
    SCREEN_HEIGHT = 720

    love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT,  {fullscreen=false, vsync=true})

    world = love.physics.newWorld(0, 0)



    -- walls 
    newWall(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50) --bottom
end

function love.update(dt)
    
end

function love.draw()    
    for i = 1, #walls do
        local w = walls[i]
        love.graphics.setColor(0, 1, 0)
        love.graphics.rectangle("fill", w.x, w.y, w.w, w.h)
    end

    love.graphics.setBackgroundColor(0.6, 0.8, 1)
end