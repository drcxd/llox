local TokenType = require("TokenType")

--- @class Token
--- @field type TokenType
--- @field lexeme string
--- @field table leteral
--- @field line number
local Token = {}

--- @param token Token
Token.toString = function (token)
end

return Token
