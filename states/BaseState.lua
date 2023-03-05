--[[
    Usado como la clase basica para todos nuestros estados, para que no tengamos que
    definir metodos vacios en cada uno de ellos. StateMachine requiere que cada estado
    tenga un set de 4 metodos ´interfase´ que pueda llamar con confianza,
    asi que heredando de este estado base, nuestras clases ´State´ tendran por lo menos
    versiones vacias de estos metodos, incluso si no los definimos nosotros mismos
    en las clases mismas. 
]]

BaseState = Class{}

function BaseState:init() end
function BaseState:enter() end
function BaseState:exit() end
function BaseState:update(dt) end
function BaseState:render() end