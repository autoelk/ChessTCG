function chessplace()
  table.insert(pieces, Piece:Create{r = 1, c = 1, team = "black", type = "rook"})
  table.insert(pieces, Piece:Create{r = 1, c = 2, team = "black", type = "night"})
  table.insert(pieces, Piece:Create{r = 1, c = 3, team = "black", type = "bishop"})
  table.insert(pieces, Piece:Create{r = 1, c = 4, team = "black", type = "queen"})
  table.insert(pieces, Piece:Create{r = 1, c = 5, team = "black", type = "king"})
  table.insert(pieces, Piece:Create{r = 1, c = 6, team = "black", type = "bishop"})
  table.insert(pieces, Piece:Create{r = 1, c = 7, team = "black", type = "night"})
  table.insert(pieces, Piece:Create{r = 1, c = 8, team = "black", type = "rook"})

  for i = 1, 8 do
    table.insert(pieces, Piece:Create{r = 2, c = i, team = "black", type = "pawn"})
  end

  for i = 1, 8 do
    table.insert(pieces, Piece:Create{r = 7, c = i, team = "white", type = "pawn"})
  end

  table.insert(pieces, Piece:Create{r = 8, c = 1, team = "white", type = "rook"})
  table.insert(pieces, Piece:Create{r = 8, c = 2, team = "white", type = "night"})
  table.insert(pieces, Piece:Create{r = 8, c = 3, team = "white", type = "bishop"})
  table.insert(pieces, Piece:Create{r = 8, c = 4, team = "white", type = "queen"})
  table.insert(pieces, Piece:Create{r = 8, c = 5, team = "white", type = "king"})
  table.insert(pieces, Piece:Create{r = 8, c = 6, team = "white", type = "bishop"})
  table.insert(pieces, Piece:Create{r = 8, c = 7, team = "white", type = "night"})
  table.insert(pieces, Piece:Create{r = 8, c = 8, team = "white", type = "rook"})
end
