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

return utils
