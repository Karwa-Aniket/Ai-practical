% Facts: Define the grid and obstacles
grid_size(4, 4). % A 4x4 grid
obstacle(2, 2). % There's an obstacle at (2, 2)

% Robot movements (up, down, left, right)
move(up, (X, Y), (X, Y1)) :- Y1 is Y - 1, Y1 > 0.
move(down, (X, Y), (X, Y1)) :- Y1 is Y + 1, grid_size(_, MaxY), Y1 =< MaxY.
move(left, (X, Y), (X1, Y)) :- X1 is X - 1, X1 > 0.
move(right, (X, Y), (X1, Y)) :- X1 is X + 1, grid_size(MaxX, _), X1 =< MaxX.

% Prevent moving into obstacles
valid_position((X, Y)) :- \+ obstacle(X, Y).

% Means-End Analysis to solve the problem
means_end(Start, Goal, Path) :-
    means_end_helper(Start, Goal, [Start], Path).

means_end_helper(Goal, Goal, Visited, Path) :-
    reverse(Visited, Path). % If the goal is reached, return the path.

means_end_helper(Current, Goal, Visited, Path) :-
    move(Direction, Current, Next), % Attempt a move.
    valid_position(Next),          % Ensure it's a valid position.
    \+ member(Next, Visited),      % Avoid cycles.
    write('Moving '), write(Direction), write(' to '), write(Next), nl,
    means_end_helper(Next, Goal, [Next|Visited], Path). % Recursively continue.

% Query: Start at (1, 1), Goal is (4, 4)
