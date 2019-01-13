Piece = {
  r,
  c,
  type,
  team,
}

function Piece:Create(piece)
  local piece = piece or {}
  setmetatable(piece, self)
  self.__index = self
  board[piece.r][piece.c] = piece
  return piece
end

function Piece:Draw()
  if self.team == "white" then lg.setColor(colors.white) else lg.setColor(colors.black) end
  if selection and self.r == selection.r and self.c == selection.c then
    lg.print(self.type:sub(1, 1), lm.getX() - tilesize / 2, lm.getY() - tilesize / 2) --useless
  else
    lg.print(self.type:sub(1, 1), (self.c + 3) * tilesize, (self.r + 3) * tilesize)
  end
end

function Piece:Move(r, c)
  self.moved = true
  board[r][c] = self
  board[self.r][self.c] = nil
  board[self.r][self.c] = {}
  self.r, self.c = r, c
end

function Piece:Check(r, c)
  if board[r][c].team == board[self.r][self.c].team then
    return false
  end
  if self.type == "pawn" then
    if self.team == "white" then
      if not self.moved and self.r - r == 2 and self.c == c then
        return true
      end
      if self.r - r == 1 and self.c == c then
        return true
      end
    else
      if not self.moved and self.r - r == -2 and self.c == c then
        return true
      end
      if self.r - r == -1 and self.c == c then
        return true
      end
    end
  elseif self.type == "night" then
    if (math.abs(self.r - r) == 1 and math.abs(self.c - c) == 2) or (math.abs(self.r - r) == 2 and math.abs(self.c - c) == 1) then
      return true
    end
  elseif self.type == "bishop" then
  elseif self.type == "rook" then
  elseif self.type == "queen" then
  elseif self.type == "king" then
  end
  return false
end
