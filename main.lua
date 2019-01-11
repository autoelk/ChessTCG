require "piece"

function love.load(arg)
  math.randomseed(os.time())
  lg = love.graphics
  lk = love.keyboard
  lw = love.window
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
    white = {0.1, 0.1, 0.1},
    gray = {0.5, 0.5, 0.5},
    black = {0.9, 0.9, 0.9},
    lightbrown = {204 / 255, 153 / 255, 87 / 255},
    darkbrown = {119 / 255, 59 / 255, 22 / 255},
    accent = {0.2, 0.4, 1}
  }
  --create pieces
  pieces = {}
  for i = 1, 8 do
    table.insert(pieces, Piece:Create{r = 1, c = i, team = 2})
    table.insert(pieces, Piece:Create{r = 2, c = i, team = 2})
    table.insert(pieces, Piece:Create{r = 7, c = i, team = 1})
    table.insert(pieces, Piece:Create{r = 8, c = i, team = 1})
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
  lg.setColor(colors.accent)
  if selection then lg.rectangle("line", selection.c * tilesize + tilesize * 3, selection.r * tilesize + tilesize * 3, tilesize, tilesize, 10) end
end

function love.mousepressed(x, y, button, istouch, presses)
  row = math.floor(y / tilesize) - 3
  column = math.floor(x / tilesize) - 3
  if 0 < row and row <= 8 and 0 < column and column <= 8 then
    if (selection == nil or board[row][column].team == board[selection.r][selection.c].team) and board[row][column].team then
      selection = {r = row, c = column}
    elseif selection then
      print(string.char(selection.c + 96) .. selection.r .. " " .. string.char(column + 96) .. row)
      board[selection.r][selection.c]:Move(row, column)
      selection = nil
    end
  end
end
