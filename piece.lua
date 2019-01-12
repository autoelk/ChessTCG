Piece = {
  r,
  c,
  type,
  spr,
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
    lg.circle("fill", lm.getX(), lm.getY(), tilesize / 2)
  else
    lg.circle("fill", (self.c + 7 / 2) * tilesize, (self.r + 7 / 2) * tilesize, tilesize / 2)
  end
end

function Piece:Move(r, c)
  board[r][c] = self
  board[self.r][self.c] = nil
  board[self.r][self.c] = {}
  self.r, self.c = r, c
end

function Piece:Check(r, c)
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
  elseif self.type == "knight" then
  elseif self.type == "bishop" then
  elseif self.type == "rook" then
  elseif self.type == "queen" then
  elseif self.type == "king" then
  end
  return false
end
