:- use_module(library(clpfd)).


% ---------------------------------------------------------------------- %
%                                                                        %
%                        PREDICAT PRINCIPAL                              %
%                                                                        %
% ---------------------------------------------------------------------- %
    
go :- Lconvives = [  manon, alice, juliette, lucie, charlotte, olivia, margaux,
                     jules, hugo, tom, louis, paul, jean, antoine  ],
      table(Lconvives).


table(Lconvives) :-
    length([anne,martin|Lconvives],Nb),
    produire_lassoc([anne,martin|Lconvives],Nb,Lassoc),

    alternance_cercles(Lassoc,Nb),
    meme_hobby(Lassoc,Nb),
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
% produire_lassoc(+Lpers,+Nb,-Lassoc) :- 

/*
pour une liste de personnes données Lpers, crée dans
Lassoc une association pers_var(personne,var) liant chaque personne à une variable et dénissant
le domaine de celle-ci comme 1 . . . Nb ;
 */
produire_lassoc([], [], _).
produire_lassoc([pers, R], Nb, Lassoc) :-
    Place_Nb ins 1..Nb,
    length(Lassoc,L),
    Place_Nb + L #<= Nb,
    
    produire_lassoc(R, Nb, ).

    
% ---------------------------------------------------------------------- %
%                                                                        %
%                               CONTRAINTES                              %
%                                                                        %
% ---------------------------------------------------------------------- %
    
% alternance_cercles(+Lassoc, +Nb) :- 
% Alternance cercles
% ------------------

/*
Sur base de la liste Lassoc, spécifie que des personnes d'un
même cercle ne peuvent être assises l'une à côté de l'autre ;     
*/
alternance_cercles(Lassoc,Nb) :-  true.
    

% meme_hobby(+Lassoc, +Nb) :-
% 
% Meme hobby
% ----------

/*
sur base de la liste Lassoc, spécie que des personnes ne partageant
pas un même hobby ne peuvent être l'une à côté de l'autre ;
*/
meme_hobby(Lassoc,Nb) :-  true.


% en_couple_pas_cote_a_cote(+Lassoc, +Nb) :- 
% 
% En couple pas cote a cote
% -------------------------

/*
Sur base de la liste Lassoc, spécie que les personnes
en couple ne peuvent être l'une à côté de l'autre ;
*/
en_couple_pas_cote_a_cote(Lassoc,Nb) :-  true.


% pas_incompatibilite(+Lassoc, +Nb) :- 
% 
% Pas d incompatibilite
% ---------------------    
/*
sur base de la liste Lassoc, spécie que des personnes liées
par une relation d'incompatibilité ne peuvent être assises l'une à côté de l'autre
*/
pas_incompatibilite(Lassoc,Nb) :-  true.
    
    
% Personnes a des places differentes
% ----------------------------------
    
places_differentes(Lassoc) :-   true.



% ---------------------------------------------------------------------- %
%                                                                        %
%                                LABELING                                %
%                                                                        %
% ---------------------------------------------------------------------- %

    
label_places(Lassoc) :-  label(Lassoc).
    

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

cercle(michel,info).
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
    
hobby(michel,[sport,lecture,voyages]).
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
