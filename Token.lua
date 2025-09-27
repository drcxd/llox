local TokenType = require("TokenType")
local utils = require("utils")

--- @class Token
--- @field type TokenType
--- @field lexeme string
--- @field literal table
--- @field line number
local Token = {}

--- @param type TokenType
--- @param lexeme string
--- @param literal table?
--- @param line number
--- @return Token
Token.new = function (type, lexeme, literal, line)
   return {
      type = type,
      lexeme = lexeme,
      literal = literal,
      line = line,
   }
end

--- @param token Token
Token.toString = function (token)
   return string.format("%s %s %s",
                        utils.EnumValueToName(token.type, TokenType),
                        token.lexeme,
                        token.literal)
end

return Token
