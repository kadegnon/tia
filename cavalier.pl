:- use_module(library(clpfd)). % librairie de programmation logique
                               % par contrainte à domaine fini

% Le problème du cavalier d'Euler

elt([L|_],1,L).

elt([_|SL],N,LP) :-
   NP is N-1,
   elt(SL,NP,LP).

elt2([X|_],1,E) :-
   X #= E.

elt2([_|SL],N,LP) :-
   NP is N-1,
   elt2(SL,NP,LP).

% Une matrice
matrice(M,L,C,E) :- % M = matrice L = n° Ligne C = n° colonne E = n° du saut
   elt(M,L,Ligne),  % mettre dans Ligne la ligne L de la matrice M
   elt2(Ligne,C,E). % rechercher colonne C dans Ligne et y inscrire E

% Un échiquier
echiquier(N, E) :-  % Un échiqier de taille N
   length(E, N),    % est une file E de taille N
   files(E, N).     % et E est fait de files

files([], _N).      
files([F|Fs], N) :- % Ces files sont de longueur N
   length(F, N),    
   NN is N*N,       % NN est le carre de N (nbre maximum)
   F ins 1..NN,     
   files(Fs, N).    % Les éléments de ces files sont compris entre 1 et N²

% Prédicat pour imposer que les cases sont toutes différentes
cases_differentes(Echiquier) :- 
   flatten(Echiquier, Cases),   % mise à plat de la liste de listes dans une seule liste
   all_different(Cases).        % dont toutes les cases doivent être différentes

% Usage du prédicat précédent sur l'échiquier
contraintes_echiquier(N, E) :-  
   echiquier(N, E),             % on a un échiquier
   cases_differentes(E).        % dont toutes les cases auront un n° différent

% Modélisation du mouvement du cavalier sur la grille
jouer(Grille,I,J,Nb,N) :-       % le cavalier est en ligne I et colonne J sur la grille
   matrice(Grille,I,J,Nb),      % et a fait le saut Nb
   Nb1 is Nb+1,
   chercher(Grille,I,J,Nb1,N).  % il cherche a quelle position aller pour faire le saut suivant Nb1

% Contraintes sur les sauts du cheval
saut_cheval(A, B, As, Bs) :-    
   As #= A-2,
   Bs #= B-1.

saut_cheval(A, B, As, Bs) :-
   As #= A-2,
   Bs #= B+1.

saut_cheval(A, B, As, Bs) :-
   As #= A-1,
   Bs #= B-2.

saut_cheval(A, B, As, Bs) :-
   As #= A-1,
   Bs #= B+2.

saut_cheval(A, B, As, Bs) :-
   As #= A+1,
   Bs #= B-2.

saut_cheval(A, B, As, Bs) :-
   As #= A+1,
   Bs #= B+2.

saut_cheval(A, B, As, Bs) :-
   As #= A+2,
   Bs #= B-1.

saut_cheval(A, B, As, Bs) :-
   As #= A+2,
   Bs #= B+1.

% Recherche d'une nouvelle case
chercher(_Grille, _A, _B, Nb, N) :-
   Nb > N*N. % le programme a dépassé le nombre
             % maximum de cases, et il se termine

chercher(Grille, A, B, Nb, N) :- % chercher à partir de la situation où il se trouve
   saut_cheval(A, B, Ap, Bp),    % c'est effectuer un saut
   jouer(Grille, Ap, Bp, Nb, N). % et ensuite rejouer à partir de cette grille

% Labeling
label_grille([]).

label_grille([F|Fs]) :- % la stratégie label_grille d'une suite de suites
   label(F),            % est la stratégie label pour chaque suite
   label_grille(Fs).

% Pretty printing
afficheCol([]) :- nl.
afficheCol([H|T]) :- write(H), write(' '), afficheCol(T).
affiche([]).
affiche([H|T]) :- afficheCol(H),affiche(T).

% Le prédicat de lancement
run(N) :-
   contraintes_echiquier(N, Grille), % un échiquier
   jouer(Grille,1,1,1,N),            % où le cavalier est en position 1 de coordonnées (1,1)
   label_grille(Grille),             
   affiche(Grille).

