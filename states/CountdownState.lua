--[[
    Hace un conteo regresivo en la pantalla para que el jugador sepa que el juego esta por
    comenzar. Transcisiona al PlayState cuando el conteo concluye.
]]

CountdownState = Class{__includes = BaseState}

--toma un segundo el contar cada vez
COUNTDOWN_TIME = 0.75

function CountdownState:init()
    self.count = 3
    self.timer = 0
end

--[[
    Lleva la cuenta de cuanto tiempo ha pasado y reduce 'count' si 'timer'
    a exedido 'COUNTDOWN_TIME'. si hemos llegado a 0,
    deveriamos transicionar a 'PlayState'
]]

function CountdownState:update(dt)
    self.timer = self.timer + dt

    if self.timer > COUNTDOWN_TIME then
        self.timer = self.timer % COUNTDOWN_TIME
        self.count = self.count - 1

        if self.count == 0 then
            gStateMachine:change('play')
        end
    end
end

function CountdownState:render()
    love.graphics.setFont(hugeFont)
    love.graphics.printf(tostring(self.count), 0, 120, VIRTUAL_WIDTH, 'center')
end