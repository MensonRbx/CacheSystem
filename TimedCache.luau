local BASE_LIFETIME = 60

local TimedCache = {}
TimedCache.__index = TimedCache 

type self = {
        name: string,
        itemLifetime: number,
        _items: {[any]: any},
        _times: {[any]: {
                lifetime: number,
                timeLeft: number
        }}
}

export type TimedCache = typeof(setmetatable({} :: self, TimedCache))

function TimedCache.__tostring(self: TimedCache): string
        local str = ""
        for i, v in self._items do
                str = str .. `{tostring(i)}: {tostring(v)}, `
        end
        return str:sub(1, str:len()-2)
end

local function deleteEntryAfterWaitAsync(self: TimedCache, key: any)
        local times = self._times[key]
        while times and times.timeLeft > 0 do
                times.timeLeft -= 1
                task.wait(1)
        end
        self:Remove(key)
end

function TimedCache.Get(self: TimedCache, key: any): any
        local item = self._items[key]
        if item then
                self._times[key].timeLeft = self._times[key].lifetime
                return item
        end
        return nil
end

function TimedCache.Add(self: TimedCache, key: any, value: any, customLifeTime): ()
        local itemTime = customLifeTime or self.itemLifetime
        self._items[key] = value
        self._times[key] = {
                lifetime = itemTime,
                timeLeft = itemTime
        }
        task.spawn(deleteEntryAfterWaitAsync, self, key)
end

function TimedCache.Remove(self: TimedCache, key: any): boolean
        if self._items[key] then
                self._items[key] = nil
                self._times[key] = nil
                return true
        end
        return false
end

local function createTimedCache(name: string, itemLifetime: number?): TimedCache
        return setmetatable({
                name = name,
                itemLifetime = itemLifetime or BASE_LIFETIME,
                _items = {},
                _times = {}
        }, TimedCache)
end

local function isTimedCache(x: any): boolean
        return getmetatable(x) == TimedCache
end

local TimedCacheTable = {
        new = createTimedCache,
        is = isTimedCache
}

table.freeze(TimedCache)
table.freeze(TimedCacheTable)

return TimedCacheTable

