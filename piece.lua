Piece = {
  r,
  c,
  type,
  team,
  spr,
}

function Piece:Create(piece)
  local piece = piece or {}
  setmetatable(piece, self)
  self.__index = self
  board[piece.r][piece.c] = piece
  return piece
end

function Piece:Draw()
  lg.setColor(StringToColor(self.team))
  lg.setFont(chessfont)
  if selection and self.r == selection.r and self.c == selection.c then
    lg.print(self.spr, lm.getX() - tilesize * 0.5, lm.getY() - tilesize * 0.5)
  else
    lg.print(self.spr, (self.c + 3) * tilesize, (self.r + 3) * tilesize)
  end
end

function Piece:Move(r, c)
  if self.team ~= board[r][c].team then
    for i, p in ipairs(pieces) do
      if p == board[r][c] then
        table.remove(pieces, i) -- capture the piece
      end
    end
  end
  self.moved = true
  board[r][c] = self
  board[self.r][self.c] = nil
  board[self.r][self.c] = {}
  self.r, self.c = r, c
  if game.turn == "white" then
    game.turn = "black"
    DrawCard("black")
  else
    game.turn = "white"
    DrawCard("white")
  end
end

function Piece:Check(r, c)
  if game.turn ~= self.team then
    return false
  end
  if board[r][c].team == board[self.r][self.c].team then
    return false
  end
  if self.type == "pawn" then
    if self.team == "white" then
      if self.r - r == 1 and self.c == c and board[r][c].team ~= "black" then
        return true
      end
      if self.r - r == 1 and math.abs(self.c - c) == 1 and board[r][c].team == "black" then -- capturing
        return true
      end
      if not self.moved and self.c == c and self.r - r == 2 then
        for i = 1, self.r - r do
          if board[self.r - i][c].team then
            return false
          end
        end
        return true
      end
    else
      if r - self.r == 1 and self.c == c and board[r][c].team ~= "white" then
        return true
      end
      if r - self.r == 1 and math.abs(self.c - c) == 1 and board[r][c].team == "white" then -- capturing
        return true
      end
      if not self.moved and self.c == c and r - self.r == 2 then
        for i = 1, r - self.r do
          if board[self.r + i][c].team then
            return false
          end
        end
        return true
      end
    end
  elseif self.type == "knight" then
    if (math.abs(self.r - r) == 1 and math.abs(self.c - c) == 2) or (math.abs(self.r - r) == 2 and math.abs(self.c - c) == 1) then
      return true
    end
  elseif self.type == "bishop" then
    if math.abs(self.r - r) == math.abs(self.c - c) then
      for i = 1, math.max(self.r - r - 1, r - self.r - 1) do
        -- northeast
        if c > self.c and r < self.r then
          if board[self.r - i][self.c + i].team then
            return false
          end
        end
        -- northwest
        if c < self.c and r < self.r then
          if board[self.r - i][self.c - i].team then
            return false
          end
        end
        -- southeast
        if c > self.c and r > self.r then
          if board[self.r + i][self.c + i].team then
            return false
          end
        end
        -- southwest
        if c < self.c and r > self.r then
          if board[self.r + i][self.c - i].team then
            return false
          end
        end
      end
      --check final tile
      return true
    end
  elseif self.type == "rook" then
    if self.c == c or self.r == r then
      -- north
      if self.c == c and self.r - r > 0 then
        for i = 1, self.r - r - 1 do
          if board[self.r - i][c].team then
            return false
          end
        end
      end
      -- south
      if self.c == c and r - self.r > 0 then
        for i = 1, r - self.r - 1 do
          if board[self.r + i][c].team then
            return false
          end
        end
      end
      -- east
      if self.r == r and c - self.c > 0 then
        for i = 1, c - self.c - 1 do
          if board[r][self.c + i].team then
            return false
          end
        end
      end
      -- west
      if self.r == r and self.c - c > 0 then
        for i = 1, self.c - c - 1 do
          if board[r][self.c - i].team then
            return false
          end
        end
      end
      return true
    end
  elseif self.type == "queen" then
    if math.abs(self.r - r) == math.abs(self.c - c) then
      for i = 1, math.max(self.r - r - 1, r - self.r - 1) do
        -- northeast
        if c > self.c and r < self.r then
          if board[self.r - i][self.c + i].team then
            return false
          end
        end
        -- northwest
        if c < self.c and r < self.r then
          if board[self.r - i][self.c - i].team then
            return false
          end
        end
        -- southeast
        if c > self.c and r > self.r then
          if board[self.r + i][self.c + i].team then
            return false
          end
        end
        -- southwest
        if c < self.c and r > self.r then
          if board[self.r + i][self.c - i].team then
            return false
          end
        end
      end
      return true -- final tile
    end
    if self.c == c or self.r == r then
      -- north
      if self.c == c and self.r - r > 0 then
        for i = 1, self.r - r - 1 do
          if board[self.r - i][c].team then
            return false
          end
        end
      end
      -- south
      if self.c == c and r - self.r > 0 then
        for i = 1, r - self.r - 1 do
          if board[self.r + i][c].team then
            return false
          end
        end
      end
      -- east
      if self.r == r and c - self.c > 0 then
        for i = 1, c - self.c - 1 do
          if board[r][self.c + i].team then
            return false
          end
        end
      end
      -- west
      if self.r == r and self.c - c > 0 then
        for i = 1, self.c - c - 1 do
          if board[r][self.c - i].team then
            return false
          end
        end
      end
      return true
    end
  elseif self.type == "king" then
    if math.abs(self.r - r) <= 1 and math.abs(self.c - c) <= 1 then
      return true
    end
  end
  return false
end
