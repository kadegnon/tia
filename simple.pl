phr  -->  grp_nom, grp_verb. 

grp_nom  -->  det, nom. 

grp_verb  -->  verb, grp_nom. 
grp_verb  -->  verb. 

det  -->  ['le'].
det  -->  ['la'].

nom  -->  ['souris'].
nom  -->  ['chat'].

verb  --> ['aime'].
verb	-->	['mange'].


% phr(['la','souris','aime','le','chat'],[]).
%phrase(phr, ['la','souris','aime','le','chat']).

