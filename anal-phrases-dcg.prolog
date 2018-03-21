
:- use_rendering(svgtree, [list(false)]).

%%%%%%%%%%%%%%%%%%%%%%%%
% Base de Connaissance 
% 

det(le_nd) --> [le]. 
det(la_nd) --> [la].

nom(chat_nd) --> [chat]. 
nom(souris_nd) --> [souris]. 
verbe(mange_nd) --> [mange]. 
verbe(regarde_nd) --> [regarde].


%%%%%%%%%%%%%%%%%%%%%%%%
% Predicats
% 

phrase_lg(phr_nd(GN,GV)) --> grp_nominal(GN), grp_verbal(GV).

grp_nominal(gn_nd(DET,NOM)) --> det(DET), nom(NOM). 

grp_verbal(gv_nd(V)) --> verbe(V). 
grp_verbal(gv_nd(V,GN)) --> verbe(V), grp_nominal(GN). 


/********************
 * Test
 * 
?- phrase(phrase_lg(Arbre),[le,chat,regarde,la,souris],[]).
?- phrase(phrase_lg(Arbre),[le,chat,X,la,souris],[])..
*/