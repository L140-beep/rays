Ray = {}
Ray.__index = Ray

function Ray:create(origin)
    local ray = {}
    setmetatable(ray, Ray)
    ray.origin = origin
    ray.to = origin
    ray.intersections = {}
    ray.closest = nil
    return ray
end

function Ray:castTo(to, obstacles)
    self.to = to
    local intersects = {}
    self.closest = nil
    local closest_obstacle = nil
    for i=1, #obstacles do
        local segments = obstacles[i]:getSegments()

        for j=1, #segments do
            local intersect = self:intersection(segments[j])

            if(intersect ~= nil) then
                if(self.closest == nil) then
                    self.closest = intersect
                    closest_obstacle = obstacles[i]
                else
                    if (intersect.t1 < self.closest.t1) then
                        closest_obstacle = obstacles[i]
                        self.closest = intersect
                    end
                end
            end
        end
    end
    if closest_obstacle ~= nil then
        
        closest_obstacle.visible = true
    end

    self.intersections = intersects
end

function Ray:draw()
    r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(0, 1, 0)
    love.graphics.line(self.origin[1], self.origin[2], 
                        self.to[1], self.to[2])
    love.graphics.setColor(r, g, b, a)

    if (self.closest ~= nil) then
        love.graphics.line(self.origin[1], self.origin[2], self.closest.x, self.closest.y)
    end

    for i=1, #self.intersections do
        local inter = self.intersections[i]
        love.graphics.circle("fill", inter.x, inter.y, 5)
    end
end

function Ray:intersection(segment)
    local rpx = self.origin[1]
    local rpy = self.origin[2]
    local rdx = self.to[1] - rpx
    local rdy = self.to[2] - rpy

    local spx = segment[1][1]
    local spy = segment[1][2]
    local sdx = segment[2][1] - spx
    local sdy = segment[2][2] - spy

    local rmag = math.sqrt(rdx * rdx + rdy * rdy)
    local smag = math.sqrt(sdx * sdx + sdy * sdy)

    if ((rdx / rmag == sdx/smag) and (rdy / rmag == sdy / smag)) then
        return nil
    end

    local t2 = (rdx * (spy - rpy) + rdy * (rpx - spx)) / (sdx * rdy - sdy * rdx)
    local t1 = (spx + sdx * t2 - rpx) / rdx

    if (t1 < 0) then
        return nil
    end
    if (t2 < 0 or t2 > 1) then
        return nil
    end

    local x = rpx + rdx * t1
    local y = rpy + rdy * t1

    return {x = x, y = y, t1 = t1}
end