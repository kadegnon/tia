:-use_module(library(clpfd)).

solve(Values):-
 Values = [G,R,A,N,D,E,C,I,M],
 Values ins 0..9,
 all_different(Values),
 G #\= 0,
 E #\= 0,
 C #\= 0,
 10000*G + 1000*R + 100*A + 10*N + D + 10000*E + 1000*C + 100*R + 10*A + D #= 100000*C + 10000*I + 1000*N + 100*E + 10*M + A,
 label(Values),
 writeln([' ',G,R,A,N,D]),
 writeln([' ',E,C,R,A,N]),
 writeln([C,I,N,E,M,A]).
