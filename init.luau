local Cache = require(script:WaitForChild("Cache"))
local TimedCache = require(script:WaitForChild("TimedCache"))

export type Cache = Cache.Cache
export type TimedCache = TimedCache.TimedCache

type GeneralCache = Cache | TimedCache

local CacheSystem = {
        caches = {}
}

export type CacheSystem = typeof(CacheSystem)

function CacheSystem:CreateCache(name: string): Cache
        if CacheSystem.caches[name] then
                error(`Error when creating new cache: Cache with name {name} already exists!`)
        end
        local newCache = Cache.new(name) 
        return newCache
end

function CacheSystem:CreateTimedCache(name: string, lifetime: number?): TimedCache
        if CacheSystem.caches[name] then
                error(`Error when creating new cache: Cache with name {name} already exists!`)
        end
        local newCache = TimedCache.new(name, lifetime) 
        return newCache
end

function CacheSystem:GetCache(name: string): GeneralCache?
        return CacheSystem.caches[name]
end

function CacheSystem:DeleteCache(name: string): boolean
        local cache = CacheSystem.caches[name]
        if cache then
                cache:Destroy()
                CacheSystem.caches[name] = nil
                return true
        end
        return false
end

return CacheSystem

