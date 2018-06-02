% PROBLEME DES TOURS DE HANOI
% Céline Dandois

% Représentation : prob((G1,M1,P1),(G2,M2,P2))
% où 1 <= G1,M1,P1,G2,M2,P2 <= 3 et, pour un triplet (X,Y,Z),
% X = numéro du mât sur lequel se trouve le grand disque
% Y = numéro du mât sur lequel se trouve le disque moyen
% Z = numéro du mât sur lequel se trouve le petit disque

% Problèmes primitifs Prim : ensembles de passages élémentaires de disque d'un mât à l'autre
% Problème à résoudre P_0 : prob((1,1,1),(3,3,3))
% Opérateurs : opérateurs de décomposition de passages en succession de passages plus simples
% Contraintes : Le seul disque déplaçable est celui du sommet et un disque ne peut être posé sur un plus petit.


% Représentation
%----------------
% Prédicat :	tour(T)
% Types :	T : {1,2,3}
% Relation :	ce prédicat vérifie que T est bien de type {1,2,3}
% Directions et multiplicités : tour(+) <0-1>
tour(1).
tour(2).
tour(3).


% Prédicat :	prob_primitif(P)
% Types :	P est un problème valide
% Relation :	ce prédicat vérifie que P est un problème primitif
% Directions et multiplicités :
% prob_primitif(-) <1-N>
% prob_primitif(+) <0-1>
prob_primitif(prob((G1,M1,P1),(G2,M1,P1))) :- tour(G1), tour(M1), tour(P1), tour(G2), \+(M1=G1), \+(P1=G1), \+(G2=G1), \+(G2=M1), \+(G2=P1). % déplacer le grand disque
prob_primitif(prob((G1,M1,P1),(G1,M2,P1))) :- tour(G1), tour(M1), tour(P1), tour(M2), \+(P1=M1), \+(M2=M1), \+(M2=P1). % déplacer le disque moyen
prob_primitif(prob((G1,M1,P1),(G1,M1,P2))) :- tour(G1), tour(M1), tour(P1), tour(P2), \+(P2=P1). % déplacer le petit disque


% Actions
%---------
% Prédicat :	appliquer_operateur(O,P,LPrim,LNonPrim)
% Types :	O : opérateur ; P : problème valide ; LPrim : liste de problèmes valides primitifs ; LNonPrim : liste de problèmes valides non primitifs
% Relation :	LPrim U LNonPrim est le résultat de l'application de l'opérateur O sur P
% Directions et multiplicités : appliquer_operateur(-,+,-,-) <1-n>
appliquer_operateur(prob_primitf, P, [P], []) :- prob_primitif(P).
appliquer_operateur(reduction, P, [PPrim], [PNonPrim]) :- \+ prob_primitif(P), P = prob((G1,M1,P1),(G2,M2,P2)), PPrim = prob((G1,M1,P1),(G3,M3,P3)), prob_primitif(PPrim), PNonPrim = prob((G3,M3,P3),(G2,M2,P2)).


% Gestion
%---------
% Prédicat :	prob_tours_hanoi(L1,L2)
% Types :	L1 : liste de problèmes valides ; L2 : liste de problèmes primitifs valides
% Relation :	ce prédicat détermine un plan pour résoudre les problèmes contenus dans L1 en les décomposant en l'ensemble des problèmes primitifs contenus dans L2
% Directions et multiplicités : prob_tours_hanoi(+,-) <1-n>
prob_tours_hanoi(L1,L2) :- prob_tours_hanoi_rec(L1,L2,[]).


% Prédicat :	prob_tours_hanoi_rec(L1,L2,Acc)
% Types :	L1 : liste de problèmes valides ; L2, Acc : listes de problèmes primitifs valides
% Relation :	ce prédicat détermine un plan pour résoudre les problèmes contenus dans L1 en les décomposant en un ensemble de problèmes primitifs E tel que L2 = Acc + E (Acc étant un accumulateur des problèmes primitifs déjà trouvés)
% Directions et multiplicités : prob_tours_hanoi(+,-,+) <1-n>
prob_tours_hanoi_rec([],Acc,Acc).
prob_tours_hanoi_rec([P|Q],L2,Acc) :- 	appliquer_operateur(O,P,LPrim,LNonPrim),

					% pour éviter de tomber sur des problèmes à résoudre déjà connus (BUT : éviter les cycles dans la recherche)
					nouveaux_probs(LPrim,Q),
					nouveaux_probs(LPrim,Acc),
					nouveaux_probs(LNonPrim,Q),
					% nouveaux_probs(LNonPrim,Acc), % non nécessaire

					write('Problème courant : '), writeln(P),
					write('Test de l\'opérateur : '), writeln(O),
					write('Problème courant décomposé : '), writeln((LPrim,LNonPrim)),
					append(LNonPrim,Q,NouvL1),
					append(Acc,LPrim,NouvAcc),
					prob_tours_hanoi_rec(NouvL1,L2,NouvAcc).


% Prédicat :	nouveaux_probs(L1,L2)
% Types :	L1,L2 : listes de problèmes valides
% Relation :	ce prédicat vérifie que les problèmes contenus dans L1 sont des nouveaux problèmes par rapport à ceux contenus dans L2
% Directions et multiplicités : nouveaux_probs(+,+) <0-1>
nouveaux_probs([],_).
nouveaux_probs([P|Q],L2) :- nouveau_prob(P,L2), nouveaux_probs(Q,L2).

% Prédicat :	nouveau_prob(P,L)
% Types :	P : problème valide ; L : liste de problèmes valides
% Relation :	ce prédicat vérifie que le problème P est un nouveau problème par rapport à ceux contenus dans L2
% Directions et multiplicités : nouveau_prob(+,+) <0-1>
nouveau_prob(_,[]).
nouveau_prob(P1,[P2|Q]) :- P1 = prob((X,Y,Z),(A,B,C)), \+(P2=P1), \+(P2 = prob((A,B,C),(X,Y,Z))), nouveau_prob(P1,Q).


% Lancer le programme
%---------------------
% Prédicat :	exec
% Types :	-
% Relation :	ce prédicat lance un test du prédicat "prob_tours_hanoi"
% Directions et multiplicités : exec <1-n>
exec :-	prob_tours_hanoi([prob((1,1,1),(3,3,3))],L),
	write('Solution : '), writeln(L).


