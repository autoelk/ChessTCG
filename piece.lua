Piece = {
  r,
  c,
  name,
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
  if self.team == 1 then lg.setColor(colors.black) else lg.setColor(colors.white) end
  lg.rectangle("fill", self.c * tilesize + tilesize * 3, self.r * tilesize + tilesize * 3, tilesize, tilesize, 10)
end

function Piece:Move(r, c)
  board[r][c] = self
  board[self.r][self.c] = nil
  board[self.r][self.c] = {}
  self.r, self.c = r, c
end
