local utils = {}

local enumValues = {}

--- @param enum string
--- @return number
utils.GenerateNextEnumValue = function (enum)
   if not enumValues[enum] then
      enumValues[enum] = 1
   end
   local newValue = enumValues[enum]
   enumValues[enum] = enumValues[enum] + 1
   return newValue
end

--- @param value number
--- @param enum table
utils.EnumValueToName = function (value, enum)
   local name
   for k, v in pairs(enum) do
      if value == v then
         name = k
         break
      end
   end
   return name
end

return utils
