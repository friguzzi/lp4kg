
:-ensure_loaded(inst100).

:-ensure_loaded(train).

:- multifile t/4.
%:-ensure_loaded(valid3).
:-ensure_loaded(test).
:-ensure_loaded(out_no_inv).
main:-
  %findall(rank(G,A,Ans),i(G,A,Ans),TestAtoms),
  out(R00),
  maplist(generate_cl,R00),
%  concurrent_maplist(rank_ans,TestAtoms).

  concurrent_forall(i(G,A,Ans),rank_ans(rank(G,A,Ans))).

generate_cl((tt(H,R,T):P:-Body)):-!,
   and2list(Body,BL0),
   maplist(process_lit,BL0,BL1),
   list2and(BL1,Body1),
   term_variables(Body,Vars),
   assertz((target(H,R,T,P):-(once((Body1,oi(Vars)))))).

process_lit(t(S,R,T),t(S,R,T)).

and2list((A,B),[A|L]):-
  !,
  and2list(B,L).

and2list(A,[A]).

list2and([A],A):-
  !.

list2and([A|L],(A,B)):-
  list2and(L,B).

compute_prob(G,P,(Prob-V)):-
  prob_lift_int(G,P,Prob),!,
  arg(3,G,V).

rr(Rank,RR):-
  RR is 1/Rank.


rank_ans(rank(Ex,CorrAns,InstArg)):-
  Ex=..[_Pred,_,Ent,Rel,CorrAns],
  maplist(create_at(Ent,Rel),InstArg,Inst,Probs),
  maplist(compute_prob,Inst,Probs,Answers),
  sort(0,@>=,Answers,RankedAnswers),
  with_mutex(write_rank,(write_canonical(rank(Ex,CorrAns,RankedAnswers)),writeln('.'))).
/*
  statistics,
  statistics(stack,S),
  format(user_error,"stack=~D\n",[S]),
  statistics(heapused,H),
  writeln(user_error,heapused=H).
*/

create_at(Ent,Rel,Tail,At,P):-
  At=..[target,Ent,Rel,Tail,P].

prob_lift_int(H,P,Prob):-
  findall(P,call(H),L),
  compute_prob_ex(L,1,PG0),
  Prob is 1-PG0.

theory_counts([],_M,_H,[]).

theory_counts([(H,B,_V,_P)|Rest],M,E,[MI|RestMI]):-
  test_rule(H,B,M,E,MI),
  theory_counts(Rest,M,E,RestMI).

compute_prob_ex([],PG,PG).

compute_prob_ex([P|R],PG0,PG):-
  PG1 is PG0*(1-P),
  compute_prob_ex(R,PG1,PG).

test_rule(H,B,M,E,N):-
 findall(1,(H=E,M:B),L),
 length(L,N).

theory_counts_sv([],_M,_H,[]).

theory_counts_sv([(H,B,_P)|Rest],M,E,[MI|RestMI]):-
  copy_term((H,B),(H1,B1)),
  test_rule_sv(H1,B1,M,E,MI),
  theory_counts_sv(Rest,M,E,RestMI).

test_rule_sv(H,B,M,E,N):-
  term_variables(B,Vars),
  H=E,M:B,oi(Vars),!,
  N=1.

test_rule_sv(_H,_B,_M,_E,0).

oi(Vars):-
  sort(Vars,VarsOI),
  length(VarsOI,LOI),
  length(Vars,L),
  L=LOI.

:- initialization(main,main).
