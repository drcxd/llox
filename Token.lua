local TokenType = require("TokenType")
local utils = require("utils")

--- @class Token
--- @field type TokenType
--- @field lexeme string
--- @field literal table?
--- @field line number
local Token = {}
Token.__index = Token

--- @param type TokenType
--- @param lexeme string
--- @param literal table?
--- @param line number
--- @return Token
Token.new = function (type, lexeme, literal, line)
   --- @type Token
   local o = {
      type = type,
      lexeme = lexeme,
      literal = literal,
      line = line,
   }
   setmetatable(o, Token)
   return o
end

function Token:toString()
   return string.format("Type: %s Lexeme: %s Literal: %s",
                        utils.EnumValueToName(self.type, TokenType),
                        self.lexeme,
                        self.literal)
end

return Token
