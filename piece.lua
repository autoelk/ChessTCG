Piece = {
  r,
  c,
  name,
  spr,
  color,
}

function Piece:Create(piece)
  local piece = piece or {}
  setmetatable(piece, self)
  self.__index = self
  board[piece.r][piece.c] = piece
  return piece
end

function Piece:Draw()
  lg.setColor(self.color)
  lg.rectangle("fill", self.c * tilesize + tilesize * 3, self.r * tilesize + tilesize * 3, tilesize, tilesize, 64)
end

function Piece:Move(r, c)
  board[r][c] = self
  board[self.r][self.c] = nil
  self.r, self.c = r, c
end
