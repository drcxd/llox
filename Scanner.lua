local TokenType = require("TokenType")
local Token = require("Token")

--- @class Scanner
--- @field source string
--- @field tokens Token[]
--- @field start number
--- @field current number
--- @field line number
local Scanner = {}
Scanner.__index = Scanner

--- @param code string
--- @return Scanner
Scanner.new = function (code)
   --- @type Scanner
   local o = {
      source = code,
      tokens = {},
      start = 0,
      current = 0,
      line = 1,
   }
   setmetatable(o, Scanner)
   return o
end

--- @return Token[]
function Scanner:scanTokens()
   while not self:isAtEnd() do
      self.start = self.current
      self:scanToken()
   end

   table.insert(self.tokens, Token.new(TokenType.EOF, "", nil, self.line))
   return self.tokens
end

--- @return boolean
function Scanner:isAtEnd()
   return self.current >= string.len(self.source)
end

--- @type table<string, TokenType>
local charToTokenType = {
   ["("] = TokenType.LEFT_PAREN,
   [")"] = TokenType.RIGHT_PAREN,
   ["{"] = TokenType.LEFT_BRACE,
   ["}"] = TokenType.RIGHT_BRACE,
   [","] = TokenType.COMMA,
   ["."] = TokenType.DOT,
   ["-"] = TokenType.MINUS,
   ["+"] = TokenType.PLUS,
   [";"] = TokenType.SEMICOLON,
   ["*"] = TokenType.STAR,
}

function Scanner:scanToken()
   local c = self:advance()
   local tokenType = charToTokenType[c]
   if tokenType then
      self:addToken(tokenType)
   end
end

--- @return string
function Scanner:advance()
   local ret = self.source[self.current]
   self.current = self.current + 1
   return ret
end

--- @param type TokenType
--- @param literal table?
function Scanner:addToken(type, literal)
   local text = string.sub(self.source, self.start, self.current)
   table.insert(self.tokens, Token.new(type, text, literal, self.line))
end

return Scanner
