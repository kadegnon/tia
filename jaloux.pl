% valide si x appartient à l'espace d'état
valide(etat(Gauche, Droite, Barque, PosBarque)) :-
	valide_pos_barque(PosBarque),
	valide_barque(Barque),
	append([Gauche, Droite, Barque], ListePersonnes),
	personnes(ListePersonnes),
	not(probleme_couple(Gauche)),
	not(probleme_couple(Droite)),
	not(probleme_couple(Barque)).

valide_pos_barque(g).
valide_pos_barque(d).

% valide_barque(B) si B est une liste de maximum 2 éléments
valide_barque(B) :- 
	length(B,N),
	N < 3.

% personnes(L)si L est une liste contenant une et une seule fois chaque personne
personnes(L) :- 
	permutation(L,[h(1),h(2),h(3),f(1),f(2),f(3)]).

% Etat initial
etat_initial(etat(G, [], [], g)) :-
   personnes(G).

% Etat final
etat_final(etat([], D, [], d)) :-
   personnes(D).

% permutation(X,Y) si X est une permutation de Y
% permutation([],[]).
% permutation([H|T],Y):-
%	append(Ydeb,[H|Yfin],Y),
%	append(Ydeb,Yfin,YsansH),
%	permutation(T,YsansH).

% probleme_couple(L) si L pose des problemes de couple
probleme_couple(L) :-
	member(f(I),L),
	not(member(h(I),L)),
	member(h(_),L).

% cas UNE personne monte dans la barque
montee(etat(Gauche1,Droite1,Barque1,PosBarque), etat(Gauche2,Droite2,Barque2,PosBarque)) :-
	montee1(Gauche1,Droite1,Barque1,Gauche2,Droite2,Barque2,PosBarque),
	valide(etat(Gauche2,Droite2,Barque2,PosBarque)).

% cas où DEUX personnes montent dans la barque
montee(etat(Gauche1,Droite1,Barque1,PosBarque), etat(Gauche2,Droite2,Barque2,PosBarque)) :-
	montee1(Gauche1,Droite1,Barque1,GaucheInt,DroiteInt,BarqueInt,PosBarque),
	montee1(GaucheInt,DroiteInt,BarqueInt,Gauche2,Droite2,Barque2,PosBarque),
	valide(etat(Gauche2,Droite2,Barque2,PosBarque)).

montee1(Gauche1,Droite,Barque1,Gauche2,Droite,Barque2,g) :-
	transfert(Gauche1,Barque1,Gauche2,Barque2).
montee1(Gauche,Droite1,Barque1,Gauche,Droite2,Barque2,d) :-
	transfert(Droite1,Barque1,Droite2,Barque2).

% cas où UNE personne descend de la barque
descente(etat(Gauche1,Droite1,Barque1,PosBarque), etat(Gauche2,Droite2,Barque2,PosBarque)) :-
	descente1(Gauche1,Droite1,Barque1,Gauche2,Droite2,Barque2,PosBarque),
	valide(etat(Gauche2,Droite2,Barque2,PosBarque)).

% cas où DEUX personnes descendent de la barque
descente(etat(Gauche1,Droite1,Barque1,PosBarque), etat(Gauche2,Droite2,Barque2,PosBarque)) :-
	descente1(Gauche1,Droite1,Barque1,GaucheInt,DroiteInt,BarqueInt,PosBarque),
	descente1(GaucheInt,DroiteInt,BarqueInt,Gauche2,Droite2,Barque2,PosBarque),
	valide(etat(Gauche2,Droite2,Barque2,PosBarque)).

descente1(Gauche1,Droite,Barque1,Gauche2,Droite,Barque2,g) :-
	transfert(Barque1,Gauche1,Barque2,Gauche2).
descente1(Gauche,Droite1,Barque1,Gauche,Droite2,Barque2,d) :-
	transfert(Barque1,Droite1,Barque2,Droite2).

% transfert(A1,B1,A2,B2) si A2 vaut A1 avec un élément en moins
% et B2 vaut B1 avec cet élément en plus

transfert([H|T],B1,T,[H|B1]).
transfert([H|T],B1,[H|T2],B2) :-
	transfert(T,B1,T2,B2).

traversee(etat(Gauche,Droite,Barque,g), etat(Gauche,Droite,Barque,d)) :-
	length(Barque,N),
	N>0.
traversee(etat(Gauche,Droite,Barque,d), etat(Gauche,Droite,Barque,g)) :-
	length(Barque,N),
	N>0.

% une transition entre deux états résulte soit d'une montée, soit d'une
% descente, soit d'une traversée
transition(X,Y) :-
	montee(X,Y).
transition(X,Y) :-
	descente(X,Y).
transition(X,Y) :-
	traversee(X,Y).

etats_equivalents(etat(Gauche1,Droite1,Barque1,PosBarque),
		  etat(Gauche2,Droite2,Barque2,PosBarque)) :-
	permutation(Gauche1,Gauche2),
	permutation(Droite1,Droite2),
	permutation(Barque1,Barque2).

% gestion : strategie pour l'exploration de l'espace d'états, à l'aide des opérateurs

solution(Debut,Fin,Sol) :-
	open_close_search(Fin, [[Debut]], [], Sol).

open_close_search(Fin,Open,Closed,Result) :- 
	member(Premier,Open),
	open_close_search(Fin,Open,Closed,Result,Premier).

open_close_search(Fin,_,_,Solution,Premier) :- 
	but(Premier,Fin),
	reverse(Premier,Solution),
	ecrire_liste(Solution).

open_close_search(Fin,Open,Closed,Result,Premier) :- 
	delete(Open,Premier,Derniers),
	successeur(Premier,Successeurs),
	diff(Successeurs,Closed,OpenSuccesseurs),
	rassembler_dfs(OpenSuccesseurs,Derniers,NewOpen),
	Premier=[H|_],
	open_close_search(Fin,NewOpen,[H|Closed],Result).

but([EtatAtteint|_],EtatVise) :-
	etats_equivalents(EtatAtteint, EtatVise).

successeur([H|T],Successeurs) :-
	successeur([H|T],Successeurs,[]).

successeur([H|T],Successeurs,Int) :-
	transition(H,S),
	not(member([S,H|T],Int)),
	!,
	successeur([H|T],Successeurs,[[S,H|T]|Int]).

successeur(_,Int,Int).

diff(Successeurs,Closed,OpenSuccesseurs) :-
	diff(Successeurs,Closed,OpenSuccesseurs,[]).

diff([],_,Int,Int).

diff([[H|_]|Derniers],Closed,OpenSuccesseurs,Int) :-
	member(H2,Closed),
	etats_equivalents(H,H2),
	!,
	diff(Derniers,Closed,OpenSuccesseurs,Int).

diff([Premier|Derniers],Closed,OpenSuccesseurs,Int) :-
	diff(Derniers,Closed,OpenSuccesseurs,[Premier|Int]).

rassembler_bfs(E1,E2,NewOpen) :-
	rassembler(E1,E2,NewOpen,[]).

rassembler_dfs(E1,E2,NewOpen) :-
	rassembler(E2,E1,NewOpen,[]).

rassembler([],E2,Union,Int) :- 
	append(E2,Int,Union).

rassembler([[H|_]|Succ],E2,Union,Int) :- 
	member([H|_],E2),
	!,
	rassembler(Succ,E2,Union,Int).

rassembler([Premier|Succ],E2,Union,Int) :-
	rassembler(Succ,E2,Union,[Premier|Int]).

ecrire_liste([]).
ecrire_liste([H|T]) :-
	write(H), nl, ecrire_liste(T).

% Test de recherche de solution

solution_maris :-
   etat_initial(I),
   etat_final(F),
   solution(I, F, _Sol).










