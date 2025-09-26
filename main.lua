local Scanner = require("Scanner")
local Error = require("Error")

--- @param code string
local run = function (code)
   local tokens = Scanner.scanTokens(code)

   for _, token in ipairs(tokens) do
      print(token)
   end
end

--- @param path string
local runFile = function (path)
   local code = io.open(path, "r"):read("a")
   run(code)

   -- Indicate an error in the exit code
   if Error.hadError then
      os.exit(65)
   end
end

local runPrompt = function ()
   while (true) do
      io.stdout:write("> "):flush()
      local line, err = io.stdin:read("l")
      if not line then
         print("ERROR: reading input failed", err)
         break
      end
      run(line)
      Error.hadError = false
   end
end

local main = function ()
   if #arg > 1 then
      print("Usage: lua main.lua [script]")
      os.exit(64)
   elseif #arg == 1 then
      runFile(arg[1])
   else
      runPrompt()
   end
end

main()
