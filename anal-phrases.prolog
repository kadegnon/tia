
% 
% % Doc grammaire https://www.jerevise.fr/grammaire
% @link http://www.it.uu.se/edu/course/homepage/prognovis/st11/reading/prolog-grammars.pdf
% @link http://www.learnprolognow.org/lpnpage.php?pagetype=html&pageid=lpn-htmlse29
% @link http://www.bowdoin.edu/~allen/nlp/nlp2.html
%
% @title T. I. A. : Traitement du langage naturel - Grammaire francaise
% 
% @author kadegnon
% 



%%%%%%%%%%%%%%%%%%%%%%%%
% Base de Connaissance 
% 

% Determinants - articles
% 
det_term('Le', masc,sing).		det_term('le', masc,sing).
det_term('La',fem,sing).		det_term('la',fem,sing). 
det_term('Un',masc,sing).		det_term('un',masc,sing). 
det_term('Une',fem,sing).		det_term('une',fem,sing). 
det_term('Les',_,plu).			det_term('les',_,plu).
det_term('Ces',_,plu).			det_term('ces',_,plu).
det_term('Des',_,plu).			det_term('des',_,plu).
det_term('Mes',_,plu).			det_term('mes',_,plu).
det_term('Ses',_,plu).			det_term('ses',_,plu).
det_term('Tes',_,plu).			det_term('tes',_,plu).


% Mots communs
% 
det_nom(chat, masc, sing).		det_nom(chats, masc, plu). 
det_nom(chatte, fem, sing).		det_nom(chattes, fem, plu). 
det_nom(souris, fem, sing).		det_nom(souris, fem, plu).
det_nom(chien, masc, sing).		det_nom(chiens, masc, plu).
det_nom(chienne, fem, sing).	det_nom(chiennes, fem, plu).
det_nom(voiture, fem, sing).	det_nom(voitures, fem, plu).
det_nom(facteur, masc, sing).	det_nom(facteurs,masc, plu).

	% Infinitifs
	% 
det_nom(manger,_,_).
det_nom(aimer,_,_).
det_nom(regarder,_,_).


% Mots Propres
% 
nom_propre('Jerry', sing).
nom_propre('Elaine', sing).


% Verbe
% 
det_verbe(mange, sing).		det_verbe(mangent, plu).
det_verbe(regarde, sing).	det_verbe(regardent, plu).
det_verbe(a, sing).			det_verbe(ont, plu).
det_verbe(aime, sing).		det_verbe(aiment, plu).
det_verbe(aboie,sing).		det_verbe(aboient,plu).	
det_verbe(ronronne, sing).	det_verbe(ronronnent, plu).


% Adjectifs
% 

adj(belle, fem, sing).		adj(belles, fem, plu).
adj(beau, masc, sing).		adj(beaux, masc, plu).
adj(rouge, _, sing).		adj(rouges, _, plu).
adj(jaune, _, sing).		adj(jaunes, _, plu).
adj(vert, masc, sing).		adj(verts, masc, plu).
adj(verte, fem, sing).		adj(vertes, fem, plu).
adj(bleu, masc, sing).		adj(bleus, masc, plu).
adj(bleue, fem, sing).		adj(bleues, fem, plu).
adj(gros, masc, sing).		adj(gr, masc, plu).
adj(grosse, fem, sing).		adj(grosses, fem, plu).
adj(petit, masc, sing).		adj(petits, masc, plu).
adj(petite, fem, sing).		adj(petites, fem, plu).



conjonction(et,plu).
conjonction(ou,sing).


adverbe(doucement).
adverbe(cordialement).
adverbe(abondamment).
adverbe(festivement).
adverbe(probablement).
adverbe('peut-être').
adverbe(vraiment).
adverbe(trop).



%%%%%%%%%%%%%%%%%%%%%%%%
% Predicats
% 

phrase_correcte(L) :- phr(L,[]),!.

phr(Li,Lo) :- gn(Li,Nombre,L),gv(L, Nombre, Lo).
phr(Li,Lo) :- 	% Elaine et le facteur ....   % Elaine et Jerry .... 
    gn(Li,_,[X|L1]),
    conjonction(X,Nombre),
    gn(L1,_,L2),gv(L2, Nombre, Lo).

% Groupe nominale
% 
gn([Nom|T],Nombre,T) :- nom_propre(Nom,Nombre).
gn(Li,Nombre,Lo) :- det(Genre,Nombre, Li,L),nom(Genre,Nombre, L,Lo).
gn(Li,Nombre,Lo) :- 	% la petite voiture 
    det(Genre,Nombre, Li,L1), adjectif(Genre,Nombre,L1,L2), nom(Genre,Nombre, L2,Lo).
gn(Li,Nombre,Lo) :- 	% la voiture bleue
    det(Genre,Nombre, Li,L1), nom(Genre,Nombre, L1,L2), adjectif(Genre,Nombre,L2,Lo).
gn(Li,_,Lo) :- 	% la petite voiture bleue
    det(Genre,Nombre, Li,L1), 
    adjectif(Genre,Nombre,L1,L2), 
    nom(Genre,Nombre, L2,L3), 
    adjectif(Genre,Nombre,L3,Lo).

% Groupe Verbale
% 
gv(Li,Nombre,Lo) :- verbe(Li,Nombre,Lo).
gv(Li,Nombre,Lo) :- verbe(Li,Nombre,L), gn(L,Nombre,Lo).
gv(Li,Nombre,Lo) :- verbe(Li,Nombre,[Adv|Lo]), adverbe(Adv).
gv(Li,Nombre,Lo) :- 	% ... aime trop manger
    verbe(Li,Nombre,[Adv|T]), adverbe(Adv),nom(_,_,T,Lo).			
gv(Li,Nombre,Lo) :-		% ... aime manger abondamment
    verbe(Li,Nombre,L1), nom(_,_,L1,[Adv|Lo]),adverbe(Adv).	
gv(Li,Nombre,Lo) :- 	% ... aime  vraiment les chiens
    verbe(Li,Nombre,[Adv|T]), adverbe(Adv),gn(T,Nombre,Lo).


% Determinant
% 
det(Genre,Nombre, Li,Lo) :- terminal(X, Li,Lo), det_term(X, Genre,Nombre).
adjectif(Genre,Nombre, Li,Lo) :- terminal(X, Li,Lo), adj(X, Genre,Nombre).
% conjonction(Nombre,Li,Lo) :- terminal(X, Li,Lo), conj(X,Nombre).
nom(Genre,Nombre, Li,Lo) :- terminal(X, Li,Lo), det_nom(X, Genre,Nombre).
nom(Genre,Nombre, Li,Lo) :- Nombre = sing, terminal(X, Li,Lo), nom_propre(X, Genre). 
verbe(Li,Nombre,Lo) :- terminal(X, Li,Lo), det_verbe(X,Nombre).

terminal(Mot, [Mot|L],L).


%%%%%%%%%%%%%%%%%%%%%
% TEST 
% 
% 
% Phares Correct
% -------------
% ?- phrase_correcte([le,chat,mange,la,souris]).
% ?- phrase correcte([la,chat,mange,le,souris]).
% 
% La souris mange le chat.
% Jerry a une voiture.							?- phrase_correcte(['Jerry',a,une,voiture]).
% Jerry a une petite voiture. 					?- phrase_correcte(['Jerry',a,une,petite,voiture]).
% Elaine a une voiture bleue.					?- phrase_correcte(['Elaine',a,une,voiture,bleue]).
% Elaine a une petite voiture bleue.			?- phrase_correcte(['Elaine',a,une,petite,voiture,bleue]).
% Elaine ou Jerry a un petit chat bleu.			?- phrase_correcte(['Elaine',ou,'Jerry',a,un,petit,chat,bleu]).
% Elaine et Jerry aiment vraiment les chiens.	?- phrase_correcte(['Elaine',et,'Jerry',aiment,vraiment,les,chiens]).
% Elaine et le facteur aiment trop manger.		?- phrase_correcte(['Elaine',et,le,facteur,aiment,trop,manger]).
% Elaine et Jerry aiment manger festivement.	?- phrase_correcte(['Elaine',et,'Jerry',aiment,manger,festivement]).
% Elaine et Jerry ont une belle voiture bleue.	?- phrase_correcte(['Elaine',et,'Jerry',ont,une,belle,voiture,bleue]).
% Un chien aboie.								?- phrase_correcte(['Un',chien,aboie]).
% Un petit chien aboie.							?- phrase_correcte(['Un',petit,chien,aboie]).
% Un chien aboie Elaine.						?- phrase_correcte(['Un',chien,aboie, 'Elaine']).
% Un petit chien aboie.							?- phrase_correcte(['Un',petit,chien,aboie]).
% Un chien aboie festivement.					?- phrase_correcte(['Un',chien,aboie,festivement]).
% Le chat ronronne doucement.					?- phrase_correcte(['Le',chat,ronronne,doucement]).

% Erreur de syntaxe :
% -----------------------------------
% 
% Elaine et Jerry aime les chiens.				?- phrase_correcte(['Elaine',et,Jerry,aime,les,chiens]).
% Elaine et Jerry aiment les chien.(pluriel) 	?- phrase_correcte(['Elaine',et,'Jerry',aiment,les,chien]).
% % Elaine et Jerry aiment un chienne.			?- phrase_correcte(['Elaine',et,'Jerry',aiment,un,chienne]).
% Elaine et Jerry aiment une chien.				?- phrase_correcte(['Elaine',et,'Jerry',aiment,une,chien]).
% Elaine et Jerry aiment un chiennes.			?- phrase_correcte(['Elaine',et,'Jerry',aime,un,chiennes]).
% Elaine et Jerry ont une gros voiture vert.	?- phrase_correcte(['Elaine',et,'Jerry',a,une,gros,voiture,vert]).
