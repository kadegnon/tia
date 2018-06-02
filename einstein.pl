% Relations de voisinage

gauche(A,B) :- A is B-1. % gauche immediate
voisin(A,B) :- abs(A-B) =:= 1.

% recherche X dans une liste

elt(X,[X|_]).
elt(X,[_|T]) :- elt(X,T).

% cherche l'attribut A dans la liste des maisons et M est le numero de la maison dans laquelle
% A a ete trouve. Note: ce predicat verifie ou pose des contraintes (instancie une variable a A).

take([[M|T]|_],A,M) :- elt(A,T).
take([_|T],A,M) :- take(T,A,M).

% Attribut1 est voisin de Attribut2

est_voisin(ListeMaisons, Attribut1, Attribut2) :- 
	take(ListeMaisons, Attribut1, M1),
	take(ListeMaisons, Attribut2, M2),
	voisin(M1,M2).

% Attribut1 est a gauche de Attribut2

est_a_gauche(ListeMaisons, Attribut1, Attribut2) :- 
	take(ListeMaisons, Attribut1, M1),
	take(ListeMaisons, Attribut2, M2),
	gauche(M1,M2).

% Verifions que l'une des cinq maisons possede les attributs mentionnes
% Note: la encore l'unification sert aussi bien a verifier qu'a instancier une maison particuliere
% avec les attributs instancies

test([[NumMaison,Habitant,Couleur,Boisson,Cigarette,Animal]|_],NumMaison,Habitant,Couleur,Boisson,Cigarette,Animal).
test([_|AutresMaisons],NumMaison,Habitant,Couleur,Boisson,Cigarette,Animal) :-
	test(AutresMaisons,NumMaison,Habitant,Couleur,Boisson,Cigarette,Animal).


% On se contente ici de poser un ensemble de contraintes sur une liste de cinq maisons

cherche(ListeMaisons) :-

	% Les informations corrélées
	
	test(ListeMaisons,_	,anglais	,rouge	,_	,_		,_),		% enonce 1
	test(ListeMaisons,_	,suedois	,_	,_	,_		,chien),	% enonce 2
	test(ListeMaisons,_	,danois		,_	,the	,_		,_),		% enonce 3
	test(ListeMaisons,_	,_		,verte	,cafe	,_		,_),		% enonce 5
	test(ListeMaisons,_	,_		,_	,_	,pallmall	,oiseau),	% enonce 6
	test(ListeMaisons,_	,_		,jaune	,_	,dunhill	,_),		% enonce 7
	test(ListeMaisons,3	,_		,_	,lait	,_		,_),		% enonce 8
	test(ListeMaisons,1	,norvegien 	,_	,_	,_		,_),		% enonce 9
	test(ListeMaisons,_	,_		,_	,biere	,morris		,_),		% enonce 12
	test(ListeMaisons,_	,allemand	,_	,_	,marlboro	,_),		% enonce 13

	
	% Les informations "isolées"

	test(ListeMaisons,_	,_		,blanche,_	,_		,_),		% partie enonce 4
	test(ListeMaisons,_	,_		,_	,_	,_		,chat),		% partie enonce 10
	test(ListeMaisons,_	,_		,_	,_	,_		,cheval),	% partie enonce 11
	test(ListeMaisons,_	,_		,bleue	,_	,_		,_),		% partie enonce 14
	test(ListeMaisons,_	,_		,_	,_	,rothmans	,_),		% partie enonce 15
	test(ListeMaisons,_	,_		,_	,eau	,_		,_),		% partie enonce 15
	test(ListeMaisons,_	,_		,_	,_	,_		,poisson),	% partie enonce de départ

	% Les contraintes de voisinage

	est_a_gauche(ListeMaisons,verte		,blanche),					% enonce 4
	est_voisin(ListeMaisons, rothmans	,chat),						% enonce 10
	est_voisin(ListeMaisons	,rothmans	,eau),						% enonce 15
	est_voisin(ListeMaisons, cheval		,dunhill),					% enonce 11
	est_voisin(ListeMaisons ,bleue		,norvegien),					% enonce 14
	est_voisin(ListeMaisons ,cheval		,jaune).					% enonces 7 + 11
	
	
run :- 
	cherche([[1|M1],[2|M2],[3|M3],[4|M4],[5|M5]]),  % liste de 5 maisons (identifiees par un numero)
	format("Maison 1: ~w~n",[M1]),
	format("Maison 2: ~w~n",[M2]),
	format("Maison 3: ~w~n",[M3]),
	format("Maison 4: ~w~n",[M4]),
	format("Maison 5: ~w~n",[M5]),
	format("---------------------------------------------------~n",[]).
	





