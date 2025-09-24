local Scanner = {}

local ScannerClass = {}
ScannerClass.__index = ScannerClass

ScannerClass.scanTokens = function (self)
   return { self.code }
end


Scanner.new = function (code)
   local o = {}
   o.code = code
   setmetatable(o, ScannerClass)
   return o
end

return Scanner
