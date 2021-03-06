local System = require "Base/System"

local Components = require "../Components/ComponentList"

local RenderSystem = System:newChildClass('RenderSystem', {Components.Translation, Components.Render})

function RenderSystem:draw()
  local entityList = self:getRegisteredEntities()
  for i = 1, #entityList do
    local renderComponent = entityList[i]:getComponent(Components.Render)
    if renderComponent.isShown then
      local translationComponent = entityList[i]:getComponent(Components.Translation)
      local rectangleComponent = entityList[i]:getComponent(Components.Rectangle)
      if rectangleComponent then
        local fill = isCollidingWithPlayer(entityList[i]:getComponent(Components.BoxCollision))

        love.graphics.rectangle((fill and 'fill') or 'line', translationComponent.x, translationComponent.y, rectangleComponent.width, rectangleComponent.height)
      else
        love.graphics.points(translationComponent.x * 10, translationComponent.y * 10)
      end
    end
  end
end

function isCollidingWithPlayer(collisionComponent)
  if not (collisionComponent and collisionComponent.collisionSet) then return false end
  for entity in collisionComponent.collisionSet:each() do
    if entity:getComponent(Components.PlayerControl) then
      return true
    end
  end
  return false
end

return RenderSystem
