-- biblioteca de manejo de resolucion virtual
push = require 'push'

--biblioteca clasica de OOP
Class = require 'class'

--la clase del pajaro
require 'Bird'

require 'Pipe'

require 'PipePair'

-- dimensiones de la pantalla fisica
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

--dimensiones de resolucion virtual
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

--cargar imagenes en la memoria, para dibujarlas despues
local background = love.graphics.newImage('background.png')
local backgroundScroll = 0

local ground = love.graphics.newImage('ground.png')
local groundScroll = 0

--velocidad a la cual las imagenes deberian panear, escalado por dt
local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

--punto en el cual debamos loopar el fondo de vuelta a X0
local BACKGROUND_LOOPING_POINT = 413
local GROUND_LOOPING_POINT = 514


--The Bird is the word!
local bird = Bird()

--nuestra tabla de brotar tubos
local pipePairs = {}

--nuestro timer para hacer aparecer los tubos
local spawnTimer = 0

local lastY = -PIPE_HEIGHT + math.random(80) + 20

local scrolling = true

function love.load()
    --iniciar el filtro de vecino cercano
    love.graphics.setDefaultFilter('nearest', 'nearest')
    
    -- titulo de la ventana
    love.window.setTitle('Flipin` Bird')
    
    --iniciar resolucion virtual
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    --inicializar la tabla de inputs
    love.keyboard.keysPressed = {} 
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    -- añadir a nuestra tabla de teclas presionadas este cuadro
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end

--[[
    nueva funcion usada para checkear los inputs globales de teclas activadas durante
    este cuadro, buscadas por su valor de string.
]]

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.update(dt)
    if scrolling then    
        --panear fondo por la velocidad * dt, bucleando a 0 despues del punto de bucle 
        backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt)
            % BACKGROUND_LOOPING_POINT
    
        --panear el suelo por la velocidad * dt, bucleando a 0 despues de el ancho de pantalla
        groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt)
            % GROUND_LOOPING_POINT
    
        spawnTimer = spawnTimer + dt
    
        --hacer aparecer un nuevo tubo si el timer se pasa de 2 segundos
        if spawnTimer > 2 then
            --[[
                modificar la  unltima coordenada que pusimos para que las aperturas
                entre los tubos no esten demasiado lejos
                no mas alto que 10 pixeles bajo el borde superior de la pantalla,
                y no mas bajo que la longitud de la brecha (90 pix) de el fondo
            ]]
            local y  = math.max(-PIPE_HEIGHT + 10,
                math.min(lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
            lastY = y
        
            table.insert(pipePairs, PipePair(y))
            print('Añadiendo un nuevo par de tubos!')
            spawnTimer = 0
        end

        bird:update(dt)

        --por cada tubo en la escena...
        for k, pair in pairs(pipePairs) do
            pair:update(dt)

            --checkear si el pajaro colisono con algun tubo
            for l, pipe in pairs(pair.pipes) do
                if bird:collides(pipe) then
                    --pausar el juego para probar la colision
                    scrolling = false
                end
            end

            --si el tubo ya no es visible pasando el borde izquierdo quitarlo de la escena
            if pair.x < -PIPE_WIDTH then
                pair.remove = true                
            end
        end

        --[[
            quitar los tubos marcados
            necesitamos este segundo bucle porque modificar la tabla puesta sin claves
            especificas resultaria en saltear el proximo tubo, devido a que, ya que 
            todas las claves impicitas (indices numericos) son cambiadas despues de la
            eliminacion de una tabla
        ]]
        for k, pair in pairs(pipePairs) do
            if pair.remove then
                table.remove(pipePairs, k)
            end
        end
    end

    --reiniciar la tabla de inputs
    love.keyboard.keysPressed = {}
end
    

function love.draw()
    push:start()
    --[[
        aca dibujamos nuestras imagenes corridas a la izquierda por su punto de bucle;
        eventualmente se revierten de vuelta a 0 una vez pasada cierta distancia; dando la
        sensacion de paneo infinito. elegir un punto de bucleado fluido es clave para generar
        la ilusion de coutinuidad infinita 

    ]]

    --comenzar a dibjar el fondo desde el punto de bucleado negativo
    love.graphics.draw(background, -backgroundScroll, 0)

    --dibujar todos los tubos en nuestra escena
    for k, pair in pairs(pipePairs) do
        pair:render()
    end

    --dibujar el piso sobre el fondo, hacia la parte de abajo de la pantalla
    -- en su punto de bucleado negativo
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    bird:render()

    push:finish()
end