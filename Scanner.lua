local TokenType = require("TokenType")
local Token = require("Token")
local Error = require("Error")

local keywords =
   {
      ["and"] = TokenType.AND,
      ["class"] = TokenType.CLASS,
      ["else"] = TokenType.ELSE,
      ["false"] = TokenType.FALSE,
      ["for"] = TokenType.FOR,
      ["fun"] = TokenType.FUN,
      ["if"] = TokenType.IF,
      ["nil"] = TokenType.NIL,
      ["or"] = TokenType.OR,
      ["print"] = TokenType.PRINT,
      ["return"] = TokenType.RETURN,
      ["super"] = TokenType.SUPER,
      ["this"] = TokenType.THIS,
      ["true"] = TokenType.TRUE,
      ["var"] = TokenType.VAR,
      ["while"] = TokenType.WHILE,
   }

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
      start = 1,
      current = 1,
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
local oneCharToken = {
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

local oneOrTwoCharToken =
   {
      ["!"] = { "=", TokenType.BANG_EQUAL, TokenType.BANG },
      ["="] = { "=", TokenType.EQUAL_EQUAL, TokenType.EQUAL },
      ["<"] = { "=", TokenType.LESS_EQUAL, TokenType.LESS },
      [">"] = { "=", TokenType.GREATER_EQUAL, TokenType.GREATER },
   }

local whiteSpaces =
   {
      [" "] = 1,
      ["\r"] = 1,
      ["\t"] = 1,
      ["\n"] = 1,
   }

function Scanner:scanToken()
   local c = self:advance()
   if oneCharToken[c] then
      self:addToken(oneCharToken[c])
   elseif oneOrTwoCharToken[c] then
      local auxData = oneOrTwoCharToken[c]
      local nextChar = auxData[1]
      local twoCharsTokenType = auxData[2]
      local oneCharTokenType = auxData[3]
      self:addToken(self:match(nextChar) and twoCharsTokenType or oneCharTokenType)
   elseif c == "/" then
      if self:match("/") then
         while (self:peek() ~= "\n" and not self:isAtEnd()) do
            self:advance()
         end
      else
         self:addToken(TokenType.SLASH)
      end
   elseif whiteSpaces[c] then
      if whiteSpaces[c] == "\n" then
         self.line = self.line + 1
      end
   elseif c == '"' then
      self:string()
   else
      if self:isDigit(c) then
         self:number()
      elseif self:isAlpha(c) then
         self:identifier()
      else
         Error.error(self.line, "Unexpected character.")
      end
   end
end

--- @return string
function Scanner:advance()
   local ret = self.source:sub(self.current, self.current)
   self.current = self.current + 1
   return ret
end

--- @param type TokenType
function Scanner:addToken(type, literal)
   local text = string.sub(self.source, self.start, self.current - 1)
   table.insert(self.tokens, Token.new(type, text, literal, self.line))
end

--- @param expected string
--- @return boolean
function Scanner:match(expected)
   if self:isAtEnd() then
      return false
   end
   if self.source:sub(self.current, self.current) ~= expected then
      return false
   end
   self.current = self.current + 1
   return true
end

--- @return string
function Scanner:peek()
   if (self:isAtEnd()) then
      return ""
   end
   return self.source:sub(self.current, self.current)
end

function Scanner:string()
   while self:peek() ~= '"' and not self:isAtEnd() do
      if self:peek() == "\n" then
         self.line = self.line + 1
      end
      self:advance()
   end
   if self:isAtEnd() then
      Error.error(self.line, "Unterminated string.")
      return
   end

   self:advance()

   local value = self.source:sub(self.start + 1, self.current - 2)
   self:addToken(TokenType.STRING, value)
end

--- @param char string
--- @return boolean
function Scanner:isDigit(char)
   local byte = string.byte(char)
   if byte then
      return string.byte("0") <= byte and byte <= string.byte("9")
   end
   return false
end

function Scanner:number()
   while self:isDigit(self:peek()) do
      self:advance()
   end

   -- Look for a fractional part.
   if self:peek() == "." and self:isDigit(self:peekNext()) then
      -- Consume the "."
      self:advance()

      while self:isDigit(self:peek()) do
         self:advance()
      end

      self:addToken(TokenType.NUMBER, tonumber(self.source:sub(self.start, self.current)))
   end
end

function Scanner:peekNext()
   if self.current + 1 >= string.len(self.source) then
      return ""
   end
   local idx = self.current + 1
   return self.source:sub(idx, idx)
end

function Scanner:identifier()
   while self:isAlphaNumeric(self:peek()) do
      self:advance()
   end
   local text = self.source:sub(self.start, self.current)
   local type = keywords[text] or TokenType.IDENTIFIER
   self:addToken(type)
end

--- @param char string
function Scanner:isAlpha(char)
   local byte = string.byte(char)
   if byte then
      return (string.byte("a") <= byte and byte <= string.byte("z")) or
         (string.byte("A") <= byte and byte <= string.byte("Z")) or
         byte == string.byte("_")
   end
   return false
end

--- @param char string
function Scanner:isAlphaNumeric(char)
   return self:isAlpha(char) or self:isDigit(char)
end

return Scanner
