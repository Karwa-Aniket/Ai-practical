/* Description: 
For example, there are four cities(Kansas City,Houston,Gordon and Tampa). 

-> The distance between Kansas City and Houston is 120.
-> The distance between Kansas City and Tampa is 80.
-> The distance between Houston and Gordon is 100.

*/

% Production Rules:-
 route(Town1,Town2,Distance)🡪 road(Town1,Town2,Distance).
 route(Town1,Town2,Distance)🡪 road(Town1,X,Dist1),
 route(X,Town2,Dist2),
 Distance=Dist1+Dist2,

% Domains

 town = symbol
 distance = integer

% Predicates

 nondeterm road(town,town,distance)
 nondeterm route(town,town,distance)

% Clauses

 road("tampa","houston",200).
 road("gordon","tampa",300).
 road("houston","gordon",100).
 road("houston","kansas_city",120).
 road("gordon","kansas_city",130).

 route(Town1,Town2,Distance):-
	road(Town1,Town2,Distance).
 
 route(Town1,Town2,Distance):-
	road(Town1,X,Dist1),
	route(X,Town2,Dist2),
	Distance=Dist1+Dist2,
	!.
% Goal
 route("tampa", "kansas_city", X),
 write("Distance from Tampa to Kansas City is ",X),nl.
