-- Cache module
-- TimedCache and Cache code similar but not similar enough to construct
-- inheritance. Will look into other potential methods of setting this
-- up with inheritance or other methods.

local Cache = {}
Cache.__index = Cache

type self = {
        name: string,
        _items: {[any]: any}
}

export type Cache = typeof(setmetatable({} :: self, Cache))

function Cache.__tostring(self: Cache): string
        local str = ""
        for i, v in self._items do
                str = str .. `{tostring(i)}: {tostring(v)}, `
        end
        return str:sub(1, str:len()-2)
end

function Cache.Add(self: Cache, key: any, value: any): ()
        self._items[key] = value
end

function Cache.Get(self: Cache, key: any): any
        return self._items[key]
end

function Cache.Remove(self: Cache, key: any): boolean
        if self._items[key] then
                self._items[key] = nil
                return true
        else
                return false
        end
end

local function createCache(name: string): Cache
        return setmetatable({
                name = name,
                _items = {}
        }, Cache)
end

local function isCache(x: any): boolean
        return getmetatable(x) == Cache
end

local CacheTable = {
        new = createCache,
        is = isCache
}

table.freeze(Cache)
table.freeze(CacheTable)

return CacheTable

