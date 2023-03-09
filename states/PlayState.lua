--[[
    La clase 'PlayState' es el bulto de juego, donde el jugado efectivamente
    controla el pajarito y esquiva los tubos; Cuando el jugador coliciona con
    uno, deveriamos ir a el estado 'GameOver',
     desde donde vamos al menu principal
]]

PlayState = Class{__includes = BaseState}

PIPE_SPEED = 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

function PlayState:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.timer = 0

    self.score = 0

    --inicializar nuestra coordenada Y grabada para basar las demas brechas
    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)
    --actualizar el timer para la brotacion de tubos
    self.timer = self.timer + dt

    --brotar un tubo cada segundo y medio
    if self.timer > 2 then
        --modificar la ultima coordenada Y que pusimos, para que la brecha entre tubos no sea demasiado grande
        --no mas alto que 10 pixeles por debajo de el borde superior de la pantalla
        --y no mas abajo que una longitud de brecha (90 px) del fondo
        local y = math.max(-PIPE_HEIGHT + 10,
            math.min(self.lastY+ math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
        self.lastY = y

        --añadir un nuevo par de tubos al final de la pantalla en nuestra nueva Y
        table.insert(self.pipePairs, PipePair(y))

        self.timer = 0
    end

    --Para cada par de tubos...
    for k, pair in pairs(self.pipePairs) do
        --marcar un punto si el tubo ha pasado del pajaro a la izquierda
        --e ignorarlo si ya ha sido marcado
        if not pair.scored then
            if pair.x + PIPE_WIDTH < self.bird.x then
                self.score = self.score + 1
                pair.scored = true
                sounds['score']:play()
            end
        end
        --actualizar Posicion del par
        pair:update(dt)
    end
    
    --necesitams este segundo bucle, en vez de borrar el bucle anterior, porque
    --modificar la table puesta sin claves expicitas resultaria en saltear el suiguiente
    --tubo, devido a que todas las claves impicitas (indices numericos) son cambiados
    --automaticamente despues de la remocion de una tabla
    for k, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end 

    --actualizar el pajarito con base en la gravedad y el input
    self.bird:update(dt)

    --colision simple entre  el pajarito y todos los tubos dentro de 'pairs'
    for k, pair in pairs(self.pipePairs) do
        for l, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                sounds['explosion']: play()
                sounds['hurt']:play()

                gStateMachine:change('score',{
                    score = self.score
                })
            end
        end
    end
    -- resetear si caemos al piso
    if self.bird.y > VIRTUAL_HEIGHT -15 then
        sounds['explosion']: play()
        sounds['hurt']:play()
        
        gStateMachine:change('score', {
            score = self.score
        })
    end
end

function PlayState:render()
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end
    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)

    self.bird:render()
end