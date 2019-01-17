tilesize = 40
require "piece"
require "card"
require "chessmode"

function love.load(arg)
  math.randomseed(os.time())
  lg = love.graphics
  lk = love.keyboard
  lw = love.window
  lm = love.mouse
  lw.setTitle("ChessTCG")
  lw.setMode(tilesize * 16, tilesize * 16, {borderless = true})
  chessfont = lg.newFont("Cases.ttf", tilesize)
  font = lg.newFont("Roboto-Regular.ttf", tilesize / 2)
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
    lightbrown = {196 / 255, 145 / 255, 79 / 255},
    darkbrown = {136 / 255, 75 / 255, 38 / 255},
  }
  game = {
    stage = "game",
    turn = "white",
  }

  -- create pieces
  -- chessplace()
  pieces = {}
  for c = 1, 8 do
    table.insert(pieces, Piece:Create{r = 1, c = c, team = "black", type = "generic", spr = "."})
    table.insert(pieces, Piece:Create{r = 2, c = c, team = "black", type = "generic", spr = "."})
    table.insert(pieces, Piece:Create{r = 7, c = c, team = "white", type = "generic", spr = "."})
    table.insert(pieces, Piece:Create{r = 8, c = c, team = "white", type = "generic", spr = "."})
  end
  -- create cards
  white = {
    deck = {},
    hand = {},
  }
  black = {
    deck = {},
    hand = {},
  }
  for i = 1, 8 do
    table.insert(white.deck, Card:Create{team = "white", type = "pawn", spr = "o"})
  end
  table.insert(white.deck, Card:Create{team = "white", type = "rook", spr = "t"})
  table.insert(white.deck, Card:Create{team = "white", type = "knight", spr = "m"})
  table.insert(white.deck, Card:Create{team = "white", type = "bishop", spr = "v"})
  table.insert(white.deck, Card:Create{team = "white", type = "queen", spr = "w"})
  table.insert(white.deck, Card:Create{team = "white", type = "king", spr = "l"})
  table.insert(white.deck, Card:Create{team = "white", type = "bishop", spr = "v"})
  table.insert(white.deck, Card:Create{team = "white", type = "knight", spr = "m"})
  table.insert(white.deck, Card:Create{team = "white", type = "rook", spr = "t"})
  for i = 1, 8 do
    table.insert(black.deck, Card:Create{team = "black", type = "pawn", spr = "o"})
  end
  table.insert(black.deck, Card:Create{team = "black", type = "rook", spr = "t"})
  table.insert(black.deck, Card:Create{team = "black", type = "knight", spr = "m"})
  table.insert(black.deck, Card:Create{team = "black", type = "bishop", spr = "v"})
  table.insert(black.deck, Card:Create{team = "black", type = "queen", spr = "w"})
  table.insert(black.deck, Card:Create{team = "black", type = "king", spr = "l"})
  table.insert(black.deck, Card:Create{team = "black", type = "bishop", spr = "v"})
  table.insert(black.deck, Card:Create{team = "black", type = "knight", spr = "m"})
  table.insert(black.deck, Card:Create{team = "black", type = "rook", spr = "t"})

  --shuffle decks
  shuffle(white.deck)
  shuffle(black.deck)
  --draw starting hand
  for i = 1, 4 do
    white.deck[1]:Move("hand")
    black.deck[1]:Move("hand")
  end
end

function love.update()
  if lk.isDown("escape") or ((lk.isDown("lctrl") or lk.isDown("rctrl")) and lk.isDown("w")) then love.event.quit() end
end

function love.draw()
  lg.setColor(StringToColor(game.turn))
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
  if #white.deck > 0 then
    white.deck[1]:Draw(tilesize * 1, tilesize * 12.5)
  end
  if #black.deck > 0 then
    black.deck[1]:Draw(tilesize * 13, tilesize * 0.5)
  end
  for i, c in ipairs(white.hand) do
    if cardselection and i == cardselection.val and cardselection.team == "white" then
      c:Draw(lm.getX() - tilesize * 1, lm.getY() - tilesize * 1.5)
    else
      c:Draw(tilesize * 2 * (i + 1), tilesize * 12.5)
    end
  end
  for i, c in ipairs(black.hand) do
    if cardselection and i == cardselection.val and cardselection.team == "black" then
      c:Draw(lm.getX() - tilesize * 1, lm.getY() - tilesize * 1.5)
    else
      c:Draw(tilesize * 2 * (i + 1), tilesize * 0.5)
    end
  end
  if selection then
    for r = 1, 8 do
      for c = 1, 8 do
        if board[selection.r][selection.c]:Check(r, c) then
          lg.setColor(colors.gray)
          lg.circle("fill", (c + 3.5) * tilesize, (r + 3.5) * tilesize, tilesize * 0.2)
        end
      end
    end
    board[selection.r][selection.c]:Draw() -- draw the piece being moved on top of other pieces
  end
end

function love.mousepressed(x, y, button, istouch, presses)
  row = math.floor(y / tilesize) - 3
  column = math.floor(x / tilesize) - 3
  if 0 < column and column <= 8 then
    if 0 < row and row <= 8 then
      if board[row][column].team and (selection == nil or board[row][column].team == board[selection.r][selection.c].team) then
        selection = {r = row, c = column}
      end
    elseif 8 < row then
      cardselection = {val = math.ceil(column * 0.5), team = "white"}
    elseif row <= 0 then
      cardselection = {val = math.ceil(column * 0.5), team = "black"}
    end
  end
end

function love.mousereleased(x, y, button, isTouch)
  row = math.floor(y / tilesize) - 3
  column = math.floor(x / tilesize) - 3
  if 0 < row and row <= 8 and 0 < column and column <= 8 then
    if selection and board[selection.r][selection.c]:Check(row, column) then
      print(string.char(selection.c + 96) .. selection.r .. " " .. string.char(column + 96) .. row)
      board[selection.r][selection.c]:Move(row, column)
    end
    if cardselection and game.turn == cardselection.team and board[row][column].team == cardselection.team then
      if cardselection.team == "white" then
        white.hand[cardselection.val]:Play(row, column)
      else
        black.hand[cardselection.val]:Play(row, column)
      end
    end
  end
  selection = nil
  cardselection = nil
end

function StringToColor(string)
  if string == "white" then
    return colors.white
  elseif string == "black" then
    return colors.black
  else
    return colors.gray
  end
end

function shuffle(table)
  for i = #table, 2, - 1 do
    local j = math.random(i)
    table[i], table[j] = table[j], table[i]
  end
  return table
end
