require "piece"

function love.load(arg)
  math.randomseed(os.time())
  lg = love.graphics
  lk = love.keyboard
  lw = love.window
  lm = love.mouse
  tilesize = 40
  lw.setTitle("ChessTCG")
  lw.setMode(tilesize * 16, tilesize * 16, {borderless = true})
  board = {}
  for r = 1, 8 do
    board[r] = {}
    for c = 1, 8 do
      board[r][c] = {}
    end
  end
  colors = {
    white = {0.9, 0.9, 0.9},
    gray = {0.5, 0.5, 0.5},
    black = {0.1, 0.1, 0.1},
    lightbrown = {204 / 255, 153 / 255, 87 / 255},
    darkbrown = {119 / 255, 59 / 255, 22 / 255},
    accent = {0.2, 0.4, 1}
  }
  --create pieces
  pieces = {}
  for i = 1, 8 do
    table.insert(pieces, Piece:Create{r = 1, c = i, team = "black", type = "pawn"})
    table.insert(pieces, Piece:Create{r = 2, c = i, team = "black", type = "pawn"})
    table.insert(pieces, Piece:Create{r = 7, c = i, team = "white", type = "pawn"})
    table.insert(pieces, Piece:Create{r = 8, c = i, team = "white", type = "pawn"})
  end
end

function love.update()
  if lk.isDown("escape") or ((lk.isDown("lctrl") or lk.isDown("rctrl")) and lk.isDown("w")) then love.event.quit() end
end

function love.draw()
  lg.setColor(colors.gray)
  lg.rectangle("fill", 0, 0, tilesize * 16, tilesize * 16)
  -- draw board
  for r = 1, 8 do
    for c = 1, 8 do
      if (r % 2 == 0 and c % 2 == 0) or (r % 2 == 1 and c % 2 == 1) then lg.setColor(colors.darkbrown) else lg.setColor(colors.lightbrown) end
      lg.rectangle("fill", c * tilesize + tilesize * 3, r * tilesize + tilesize * 3, tilesize, tilesize)
    end
  end
  for i, p in ipairs(pieces) do
    p:Draw()
  end
  if selection then
    board[selection.r][selection.c]:Draw() -- draw the piece being moved on top of other pieces
    lg.setColor(colors.accent)
    lg.circle("line", lm.getX(), lm.getY(), tilesize / 2)
  end
end

function love.mousepressed(x, y, button, istouch, presses)
  row = math.floor(y / tilesize) - 3
  column = math.floor(x / tilesize) - 3
  if 0 < row and row <= 8 and 0 < column and column <= 8 then
    if board[row][column].team and (selection == nil or board[row][column].team == board[selection.r][selection.c].team) then
      selection = {r = row, c = column}
    end
  end
end

function love.mousereleased(x, y, button, isTouch)
  row = math.floor(y / tilesize) - 3
  column = math.floor(x / tilesize) - 3
  if 0 < row and row <= 8 and 0 < column and column <= 8 then
    if selection and board[row][column].team ~= board[selection.r][selection.c].team and board[selection.r][selection.c]:Check(row, column) then
      print(string.char(selection.c + 96) .. selection.r .. " " .. string.char(column + 96) .. row)
      board[selection.r][selection.c]:Move(row, column)
    end
  end
  selection = nil
end
