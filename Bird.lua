
Bird = Class{}

local GRAVITY = 20

function Bird:init()
    -- cargar la imagen del disco y asignar su ancho y alto
    self.image = love.graphics.newImage('bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    --poscicionar al pajaro en medio de la pantalla
    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)

    --Velocidad en Y; Gravedad
    self.dy = 0
end

--[[
    Colision AABB que espera un tubo, el cual  tendra una referencia X e Y
    y referencia global del tubo ancho y largo.
]]

function Bird:collides(pipe)
    -- los 2´s son la tolerancia izquierda y arriba
    -- los 4´s son la tolerancia derecha y abajo
    -- ambos se utilizan para darle un minimo de consideracion al jugador
    if (self.x + 2) + (self.width -4 ) >= pipe.x and self.x +2 <= pipe.x +PIPE_WIDTH then
        if (self.y +2) + (self.height - 4) >= pipe.y and self.y + 2 <= pipe.y +PIPE_HEIGHT then
            return true
        end
        
    end
    
    return false
end
function Bird:update(dt)
    --aplicar gravedad a la velocidad
    self.dy = self.dy + GRAVITY * dt

    -- añadir una subita rafaga de gravedad negativa si tocamos espacio
    if love.keyboard.wasPressed('space') then
        self.dy = -5
        sounds['jump']:play()
    end

    --aplicar la velocidad actual a la poscicion Y
    self.y = self.y + self.dy
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end