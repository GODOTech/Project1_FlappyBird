ScoreState = Class{__includes = BaseState}

--cuando entramos al ScoreState, esperamos recibir el puntaje desde
--PlayState para saber que dibujar

function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(dt)
    -- volver a play si se presiona enter
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    -- simplemente renderizar los puntos en medio de la pantalla
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Uy! Perdiste!', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Puntaje: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')
    
    love.graphics.printf('Enter para reintentar!', 0, 160, VIRTUAL_WIDTH, 'center')
end