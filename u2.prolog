% Student exercise profile
:- set_prolog_flag(occurs_check, error).        % disallow cyclic terms
:- set_prolog_stack(global, limit(8 000 000)).  % limit term space (8Mb)
:- set_prolog_stack(local,  limit(2 000 000)).  % limit environment space

:- use_module(library(lists)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%

time(bono, 	1).
time(edge, 	2).
time(adam, 	5).
time(larry, 10).

% on_time(+U2Member, +CurrentTime, -TimeForMove).
on_time(U1, T, Tt) :- 
    time(U1, TU1), 
    Tt is T + TU1, Tt =< 17.

% on_time(+U2Member, +U2Member, +CurrentTime, -TimeForMove).
on_time(U1, U2, T, Tt) :-
    max_time(U1,U2, Tmax),
    Tt is T + Tmax,
    Tt =< 17.


% max_time(+U2Member, +U2Member, -MaxTime).
max_time(U1, U2, T) :- 
    time(U1, TU1), time(U2, TU2), 
    (TU1 =< TU2
    	-> T = TU2
    	;  T = TU1
    ).


move(U1, Members, RestMembers) :-
    member(U1, Members), delete(Members, U1, RestMembers).

move(U1, U2, Members, RestMembers) :-
    member(U1, Members), delete(Members, U1, Rest),
	member(U2, Rest), delete(Rest, U2, RestMembers).


%state( (left_side_members, right_side_members), lamp_side, Totaltime), Transition_made).

state((LSM, RSB), l, T, [crossing(U1,U2) | RestMembers]) :- 
    move(U1, U2, LSM, LSMRestMembers),
    on_time(U1, U2, T, Tt),
    NewRSBMembers = [U1,U2|RSB],
    state((LSMRestMembers, NewRSBMembers), r, Tt, RestMembers).

state((LSM, RSB), l, T, [crossing(U1) | RestMembers]) :- 
    move(U1, LSM, LSMRest),
    on_time(U1, T, Tt),
    RSBWithCrossedMember = [U1|RSB],
    state((LSMRest, RSBWithCrossedMember), r, Tt, RestMembers).

state((LSM, RSB), r, T, [back(U1) | RestMembers]) :- 
    move(U1, RSB, RSBRest),
    on_time(U1, T, Tt),
    LSMWithCrossedMember = [U1|LSM],
    state((LSMWithCrossedMember, RSBRest), l, Tt, RestMembers).

state((LSM, RSB), r, T, [back(U1,U2) | RestMembers]) :- 
    move(U1, U2, RSB, RSBRest),
    on_time(U1, U2, T, Tt),
    NewLSMMembers = [U1,U2|LSM],
    state((NewLSMMembers, RSBRest), l, Tt, RestMembers).

%% Final State : U2 members on the right side with the lamp.
state(([], RSB), r, 17, []) :- 
    member(bono, RSB), member(adam, RSB),
    member(edge, RSB), member(larry, RSB).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main predicat to launch the search for all transitions
%

u2(Trans) :- state(([bono,edge,adam,larry],[]), l , 0 , Trans).
is_solution :- Trans = [
               		crossing(edge, bono), 
                    back(bono), 
                    crossing(larry, adam), 
                    back(edge), 
                    crossing(edge, bono)
              ], u2(Trans), !.

solution :- 
    u2(L), 
    writeln("***"), 
    write_moves(L).


write_moves([crossing(U1,U2) |T ]) :- 
    format("~s crossing with ~s~n", [U1, U2]), write_moves(T).
write_moves([crossing(U1) |T ]) :- 
    format("~s crossing ~n", [U1]), write_moves(T).
write_moves([back(U1) |T ]) :- 
    format("~s back~n", U1), write_moves(T).
write_moves([back(U1,U2) |T ]) :- 
    format("~w back with ~s~n", [U1, U2]), write_moves(T).
write_moves([ _ |[]]) :- writeln('*_END_*').
