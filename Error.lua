local Error = {}

--- @type boolean
Error.hadError = false

--- @param line number
--- @param where string
--- @param message string
Error.report = function (line, where, message)
   io.stderr:write(string.format("[line %d] Error %s: %s", line, where, message))
   Error.hadError = true
end

--- @param line number
--- @param message string
Error.error = function (line, message)
   Error.report(line, "", message);
end

return Error
