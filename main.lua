maps = require 'maps'
local LightWorld = require "lib"
local anim8 = require 'lib.anim8'


function love.load()
    -- maps.load("maps/countryside.map")
    maps.load("maps/resto.map")
    -- maps.load("maps/lab.map")



     x, y, z, scale = 0, 0, 10, 1
    -- create light world
    lightWorld = LightWorld({
        ambient = {155,155,155},
        refractionStrength = 32.0,
        reflectionVisibility = 0.75,
    })

    -- create light
    lightMouse = lightWorld:newLight(0, 0, 255, 127, 63, 300)
    lightMouse:setGlowStrength(0.3)
    lightMouse.normalInvert = true

end


function love.update()
    lightWorld:update(dt)
    lightMouse:setPosition((love.mouse.getX() - x)/scale, (love.mouse.getY() - y)/scale, z)
end

function love.draw()

    lightWorld:draw(function()
      love.graphics.setColor(255, 255, 255)
      -- love.graphics.rectangle("fill", -x/scale, -y/scale, love.graphics.getWidth()/scale, love.graphics.getHeight()/scale)
      maps.draw()
    end)

end
