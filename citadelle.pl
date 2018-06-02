:-use_module(library(clpfd)). % librairie de programmation logique
                              % par contrainte à domaine fini
solve(Board):-
	Board = [N,NE,E,SE,S,SO,O,NO],
	Board ins 0..12,
	N + NE + E #>= 5, % au moins 5 gardes par côté
	E + SE + S #>= 5,
	S + SO + O #>= 5,
	O + NO + N #>= 5,
	somme(Board,12),   % la somme des gardes égale 12 exactement
	labeling([ff,up],Board),      % stratégie pour attribuer des valeurs aux variables
	writeln([N,NE,E]),
	writeln([NO,' ',SE]),
	writeln([O,SO,S]).

somme([X|Xs],Sum):-
	somme(Xs,SumT),
	X + SumT #= Sum.

somme([],0).
