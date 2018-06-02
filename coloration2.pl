:- use_module(library(clpfd)). % librairie de programmation logique
                               % par contrainte à domaine fini

coloration2(X) :- 
	X = [X1,X2,X3,X4,X5,X6,X7,X8,X9,X10,X11,X12,X13,X14],
	X ins 0..3,
	contigu(X1,[X7,X9,X10,X11,X12,X13]),
	contigu(X2,[X8,X12,X14]),
	contigu(X3,[X7,X10,X14]),
	contigu(X4,[X9,X11,X14]),
	contigu(X5,[X8,X11,X12]),
	contigu(X6,[X7,X13,X14]),
	contigu(X7,[X10,X13,X14]),
	contigu(X8,[X12]),
	contigu(X9,[X10,X11,X14]),
	contigu(X10,[X14]),
	contigu(X11,[X12]),
	contigu(X12,[X13,X14]),
	contigu(X13,[X14]),
	labeling([leftmost,down],X),
	names(X,L),
	display(1,L).

contigu(_,[]).
contigu(X,[H|T]) :- X #\= H, contigu(X,T).

names([],[]).
names([H|T],[A|B]) :- couleur(H,A), names(T,B).

couleur(0,bleu).
couleur(1,jaune).
couleur(2,rouge).
couleur(3,vert).

display(_,[]).
display(N,[A|B]) :- write('('), write(N), write(','), write(A), write(')'), nl, M is N+1, display(M,B).

