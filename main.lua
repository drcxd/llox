local Scanner = require("Scanner")

local run = function (code)
   local scanner = Scanner.new(code)
   local tokens = scanner:scanTokens()

   for _, token in ipairs(tokens) do
      print(token)
   end
end

local runFile = function (path)
   local code = io.open(path, "r"):read("a")
   run(code)
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
