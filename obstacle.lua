Obstacle = {}
Obstacle.__index = Obstacle

function Obstacle:create(points)
    local obstacle = {}
    setmetatable(obstacle, Obstacle)
    obstacle.points = points
    obstacle.visible = false
    obstacle.color = {1, 1, 1}
    return obstacle
end

function Obstacle:getSegments()
    local segments = {}
    for i = 2, #self.points do
        p1 = self.points[i-1]
        p2 = self.points[i]
        table.insert(segments, {p1, p2})
    end
    return segments
end

function Obstacle:draw()
    if self.visible then
        self.color = {1, 0, 0}
    end
    r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(self.color)
    for i = 2, #self.points do
        p1 = self.points[i-1]
        p2 = self.points[i]
        love.graphics.line(p1[1], p1[2], p2[1], p2[2])
    end
    love.graphics.setColor(r, g, b, a)

    self.color = {1, 1, 1}
    self.visible = false
end