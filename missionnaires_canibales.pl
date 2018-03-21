% embarque( Nb_present_sur_la_barque,
% 			Nb_missionnaires_embarquant,
% 			Nb_canibals_embarquant)
embarque(0,0,1).
embarque(0,1,0).
embarque(0,0,2).
embarque(0,2,0).
embarque(0,1,1).
embarque(1,1,0).
embarque(1,0,1).

% debarque( Nb_missionnaires_sur_barque,
% 			Nb_canibals_sur_barque,
% 			Nb_missionnaires_debarquant,
% 			Nb_canibal_debarquant)
debarque(M,_,1,0) :- 1 =< M.
debarque(_,C,0,1) :- 1 =< C.
debarque(M,_,2,0) :- 2 =< M.
debarque(_,C,0,2) :- 2 =< C.
debarque(M,C,1,1) :- 1 =< M, 1 =< C.

% sain(Nb_missionnaires,Nb_canibal)
sain(0,_).
sain(M,C) :- M > 0, C =< M.

transition( etat(Mg,Cg,Md,Cd,Mb,Cb,gauche),
            etat(Mfg,Cfg,Md,Cd,Mfb,Cfb,gauche),
            monter(I,J) ) :-
  Nb is Mb + Cb,
  embarque(Nb,I,J),
  I =< Mg, J =< Cg,
  Mfg is Mg - I,
  Cfg is Cg - J,
  sain(Mfg,Cfg),
  Mfb is Mb + I,
  Cfb is Cb + J.

transition( etat(Mg,Cg,Md,Cd,Mb,Cb,droite),
            etat(Mg,Cg,Mfd,Cfd,Mfb,Cfb,droite),
            monter(I,J) ) :-
  Nb is Mb + Cb,
  embarque(Nb,I,J),
  I =< Md, J =< Cd,
  Mfd is Md - I,
  Cfd is Cd - J,
  sain(Mfg,Cfg),
  Mfb is Mb + I,
  Cfb is Cb + J.

transition( etat(Mg,Cg,Md,Cd,Mb,Cb,gauche),
            etat(Mfg,Cfg,Md,Cd,Mfb,Cfb,gauche),
            descendre(I,J) ) :-
  debarque(Mb,Cb,I,J),
  Mfg is Mg + I,
  Cfg is Cg + J,
  Mfb is Mb - I,
  Cfb is Cb - J,
  sain(Mfg,Cfg).

transition( etat(Mg,Cg,Md,Cd,Mb,Cb,droite),
          	etat(Mg,Cg,Mfd,Cfd,Mfb,Cfb,droite),
          	descendre(I,J) ) :-
  debarque(Mb,Cb,I,J),
  Mfd is Md + I,
  Cfd is Cd + J,
  Mfb is Mb - I,
  Cfb is Cb - J,
  sain(Mfd,Cfd).

transition( etat(Mg,Cg,Md,Cd,Mb,Cb,gauche),
            etat(Mg,Cg,Md,Cd,Mb,Cb,droite),
            traverser ) :-
  Aux is Mb + Cb,
  1 =< Aux,
  Aux =< 2.

transition( etat(Mg,Cg,Md,Cd,Mb,Cb,droite),
			etat(Mg,Cg,Md,Cd,Mb,Cb,gauche),
			traverser ) :-
  Aux is Mb + Cb,
  1 =< Aux,
  Aux =< 2.

rech(Etat,Etat,[]).
rech(Initial,Final,[Op|Trans]) :-
  transition(Initial,Aux,Op),
  rech(Aux,Final,Trans).


ecrire([]).
ecrire([H|T]) :- write(H), nl, ecrire(T).
recherche(Etat,Etat,[]).
recherche(Init,Final,[monter(I,J), traverser,descendre(K,L)]) :-
  transition(Init,Aux,monter(I,J)),
  transition(Aux,Aaux,traverser),
  transition(Aaux,Final,descendre(K,L)).

recherche(Init,Final,[monter(I,J),
          traverser,descendre(K,L),
          traverser|T]) :-
transition(Init,Aux,monter(I,J)),
transition(Aux,Aaux,traverser),
transition(Aaux,Aaaux,descendre(K,L)),
transition(Aaaux,Aaaaux,traverser),
recherche(Aaaaux,Final,T).

g :- recherche(etat(3,3,0,0,0,0,gauche),
               etat(0,0,3,3,0,0,droite),
               Transitions 
    ),ecrire(Transitions).


is_possible :- Transitions =
  [ monter(0,2), traverser,
  	descendre(0,1), traverser,
  	monter(1,0), traverser,
  	descendre(1,0), traverser,
  	monter(1,0), traverser,
  	descendre(1,0), traverser,
  	monter(0,1), traverser,
  	descendre(0,1), traverser,
  	monter(1,0), traverser,
  	descendre(1,1) 
  ],
  rech( etat(3,3,0,0,0,0,gauche),
  etat(0,0,3,3,0,0,droite),
  Transitions ),!.
