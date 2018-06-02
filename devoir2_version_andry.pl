% Constraint Logic Programming

:- use_module(library(clpfd)).	% Finite domain constraints


% ---------------------------------------------------------------------- %
%                                                                        %
%                        PREDICAT PRINCIPAL                              %
%                                                                        %
% ---------------------------------------------------------------------- %

go :- Lconvives = [  manon, alice, juliette, lucie, charlotte, olivia, margaux,
                    jules, hugo, tom, louis, paul, jean, antoine  ],
      table(Lconvives), !.


table(Lconvives) :-
    length([anne,martin|Lconvives],Nb),
    produire_lassoc([anne,martin|Lconvives],Nb,Lassoc),

    alternance_cercles(Lassoc,Nb),
    meme_hobby(Lassoc, Nb),
    en_couple_pas_cote_a_cote(Lassoc,Nb),
    pas_incompatibilite(Lassoc,Nb),

    places_differentes(Lassoc),
    label_places(Lassoc),

    sort(2,@<,Lassoc,Lassoc_trie),
    impression_table(Lassoc_trie).




% ---------------------------------------------------------------------- %
%                                                                        %
%                          LISTE ASSOCIATIVE                             %
%                                                                        %
% ---------------------------------------------------------------------- %

%% 
% produire_lassoc(+Lpers,+Nb,-Lassoc)
% 
% pour une liste de personnes données Lpers, crée dans
% Lassoc une association pers_var(personne,var) liant chaque personne à une variable 
% et définissant le domaine de celle-ci comme 1 . . . Nb ;
% 
produire_lassoc([],_,[]).
produire_lassoc([H|T], Nb, [pers_var(H,V)| Rs]) :-
  V in 1..Nb,
  produire_lassoc(T,Nb,Rs).


% ---------------------------------------------------------------------- %
%                                                                        %
%                               CONTRAINTES                              %
%                                                                        %
% ---------------------------------------------------------------------- %

% Alternance cercles
% ------------------
% alternance_cercles(+Lassoc, +Nb)
% 
% Sur base de la liste Lassoc, spécifie que des personnes d'un
% même cercle ne peuvent être assises l'une à côté de l'autre ;     
% 
alternance_cercles([Pr_Lassoc,Snd_Lassoc| T ], Nb) :-
  Pivot is Nb//2,
  numlist(2,Nb,L),
  delete(L, Pivot, Ls),
  include(impaire, Ls, L_place_impaire),
  include(paire, Ls, L_place_paire),
  append([1,Milieu],L_place_impaire ,L_impaire),
  append([1,Milieu], L_place_paire, L_paire),

  fixer_place(Pr_Lassoc, 1),
  fixer_place(Snd_Lassoc, Milieu),
  alternance(T, L_paire, L_impaire).


fixer_place(pers_var(_,V),N) :- V #= N.

alternance([],_,_).
alternance([pers_var(P, V)| Rs], L_paire, L_impaire) :-
  (
    cercle(P,philo) 
    -> reduire_place(V, L_paire)
    ;  reduire_place(V, L_impaire)
  ),
  alternance(Rs, L_paire, L_impaire).

reduire_place(_,[]).
reduire_place(D, [H|T]) :-
  D #\= H,
  reduire_place(D, T).

impaire(N) :- (N mod 2) #= 1.
paire(N)  :- (N mod 2) #= 0.


% meme_hobby(+Lassoc, +Nb) :-
% 
% sur base de la liste Lassoc, spécifie que des personnes ne partageant
% pas un même hobby ne peuvent être l'une à côté de l'autre
% 
% ----------

meme_hobby([],_).
meme_hobby( [ pers_var(P, Var) | T] , _ ) :-
  meme_hobby(pers_var(P, Var) , T),
  meme_hobby(T,_).

meme_hobby( pers_var(P1, V1) , [ pers_var(P2, V2) | T] ) :-
  hobby(P1, L_hb1),  hobby(P2, L_hb2),
  ( 
    not(is_in(L_hb1, L_hb2))
  	->	switch_place(V1, V2) 
  	; !
  ),
  meme_hobby( pers_var(P1, V1) , T).

meme_hobby(_,[]).


is_in([H|Q],L) :- ( not(member(H,L)) -> is_in(Q,L);!).

switch_place(V1, V2) :- V1 #> V2+1 ; V2 #> V1+1.


% en_couple_pas_cote_a_cote(+Lassoc, +Nb) :- 
% 
% En couple pas cote a cote
% 
% % Sur base de la liste Lassoc, spécie que les personnes
% en couple ne peuvent être l'une à côté de l'autre 
% -------------------------

en_couple_pas_cote_a_cote([],_).
en_couple_pas_cote_a_cote( [ pers_var(P, V) | T] , _ ) :-
  en_couple_pas_cote_a_cote( pers_var(P, V) , T),
  en_couple_pas_cote_a_cote(T,_).

en_couple_pas_cote_a_cote( pers_var(P1, V1) , [ pers_var(P2, V2) | T ] ) :-
  ( couple(P1, P2) 
  	-> switch_place(V1, V2) 
  	; !
  ),
  en_couple_pas_cote_a_cote( pers_var(P1, V1) , T).
en_couple_pas_cote_a_cote(_,[]).

couple(X ,Y) :- en_couple(Y, X); en_couple(X, Y).


% pas_incompatibilite(+Lassoc, +Nb) :- 
% 
% sur base de la liste Lassoc, spécie que des personnes liées
% par une relation d'incompatibilité ne peuvent être assises l'une à côté de l'autre
% --------------------- 

pas_incompatibilite([],_).
pas_incompatibilite([ pers_var(P, V) | T] , _ ) :-
  pas_incompatibilite( pers_var(P, V) , T),
  pas_incompatibilite(T,_).
pas_incompatibilite( pers_var(P1, V1) , [ pers_var(P2, V2) | T] ) :-
  ( incompatibilite(P1, P2) 
  	-> switch_place(V1, V2)
  	; !
  ),
  pas_incompatibilite( pers_var(P1, V1) , T ).

pas_incompatibilite(_,[]).

incompatibilite(X, Y) :-  incompatible(X, Y) ; incompatible(Y, X).


  
% Personnes a des places differentes
% 
% ----------------------------------

places_differentes(Lassoc) :-
  separation(Lassoc, L_var),
  all_different(L_var).

separation([], []).
separation([pers_var(_,V)|T], [V|Rs]) :-
	separation(T, Rs).


% ---------------------------------------------------------------------- %
%                                                                        %
%                                LABELING                                %
%                                                                        %
% ---------------------------------------------------------------------- %


label_places(Lassoc) :-
  separation(Lassoc, L_var),
  label(L_var).


% ---------------------------------------------------------------------- %
%                                                                        %
%                                IMPRESSION                              %
%                                                                        %
% ---------------------------------------------------------------------- %

impression_table([]) :- !, nl.
impression_table([pers_var(P,V)|T]) :-
    nl, format('~w ~d ~w ~a',['Place ',V, ' :', P]),
    impression_table(T).



% ---------------------------------------------------------------------- %
%                                                                        %
%                            BASE DE DONNEES                             %
%                                                                        %
% ---------------------------------------------------------------------- %

en_couple(anne,martin).
en_couple(manon,jules).
en_couple(juliette,tom).
en_couple(charlotte,paul).

cercle(anne,philo).
cercle(manon,philo).
cercle(alice,philo).
cercle(juliette,philo).
cercle(lucie,philo).
cercle(charlotte,philo).
cercle(olivia,philo).
cercle(margaux,philo).

cercle(martin,info).
cercle(jules,info).
cercle(hugo,info).
cercle(tom,info).
cercle(louis,info).
cercle(paul,info).
cercle(jean,info).
cercle(antoine,info).

hobby(anne,[sport,lecture,voyages]).
hobby(manon,[lecture,voyages]).
hobby(alice,[lecture,voyages]).
hobby(juliette,[sport,voyages]).
hobby(lucie,[lecture]).
hobby(charlotte,[lecture]).
hobby(olivia,[sport,lecture]).
hobby(margaux,[sport]).

hobby(martin,[sport,lecture,voyages]).
hobby(jules,[sport,lecture]).
hobby(hugo,[sport,lecture]).
hobby(tom,[sport,voyages]).
hobby(louis,[sport,lecture]).
hobby(paul,[sport]).
hobby(jean,[sport,lecture]).
hobby(antoine,[sport,lecture]).

incompatible(manon,louis).
incompatible(charlotte,antoine).
incompatible(margaux,hugo).