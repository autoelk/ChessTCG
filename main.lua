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
  --create pieces
  pieces = {}
  for i = 1, 8 do
    table.insert(pieces, Piece:Create{r = 1, c = i, color = {0.1, 0.8, 0.1}})
    table.insert(pieces, Piece:Create{r = 2, c = i, color = {0.1, 0.8, 0.1}})
    table.insert(pieces, Piece:Create{r = 7, c = i, color = {0.1, 0.1, 0.8}})
    table.insert(pieces, Piece:Create{r = 8, c = i, color = {0.1, 0.1, 0.8}})
  end
end

function love.update()
  if lk.isDown("escape") or ((lk.isDown("lctrl") or lk.isDown("rctrl")) and lk.isDown("w")) then
    love.event.quit()
  end
end

function love.draw()
  lg.setColor(0.5, 0.5, 0.5)
  lg.rectangle("fill", 0, 0, tilesize * 16, tilesize * 16)
  -- draw board
  for r = 1, 8 do
    for c = 1, 8 do
      lg.setColor(0.1, 0.1, 0.1)
      if (r % 2 == 0 and c % 2 == 0) or (r % 2 == 1 and c % 2 == 1) then
        lg.setColor(0.9, 0.9, 0.9)
      end
      lg.rectangle("fill", c * tilesize + tilesize * 3, r * tilesize + tilesize * 3, tilesize, tilesize)
    end
  end
  for i, p in ipairs(pieces) do
    p:Draw()
  end
end

function love.mousepressed(x, y, button, istouch, presses)
  row = math.floor(y / tilesize) - 4
  column = math.floor(x / tilesize) - 4
  print(row, column)
  if tilesize * 4 < x and x < tilesize * 12 then
    if selection == nil then
      selection = board[row][column]
    else
      selection:Move(row, columm)
      selection = nil
    end
  end
end
