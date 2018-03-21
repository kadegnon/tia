% Student exercise profile
:- set_prolog_flag(occurs_check, error).        % disallow cyclic terms
:- set_prolog_stack(global, limit(8 000 000)).  % limit term space (8Mb)
:- set_prolog_stack(local,  limit(2 000 000)).  % limit environment space


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Espace Etats : 
% 		{(B,E,A,L, Lmp) :
% 				B v E v A v L :- { Gauche, Droite }.
% 				Lmp :- { gauche,droite}
% 		}
% 				
% 	Bg,Eg,Ag,Lg	: {Chaque membre du groupe se trouvant à gauche du pont } 
% 	Bd,Ed,Ad,Ld	: {Chaque membre du groupe se trouvant à droite du pont } 
% 			  L	: Coté ou se trouve la lampe
% 
% 
% Etat Initial 	: (g,g,g,g, Gauche)
% Etat Final 	: (d,d,d,d, Droite)
% 
% Operateurs 	: 
%		amener		: EE x Member x Member X TempsTotal ===> EE
%		revenir		: EE x Member x Lampe X TempsTotal ===> EE
%		
%		amener( etat(Bg,Eg,Ag,Lg, Bg, Lgauche), Temps) 
%			= etat(Bd,Eg,Ag,Lg, Ldroite) 
%		{ Temps + duree(Bono) <= Temps }
%		
%		amener( etat(Bg,Eg,Ag,Lg, Bg,Eg, Lgauche), Temps) 
%			= etat(Bd,Ed,Ag,Lg, Ldroite) 
%		{ Temps + duree(Bono) <= Temps }
%		
%		amener( etat(Bg,Eg,Ag,Lg, Bg, Lgauche), Temps) 
%			= etat(Bd,Eg,Ag,Lg, Ldroite) 
%		{ Temps + duree(Bono) <= Temps }
%				
%		amener( etat(Bg,Eg,Ag,Lg, Bg, Lgauche), Temps) 
%			= etat(Bd,Eg,Ag,Lg, Ldroite) 
%		{ Temps + duree(Bono) <= Temps }
%		
%		
%		revenir( etat(Bd,Edge,Adam,Larry, Bd, Ldroite), Temps) 
%			= etat(Bd,Edge,Adam,Larry, Ldroite) 
%		{ Temps + duree(Bono) <= Temps }
%		
%		
%

temps(bono, 1).
temps(edge, 2).
temps(adam, 5).
temps(larry,10).

min(T1,T2,T1) :- T1 > T2,!.
min(T1,T2,T2) :- T1 =< T2.

temps_min(U1,U2,U,T) :- temps(U1,T1),temps(U2,T2), min(T1,T2,T), temps(U,T).
temps_min(U1,U2,T) :- temps_min(U1,U2,_,T).

est_dans_les_temps(TempsTrajet) :- TempsTrajet =< 17.

changer_direction(gauche,droite).
changer_direction(droite,gauche).


 /** Bono et Edge traversent ensemble **/
amener(etat(Bono,Edge,Adam,Larry, Bono, Lamp), Temps) :- 
    temps_min(bono,edge, TempsTrav),
    TempsTrajet is Temps + TempsTrav,
    est_dans_les_temps(TempsTrajet),
    changer_direction(Bono, Bdir),
    changer_direction(Edge, Edir),
    changer_direction(Lamp, LmpDir),
    revenir( etat(Bdir,Edir,Adam,Larry, Bdir, LmpDir) ,TempsTrajet).

 /** Bono et Adam traversent ensemble **/
amener(etat(Bono,Edge,Adam,Larry, Bono, Lamp), Temps) :- 
    temps_min(bono,adam, TempsTrav),
    TempsTrajet is Temps + TempsTrav,
    est_dans_les_temps(TempsTrajet),
    changer_direction(Bono, Bdir),
    changer_direction(Adam, Adir),
    changer_direction(Lamp, LmpDir),
    revenir( etat(Bdir,Edge,Adir,Larry, Bdir, LmpDir) ,TempsTrajet).

 /** Bono et Larry traversent ensemble **/
amener(etat(Bono,Edge,Adam,Larry, Bono, Lamp), Temps) :- 
    temps_min(bono,larry, TempsTrav),
    TempsTrajet is Temps + TempsTrav,
    est_dans_les_temps(TempsTrajet),
    changer_direction(Bono, Bdir),
    changer_direction(Larry, Ldir),
    changer_direction(Lamp, LmpDir),
    revenir( etat(Bdir,Edge,Adam,Ldir, Bdir, LmpDir) ,TempsTrajet).

 /** Edge et Adam traversent ensemble **/
amener(etat(Bono,Edge,Adam,Larry, Edge, Lamp), Temps) :- 
    temps_min(edge,adam, TempsTrav),
    TempsTrajet is Temps + TempsTrav,
    est_dans_les_temps(TempsTrajet),
    changer_direction(Edge, Edir),
    changer_direction(Adam, Adir),
    changer_direction(Lamp, LmpDir),
    revenir( etat(Bono,Edir,Adam,Larry, Edir, LmpDir) ,TempsTrajet).

 /** Edge et Larry traversent ensemble **/
amener(etat(Bono,Edge,Adam,Larry, Edge, Lamp), Temps) :- 
    temps_min(edge,larry, TempsTrav),
    TempsTrajet is Temps + TempsTrav,
    est_dans_les_temps(TempsTrajet),
    changer_direction(Edge, Edir),
    changer_direction(Larry, Ldir),
    changer_direction(Lamp, LmpDir),
    revenir( etat(Bono,Edir,Adam,Ldir, Edir, LmpDir) ,TempsTrajet).

 /** Adam et Larry traversent ensemble **/
amener(etat(Bono,Edge,Adam,Larry, Adam, Lamp), Temps) :- 
    temps_min(larry,adam, TempsTrav),
    TempsTrajet is Temps + TempsTrav,
    est_dans_les_temps(TempsTrajet),
    changer_direction(Larry, Ldir),
    changer_direction(Adam, Adir),
    changer_direction(Lamp, LmpDir),
    revenir( etat(Bono,Edir,Adam,Larry, Edir, LmpDir) ,TempsTrajet).








/* Bono reviens tout-seul */
revenir( etat(Bono,Edge,Adam,Larry, Bono, Lamp), Temps) :- 
    temps(bono,Tb), TempsTrajet is Temps + Tb,
    est_dans_les_temps(TempsTrajet),
    changer_direction(Bono, Bdir),
    changer_direction(Lamp, LmpDir),
    amener( etat(Bdir,Edge,Adam,Larry, Bdir, LmpDir) ,TempsTrajet)
.

/* Edge reviens */
revenir( etat(Bono,Edge,Adam,Larry, Edge, Lamp), Temps) :- 
    temps(edge,Te), TempsTrajet is Temps + Te,
    est_dans_les_temps(TempsTrajet),
    changer_direction(Edge, Edir),
    changer_direction(Lamp, LmpDir),
    amener( etat(Bono,Edir,Adam,Larry, Edir, LmpDir) ,TempsTrajet)
    .
    
/* Adam reviens */
revenir( etat(Bono,Edge,Adam,Larry, Adam, Lamp), Temps) :- 
    temps(adam,Ta), TempsTrajet is Temps + Ta,
    est_dans_les_temps(TempsTrajet),
    changer_direction(Adam, Adir),
    changer_direction(Lamp, LmpDir),
    amener( etat(Bono,Edir,Adir,Larry, Edir, LmpDir) ,TempsTrajet)
    .

/* Larry reviens */
revenir( etat(Bono,Edge,Adam,Larry, Edge, Lamp), Temps) :- 
    temps(larry,Te), TempsTrajet is Temps + Te,
    est_dans_les_temps(TempsTrajet),
    changer_direction(Larry, Ldir),
    changer_direction(Lamp, LmpDir),
    amener( etat(Bono,Edir,Adam,Larry, Ldir, LmpDir) ,TempsTrajet)
    .
    
ecrire([]).
ecrire([H|T]) :- write(H), nl, ecrire(T).

/** <examples> Your example queries go here, e.g.
?- member(X, [cat, mouse]).
*/
