--[[
    los estados son creados solo cuando son necesitados, para ahorrar memoria, reducir
    la limpieza de los bugs e incrementar la velocidad, devido a que la recoleccion de
    basura toma mas tiempo cuando hay mas datos en la memoria

    los estados son añadidos con un string identificatorio y una funcion inicializadora
    se espera que el init de la funcion, cuando se le llama, va a devolver una tabla con
    Render, Update, Enter y Exit como metodos.

    gStateMachine = StateMachine {
        ['MainMenu'] = funcion()
            return MainMenu()
        end,
        ['InnerGame'] = funcion()
            return InnerGame()
        end,
        ['GameOver'] = funcion()
            return GameOver()
        end,
    }
    gStateMachine:change('MainGame')
    
    los argumentos pasados dentro de la funcion Change despues de el nombre del estado
    son avanzados a la funcion Enter del estado al cual se esta siendo cambiado.

    los identificadores de estado deverian tener el mismo nombre que en la tabla state,
    a menos que haya un buen motivo. ej: MainMenu crea un estado usando la tabla MainMenu.
    esto mantiene las cosas simples.

    =Haciendo Tranciciones=
]]

StateMachine = Class{}

function StateMachine:init(states)
    self.empty = {
        render = function () end,
        update = function() end,
        enter = function() end,
        exit = function() end
    }
    self.states = states or {} -- [nombre] -> [funcion que devuelve estados]
    self.current = self.empty
end

function  StateMachine:change(stateName, enterParams)
    assert(self.states[stateName]) --el estado debe esxistir!
    self.current:exit()
    self.current = self.states[stateName]()
    self.current:enter(enterParams)
end

function StateMachine:update(dt)
    self.current:update(dt)
end

function StateMachine:render()
    self.current:render()
end