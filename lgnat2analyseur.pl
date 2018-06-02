phrase_lg --> grp_sujet_sg, grp_verbal_sg | grp_sujet_pl, grp_verbal_pl.

grp_sujet_sg --> nom_propre | det_msg, nom_msg | det_fsg, nom_fsg | det_msg, qual_msg, nom_msg | det_fsg, qual_fsg, nom_fsg | det_msg, nom_msg, qual_msg | det_fsg, nom_fsg, qual_fsg.
grp_sujet_pl --> grp_sujet_sg, conj, grp_sujet_sg | grp_sujet_sg, conj, grp_sujet_pl.

grp_cplt --> nom_propre | grp_nom_com | nom_propre, conj, grp_cplt | grp_nom_com, conj, grp_cplt | inf, adv | inf.

grp_nom_com --> det_msg, nom_msg | det_fsg, nom_fsg | det_mpl, nom_mpl | det_fpl, nom_fpl |
 det_msg, qual_msg, nom_msg | det_mpl, qual_mpl, nom_mpl | det_fsg, qual_fsg, nom_fsg | det_fpl, qual_fpl, nom_fpl |
 det_msg, nom_msg, qual_msg | det_mpl, nom_mpl, qual_mpl | det_fsg, nom_fsg, qual_fsg | det_fpl, nom_fpl, qual_fpl |
 det_msg, qual_msg, nom_msg, qual_msg | det_mpl, qual_mpl, nom_mpl, qual_mpl | det_fsg, qual_fsg, nom_fsg, qual_fsg | det_fpl, qual_fpl, nom_fpl, qual_fpl.
 
grp_verbal_sg --> verbe_sg | verbe_sg, grp_cplt | verbe_sg, adv | verbe_sg, adv, grp_cplt | verbe_sg, grp_cplt, adv.
grp_verbal_pl --> verbe_pl | verbe_pl, grp_cplt | verbe_pl, adv | verbe_pl, adv, grp_cplt | verbe_pl, grp_cplt, adv.

det_msg --> [le] | [un]. 
det_fsg --> [la] | [une].
det_fpl --> [les] | [des].
det_mpl --> [les] | [des].

nom_msg --> [chat] | [chien] | [facteur] | [manteau].
nom_mpl --> [chats] | [chiens] | [facteurs] | [manteaux].
nom_fsg --> [souris] | [voiture] | [chienne] | [chatte].
nom_fpl --> [souris] | [voitures] | [chiennes] | [chattes].

verbe_sg --> [mange] | [regarde] | [aime] | [aboie] | [a] | [déteste] | [aboie_sur] | [ronronne].
verbe_pl --> [aboient] | [mangent] | [regardent] | [aiment] | [ont] | [détestent] | [aboient_sur].

nom_propre --> [jerry] | [elaine].

conj --> [et].

adv --> [cordialement] | [festivement] | [doucement].

qual_msg --> [bleu] | [petit] | [beau].
qual_mpl --> [bleus] | [petits] | [beaux].
qual_fsg --> [bleue] | [petite] | [belle].
qual_fpl --> [bleues] | [petites] | [belles].

inf --> [manger] | [courir].
