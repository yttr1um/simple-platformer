function Player() 

    _width = 50
    _height = 50


    local player = {
        x = 100,
        y = 200,
        w = _width,
        h = _height,
        tag = "player",
        body = love.physics.newBody(world, 100, 200, "dynamic"),
        shape = love.physics.newRectangleShape(_width/2, _height/2, _width, _height)
    }

    player.fixture = love.physics.newFixture(player.body, player.shape)

    return player
end

return Player