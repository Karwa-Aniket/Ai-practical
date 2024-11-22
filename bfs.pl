% Representing the graph with edges
edge(a, b).
edge(b, c).
edge(c, d).
edge(d, e).
edge(b, e).
edge(a, f).
edge(f, g).

% BFS implementation
bfs(Start, Goal, Path) :-
    bfs([[Start]], Goal, [], Path).

% Base case: Goal is reached
bfs([[Goal|Rest]|_], Goal, _, [Goal|Rest]).

% Recursive case: Explore neighbors
bfs([Path|Paths], Goal, Visited, FinalPath) :-
    Path = [Node|_],  % Take the first node from the path
    findall([NewNode, Node|Path], 
            (edge(Node, NewNode), 
             \+ member(NewNode, Visited)),  % Ensure that NewNode is not in Visited
            Neighbors),  % Find unvisited neighbors
    append(Paths, Neighbors, NewPaths),  % Add them to the queue
    append(Visited, [Node], NewVisited),  % Add the current node to the visited list
    bfs(NewPaths, Goal, NewVisited, FinalPath).  % Recursively explore
