% Constants for the game
empty(e).
red(r).
yellow(y).

% Representation of the board
% The board is a list of rows, each row is a list of columns.
% Example board: [[e,e,e,e,e,e,e], [e,e,e,e,e,e,e], ...]

% Check if a player has won the game
has_won(Board, Player) :-
    % Check rows for four consecutive pieces
    member(Row, Board),
    consecutive_four(Row, Player);
    
    % Check columns (by transposing the board)
    transpose(Board, TransposedBoard),
    member(Column, TransposedBoard),
    consecutive_four(Column, Player);
    
    % Check diagonals (top-left to bottom-right)
    diagonal(Board, Player);
    
    % Check diagonals (top-right to bottom-left)
    reverse_board(Board, RevBoard),
    diagonal(RevBoard, Player).

% Check if a list has four consecutive pieces
consecutive_four(List, Player) :-
    append(_, [Player, Player, Player, Player | _], List).

% Extract diagonals from the board
diagonal(Board, Player) :-
    diagonals(Board, Diags),
    member(Diag, Diags),
    consecutive_four(Diag, Player).

% Get all diagonals from the board
diagonals(Board, Diags) :-
    findall(Diagonal, get_diagonal(Board, Diagonal), Diags).

% Get a diagonal (e.g., top-left to bottom-right)
get_diagonal(Board, Diagonal) :-
    % This is a simplified version for diagonal extraction.
    extract_diagonal(Board, Diagonal).

% Extract the diagonal from the board
extract_diagonal(Board, Diagonal) :-
    findall(E, (nth0(Index, Board, Row), nth0(Index, Row, E)), Diagonal).

% Check if the board is full
is_full(Board) :-
    \+ member(e, Board).

% Minimax with Alpha-Beta pruning
minimax(Board, Depth, Alpha, Beta, MaximizingPlayer, BestMove, Value) :-
    is_full(Board), !,
    evaluate(Board, MaximizingPlayer, Value),
    BestMove = none.

minimax(Board, Depth, Alpha, Beta, MaximizingPlayer, BestMove, Value) :-
    Depth > 0,
    valid_moves(Board, Moves),
    best_move(Moves, Board, Depth, Alpha, Beta, MaximizingPlayer, BestMove, Value).

% Apply Alpha-Beta pruning
best_move([], _, _, _, _, _, none, -1000).  % No valid moves left
best_move([Move | RestMoves], Board, Depth, Alpha, Beta, MaximizingPlayer, BestMove, Value) :-
    apply_move(Board, Move, MaximizingPlayer, NewBoard),
    minimax(NewBoard, Depth - 1, Alpha, Beta, next_player(MaximizingPlayer), _, NewValue),
    alpha_beta_prune(Alpha, Beta, NewValue, Move, BestMove, Value).

% Alpha-Beta pruning logic
alpha_beta_prune(Alpha, Beta, Value, Move, Move, Value) :-
    (Value > Beta -> ! ; 
    (Value >= Alpha -> 
        Alpha is Value ; 
        true)).

% Evaluate the board position
evaluate(Board, MaximizingPlayer, Value) :-
    (has_won(Board, MaximizingPlayer) -> Value is 10 ;
    has_won(Board, next_player(MaximizingPlayer)) -> Value is -10 ;
    Value is 0).

% Get the next player (if Red played, now it's Yellow's turn and vice versa)
next_player(r) :- !, y.
next_player(y) :- !, r.

% Get valid moves for the current board state
valid_moves(Board, Moves) :-
    findall(Column, can_place_disc(Board, Column), Moves).

% Check if a column is a valid move (i.e., it's not full)
can_place_disc(Board, Column) :-
    nth0(Column, Board, ColumnList),
    member(e, ColumnList), !.

% Apply a move to the board (drop a disc into a column)
apply_move(Board, Column, Player, NewBoard) :-
    drop_disc(Board, Column, Player, NewBoard).

% Drop a disc into the first available row of a column
drop_disc([Row | Rest], 1, Player, [NewRow | Rest]) :-
    drop_in_row(Row, Player, NewRow).
drop_disc([Row | Rest], Column, Player, [Row | NewRest]) :-
    Column > 0,
    NewColumn is Column - 1,
    drop_disc(Rest, NewColumn, Player, NewRest).

% Drop a disc in the first available position of a row
drop_in_row([e | Rest], Player, [Player | Rest]).
drop_in_row([Player | Rest], Player, [Player | Rest]).

% Reverse the board (used for checking the other diagonal)
reverse_board(Board, RevBoard) :-
    maplist(reverse, Board, RevBoard).
