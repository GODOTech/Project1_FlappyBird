Pipe = Class{}

local PIPE_IMAGE = love.graphics.newImage('pipe.png')

local PIPE_SCROLL = -60

function Pipe:init()
    self.x = VIRTUAL_WIDTH
    
    --poner el valor Y a un random abajo de la pantalla 
    self.y = math.random(VIRTUAL_HEIGHT / 4, VIRTUAL_HEIGHT - 10)

    self.width = PIPE_IMAGE:getWidth()
end

function Pipe:update(dt)
    self.x = self.x + PIPE_SCROLL * dt
end

function Pipe:render(dt)
    love.graphics.draw(PIPE_IMAGE, math.floor(self.x + 0.5), math.floor(self.y))
end