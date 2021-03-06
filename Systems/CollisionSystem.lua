local System = require "Base/System"

local Components = require "Components/ComponentList"
local Translation = Components.Translation
local BoxCollision = Components.BoxCollision
local PlayerControl = Components.PlayerControl

local DataStructures = require "Utility/DataStructures"
local Set = DataStructures.Set

local CollisionSystem = System:newChildClass('CollisionSystem', {Components.BoxCollision, Components.Translation})

function CollisionSystem:update(dt)
  local entityList = self:getRegisteredEntities()
  for i = 1, #entityList do
    entityList[i]:getComponent(Components.BoxCollision).collisionSet = Set:new()
  end
  for i = 1, #entityList do
    local entity1 = entityList[i]
    local translation1, boxCollision1 = entity1:getComponents(Translation, BoxCollision)
    local boundingBox1 = generateBoundingBox(translation1, boxCollision1)
    for j = i + 1, #entityList do
      local entity2 = entityList[j]
      local translation2, boxCollision2 = entity2:getComponents(Translation, BoxCollision)
      local boundingBox2 = generateBoundingBox(translation2, boxCollision2)

      local isCollision = checkBoxCollision(boundingBox1, boundingBox2)
      if isCollision then
        boxCollision1.collisionSet:add(entity2)
        boxCollision2.collisionSet:add(entity1)
      end
    end
  end
end

function generateBoundingBox(translationComponent, collisionComponent)
  return {
    x = translationComponent.x + collisionComponent.x,
    y = translationComponent.y + collisionComponent.y,
    width = collisionComponent.width,
    height = collisionComponent.height,
    }
end

function checkBoxCollision(box1, box2)
  return box1.x < box2.x + box2.width
     and box1.x + box1.width > box2.x
     and box1.y < box2.y + box2.height
     and box1.y + box1.height > box2.y
end

return CollisionSystem
