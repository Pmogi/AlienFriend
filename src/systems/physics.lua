Physics = {}

-- direction allows for acceleration/deacceleration
-- 1 is forward, 0 is stopping
function Physics.move(dt, entity, direction)

    -- accelerate
    if (direction == 1) then
        entity.velX = math.min(entity.velMaxX, entity.velX + entity.accel * dt) 
        entity.velY = math.min(entity.velMaxY, entity.velY + entity.accel * dt) 
    
        -- deaccelerate
    else
        entity.velX = math.max( 0, entity.velX - entity.accel * dt)
        entity.velY = math.max( 0, entity.velY - entity.accel * dt) 
    end
    
    entity.x = entity.x + dt* entity.velX * math.cos( entity.angle )
    entity.y = entity.y + dt* entity.velY * math.sin( entity.angle )
end

-- 1 is CW, -1 is CCW
function Physics.rotate(dt, entity, direction)
    assert(direction == 1 or direction == -1, "Direction must be 1 or -1 in Physics.rotate")
    entity.angle = entity.angle + entity.rotVel * dt * direction
end

return Physics