
:-ensure_loaded(train0).

:- multifile t/4.
:- dynamic a/2.
:-ensure_loaded(valid3).
:-ensure_loaded(test2).
:-ensure_loaded(out_conf_oi).

main(NL,LL):-
  mains,
  mainc,
  findall((G,L,L1),(i(G,_,L),ii(G,_,L1),L\=L1),LL),length(LL,NL).

mains:-
  findall(tt(1,S,R,T),t(2,S,R,T),TestAtoms),
  out(R00),
  maplist(generate_cl,R00,Prog),
  maplist(write_ins(Prog),TestAtoms).
  %concurrent_maplist(write_ins(Prog),TestAtoms).

mainc:-
  findall(tt(1,S,R,T),t(2,S,R,T),TestAtoms),
  out(R00),
  maplist(generate_cl,R00,Prog),
  %maplist(write_ins(Prog),TestAtoms).
  concurrent_maplist(write_insc(Prog),TestAtoms).

generate_cl(R0,(tt(1,H,R,T),Body1)):-!,
   copy_term(R0,(tt(H,R,T):_P:-Body)),
   and2list(Body,BL0),
   maplist(process_lit,BL0,BL1),
   list2and(BL1,Body1).

process_lit(t(S,R,T),t(S,R,T)).


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
  find_inst_100(Prog,Ex,CorrAns,Inst),!,
  %  length(Inst,N),
  %  writeln(n(N)).
  assert(i(Ex,CorrAns,Inst)).

write_insc(Prog,Ex):-
  %write(Ex),write(' '),
  find_inst_100(Prog,Ex,CorrAns,Inst),!,
  %  length(Inst,N),
  %  writeln(n(N)).
  assert(ii(Ex,CorrAns,Inst)).

find_inst_100(Prog,Ex,CorrAns,I):-
  Ex=..[Pred,_,Ent,Rel,CorrAns],
  Ex1=..[Pred,1,Ent,Rel,Arg1],
  copy_term(Prog,Prog1),
  find_inst(Prog1,Ex,CorrAns),!,
  trie_new(Trie),
  trie_insert(Trie,CorrAns),
  copy_term(Prog,Prog2),
  find_inst(Prog2,Trie,count(1),Ex1,Arg1),
  findall(Ans,trie_gen_compiled(Trie,Ans),I).

find_inst_100(_Prog,Ex,CorrAns,[]):-
  Ex=..[_Pred,_,_Ent,_Rel,CorrAns].

find_inst(Prog,Trie,Count,Ex1,Arg1):-
  find_inst(Prog,Ex1,Arg1),
  \+ trie_lookup(Trie,Arg1,_),
  Ex1=tt(1,So,R,A),
  HTrain=..[t,So,R,A],
  HTest=..[t,2,So,R,A],
  HValid=..[t,3,So,R,A],
  \+ HTest,
  \+ HValid,
  \+ HTrain,
  trie_insert(Trie,Arg1),
  check_n(Count).
 
find_inst(_Prog,_Trie,_Count,_Ex1,_Arg1).

check_n(count(N)):-
  N=99,!.

check_n(Count):-
        %       with_mutex(update_n,(
    Count=count(N),
    N1 is N+1,
    nb_setarg(1,Count,N1)
    % ))
    ,
  fail.

freq_ass(D,E,(F-E)):-
  F=D.get(E).

filter_atoms([],_,[]).

filter_atoms([tt(1,_So,_R,CA)|T],CA,[CA|T1]):-!,
  filter_atoms(T,CA,T1).

filter_atoms([H1|T],CA,[A|T1]):-
  H1=..[tt,1,So,R,A],
  HTrain=..[t,So,R,A],
  HTest=..[t,2,So,R,A],
  HValid=..[t,3,So,R,A],
  \+ HTest,
  \+ HValid,
  \+ HTrain,!,
  filter_atoms(T,CA,T1).

filter_atoms([_A|T],CA,T1):-
  filter_atoms(T,CA,T1).

find_inst(Prog,Ex,_Arg):-
  member((H,B),Prog),
  %  copy_term((H1,B1),(H,B)),
  term_variables(B,Vars),
  H=Ex,B,
  oi(Vars).

oi(Vars):-
  sort(Vars,VarsOI),
  length(VarsOI,LOI),
  length(Vars,L),
  L=LOI.

%:- initialization(main,main).
