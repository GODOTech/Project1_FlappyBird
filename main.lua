-- biblioteca de manejo de resolucion virtual
push = require 'push'

--biblioteca clasica de OOP
Class = require 'class'

--la clase del pajaro
require 'Bird'

require 'Pipe'

require 'PipePair'

--todo el codigo relacionado con el estado de juego y la maquina de estados
require 'StateMachine'
require 'states/BaseState'
require 'states/PlayState'
require 'states/TitleScreenState'

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

--[[
--The Bird is the word!
local bird = Bird()

--nuestra tabla de brotar tubos
local pipePairs = {}

--nuestro timer para hacer aparecer los tubos
local spawnTimer = 0

local lastY = -PIPE_HEIGHT + math.random(80) + 20
]]

local scrolling = true

function love.load()
    --iniciar el filtro de vecino cercano
    love.graphics.setDefaultFilter('nearest', 'nearest')
    
    -- titulo de la ventana
    love.window.setTitle('Flipin` Bird')
    
--inicializar nuestra fuente retro
smallFont = love.graphics.newFont('font.ttf', 8)
mediumFont = love.graphics.newFont('flappy.ttf', 14)
flappyFont = love.graphics.newFont('flappy.ttf', 28)
hugeFont = love.graphics.newFont('flappy.ttf', 56)
love.graphics.setFont(flappyFont)


    --iniciar resolucion virtual
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })


    --inicializar la maquina de estados con todas las funciones que devuelven estados
    gStateMachine = StateMachine {
        ['title'] = function () return TitleScreenState() end,
        ['play'] = function () return PlayState() end
    }
    gStateMachine:change('title')

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
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
    
    --panear el suelo por la velocidad * dt, bucleando a 0 despues de el ancho de pantalla
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % GROUND_LOOPING_POINT
    
    --ahora actualizamos la maquina de estados, que deriva al estado correcto
    gStateMachine:update(dt)

    --reiniciar la tabla de inputs
    love.keyboard.keysPressed = {}
end
    

function love.draw()
    push:start()
    
    --dibujar la maquina de estados entre el fondo y el piso,
    --que deriva la logica al estado activo
    love.graphics.draw(background, -backgroundScroll, 0)
    gStateMachine:render()
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    push:finish()
end