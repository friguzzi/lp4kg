
:-ensure_loaded(train).

:- multifile t/4.
:-ensure_loaded(valid3).
:-ensure_loaded(test2).

:-ensure_loaded(out_no_inv).
main:-
  findall(tt(1,S,R,T),t(2,S,R,T),TestAtoms),
  out(R00),
  maplist(generate_cl,R00,Prog),
  concurrent_maplist(write_ins(Prog),TestAtoms).


generate_cl((tt(H,R,T):_P:-Body),(tt(1,H,R,T),Body1)):-!,
   and2list(Body,BL0),
   maplist(process_lit,BL0,BL1),
   list2and(BL1,Body1).

process_lit(t(S,R,T),t(1,S,R,T)).


and2list((A,B),[A|L]):-
  !,
  and2list(B,L).

and2list(A,[A]).

list2and([A],A):-
  !.

list2and([A|L],(A,B)):-
  list2and(L,B).
rr(Rank,RR):-
  RR is 1/Rank.


write_ins(Prog,Ex):-
  %write(Ex),write(' '),
  Ex=..[Pred,_,Ent,Rel,CorrAns],
  Ex1=..[Pred,1,Ent,Rel,_Arg1],
  findall(Ex1,find_inst(Prog,Ex1),Atoms0),
  sort(Atoms0,Atoms),
  subtract(Atoms,[tt(1,Ent,Rel,Ent)],Atoms1),
  filter_atoms(Atoms1,Inst),
  with_mutex(write_i,(write_canonical(i(Ex,CorrAns,Inst)),writeln('.'))).

filter_atoms([],[]).

filter_atoms([H1|T],[A|T1]):-
  H1=..[tt,1,So,R,A],
  HTrainValid=..[t,3,So,R,A],
  \+ HTrainValid,!,
  filter_atoms(T,T1).

filter_atoms([_A|T],T1):-
  filter_atoms(T,T1).

find_inst(Prog,Ex):-
  member((H,B),Prog),
  H=Ex,B.

:- initialization(main,main).