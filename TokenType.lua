local utils = require("utils")

local g = function ()
   return utils.GenerateNextEnumValue("TokenType")
end

--- @enum TokenType
local TokenType = {
   -- Single-character tokens.
   LEFT_PAREN = g(), RIGHT_PAREN = g(), LEFT_BRACE = g(),
   RIGHT_BRACE = g(), COMMA = g(), DOT = g(), MINUS = g(), PLUS = g(),
   SEMICOLON = g(), SLASH = g(), STAR = g(),

   -- One or two character tokens.
   BANG = g(), BANG_EQUAL = g(),
   EQUAL = g(), EQUAL_EQUAL = g(),
   GREATER = g(), GREATER_EQUAL = g(),
   LESS = g(), LESS_EQUAL = g(),

   -- Literals.
   IDENTIFIER = g(), STRING = g(), NUMBER = g(),

   -- Keywords.
   AND = g(), CLASS = g(), ELSE = g(), FALSE = g(), FUN = g(),
   FOR = g(), IF = g(), NIL = g(), OR = g(), PRINT = g(),
   RETURN = g(), SUPER = g(), THIS = g(), TRUE = g(), VAR = g(),
   WHILE = g(),

   EOF = g(),
}

return TokenType
