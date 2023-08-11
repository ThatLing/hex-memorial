-- SaitoHUD
-- Copyright (c) 2009-2010 sk89q <http://www.sk89q.com>
-- Copyright (c) 2010 BoJaN
-- 
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 2 of the License, or
-- (at your option) any later version.
-- 
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
-- 
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
-- 
-- $Id$

local subclassVector = CreateClientConVar("geom_subclass_vector", "0", true, false)

local GEOM = {}
SaitoHUD.GEOM = GEOM

GEOM.Points = {}
GEOM.Lines = {}
GEOM.Planes = {}
GEOM.Angles = {}

--- Makes a dynamic vector class that will update its value every tick
-- (if needed). This is used for vectors local to an entity, so that they can
-- stay up to date.
-- @param constructorFunc Function to construct the object with
-- @param updateFunc Function that should return a new Vector or nil
-- @return Class table (with a __call)
function GEOM.MakeDynamicVectorType()
    local v = {}
    local mt = {
        __call = function(t, ...)
            local arg = {...}
            
            local instance = {}
            instance._CachedVector = Vector(0, 0, 0)
            instance._LastUpdate = 0
            instance._Update = function(self)
                if CurTime() - self._LastUpdate ~= 0 then
                    local vec = v.Update(self)
                    if vec then self._CachedVector = vec end
                end
            end
            
            local mt = {}
            mt.__index = function(t, key)
                t:_Update()
                local r = t._CachedVector[key]
                if type(r) == 'function' then
                    return function(self, ...)
                        local arg = {...}
                        return self._CachedVector[key](self._CachedVector, unpack(arg))
                    end
                end
                return r
            end
            mt.__add = function(a, b) return a._CachedVector.__add(a, b) end
            mt.__sub = function(a, b) return a._CachedVector.__sub(a, b) end
            mt.__mul = function(a, b) return a._CachedVector.__mul(a, b) end
            mt.__div = function(a, b) return a._CachedVector.__div(a, b) end
            mt.__mod = function(a, b) return a._CachedVector.__mod(a, b) end
            mt.__pow = function(a, b) return a._CachedVector.__pow(a, b) end
            
            setmetatable(instance, mt)
            
            v.Initialize(instance, unpack(arg))
            return instance
        end
    }
    setmetatable(v, mt)
    return v
end

--- Overrides the Vector object so that dynamic vectors can work seamlessly.
local function OverrideVectorForDynamic()
    if not g_GEOMOrigVector then g_GEOMOrigVector = {} end

    local keys = {
        'Cross', 'Distance', 'Dot', 'DotProduct', '__add', '__sub', '__mul',
        '__div', '__mod', '__pow'
    }

    local vecMt = FindMetaTable("Vector")

    for _, key in pairs(keys) do
        if not g_GEOMOrigVector[key] then
            g_GEOMOrigVector[key] = vecMt[key]
        end
        
        vecMt[key] = function(self, ...)
            local arg = {...}
            if type(self) == 'table' and self._CachedVector then
                self = self._CachedVector
            end
            if type(arg[1]) == 'table' and arg[1]._CachedVector then
                arg[1] = arg[1]._CachedVector
            end
            return g_GEOMOrigVector[key](self, unpack(arg))
        end
    end
    
    MsgN("Vector subclassed for seamless GOEM functionality")
end

GEOM.EntityRelVector = GEOM.MakeDynamicVectorType()

--- Construct a vector that is relative to an entity.
-- @param x
-- @param y
-- @param z
-- @param ent Entity
function GEOM.EntityRelVector:Initialize(x, y, z, ent)
    self.LocalVector = ent:WorldToLocal(Vector(x, y, z))
    self.Entity = ent
end

--- Updates the vector.
-- @return Vector
function GEOM.EntityRelVector:Update()
    if IsValid(self.Entity) then
        return self.Entity:LocalToWorld(self.LocalVector)
    end
end

GEOM.Ray = SaitoHUD.MakeClass()

--- Creates a ray (point and direction).
-- @param 
function GEOM.Ray:Initialize(pt1, pt2)
    self.pt1 = pt1
    self.pt2 = pt2
end

GEOM.Line = SaitoHUD.MakeClass()

--- Creates a line.
-- @param 
function GEOM.Line:Initialize(pt1, pt2)
    self.pt1 = pt1
    self.pt2 = pt2
end

function GEOM.Line:__tostring()
    return tostring(self.pt1) .. " -> " .. tostring(self.pt2)
end

--- Used to get a built-in point.
-- @param key Key
-- @return Vector or nil
function GEOM.GetBuiltInPoint(key)
    key = key:lower()
    if key == "me" then
        return SaitoHUD.GetRefPos()
    elseif key == "trace" then
        local tr = SaitoHUD.GetRefTrace()
        return tr.HitPos
    end
end

--- Used to get a built-in line.
-- @param key Key
-- @return Line or nil
function GEOM.GetBuiltInLine(key)
end

function GEOM.SetPoint(key, v)
    GEOM.Points[key] = v
end

function GEOM.SetLine(key, v)
    GEOM.Lines[key] = v
end

function GEOM.SetPlane(key, v)
    GEOM.Planes[key] = v
end

function GEOM.SetAngle(key, v)
    if type(v) == "Angle" then v = v:Forward() end
    GEOM.Angles[key] = v
end

--- Returns the projection of a point onto a line segment in 3D space.
-- @param line
-- @param point
-- @return Distance
function GEOM.PointLineSegmentProjection(pt, line)
    local a = line.pt1:Distance(line.pt1)^2
    if a == 0 then return line.pt1 end
    local b = (pt - line.pt1):Dot(line.pt2 - line.pt1) / a
    if b < 0 then return line.pt1 end
    if b > 1 then return line.pt2 end
    return line.pt1 + b * (line.pt2 - line.pt1)
end

if subclassVector:GetBool() then
    OverrideVectorForDynamic()
end