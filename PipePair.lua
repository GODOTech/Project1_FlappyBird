 PipePair = Class{}

 local GAP_HEIGHT = 90

 function PipePair:init(y)
    --inicializar tubos fuera de camara
    self.x = VIRTUAL_WIDTH + 32

    --el valor y es para el tubo de arriba, la apertura es un cambio vertical del segundo tubo
    self.y = y

    -- instanciar dos tubos que pertenecen a este par
    self.pipes = {
        ['upper'] = Pipe('top', self.y),
        ['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + GAP_HEIGHT)
    }

    --si este par de tubos esta listo para ser removido de la escena
    self.remove = false
 end

 function PipePair:update(dt)
    --quitar el par de la escena si esta mas alla de el borde izquierdo
    -- sino moverlo de derecha a izquierda
    if self.x > -PIPE_WIDTH then
        self.x = self.x - PIPE_SPEED * dt
        self.pipes['lower'].x = self.x
        self.pipes['upper'].x = self.x
    else
        self.remove = true
    end
 end

 function PipePair:render()
    for k, pipe in pairs(self.pipes) do
        pipe:render()
    end
 end