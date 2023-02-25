-- biblioteca de manejo de resolucion virtual
push = require 'push'

--biblioteca clasica de OOP
Class = require 'class'

--la clase del pajaro
require 'Bird'

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

--The Bird is the word!
local bird = Bird()

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
    --panear fondo por la velocidad * dt, bucleando a 0 despues del punto de bucle 
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt)
        %BACKGROUND_LOOPING_POINT
    
    --panear el suelo por la velocidad * dt, bucleando a 0 despues de el ancho de pantalla
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt)
        % VIRTUAL_WIDTH

    bird:update(dt)

    --reiniciar la tabla de inputs
    love.keyboard.keysPressed = {}
end
    

function love.draw()
    push:start()
    --[[aca dibujamos nuestras imagenes corridas a la izquierda por su punto de bucle;
    eventualmente se revierten de vuelta a 0 una vez pasada cierta distancia; dando la
    sensacion de paneo infinito. elegir un punto de bucleado fluido es clave para generar
    la ilusion de coutinuidad infinita 

    ]]

    --comenzar a dibjar el fondo desde el punto de bucleado negativo
    love.graphics.draw(background, -backgroundScroll, 0)

    --dibujar el piso sobre el fondo, hacia la parte de abajo de la pantalla
    -- en su punto de bucleado negativo
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    bird:render()

    push:finish()
end