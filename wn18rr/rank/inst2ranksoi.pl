
:-ensure_loaded(instoi).

:-ensure_loaded(train).

:- multifile t/4.
%:-ensure_loaded(valid3).
:-ensure_loaded(test2).
:-ensure_loaded(out_conf_oi).
main:-
  findall(rank(G,A,Ans),i(G,A,Ans),TestAtoms),
  out(R00),
  maplist(generate_cl,R00,Prog),
  concurrent_maplist(rank_ans(Prog),TestAtoms).

generate_cl((tt(H,R,T):P:-Body),(tt(1,H,R,T),Body1,P)):-!,
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


compute_correct_answers(Prog,inst(G,A,_),[Answer]):-
  G=..[Pred,_M,Ent,Rel,_],
  G1=..[Pred,Ent,Rel,A],
  compute_prob(Prog,user,3,G1,Answer).

compute_prob(Prog,M,Arg,G,(P-V)):-
  prob_lift_int(G,M,Prog,P),
  arg(Arg,G,V).

rr(Rank,RR):-
  RR is 1/Rank.


rank_ans(Prog,rank(Ex,CorrAns,InstArg)):-
  Ex=..[_Pred,_,Ent,Rel,CorrAns],
  maplist(create_at(Ent,Rel),InstArg,Inst),
  maplist(compute_prob(Prog,user,4),Inst,Answers),
  sort(0,@>=,Answers,RankedAnswers),
  with_mutex(write_rank,(write_canonical(rank(Ex,CorrAns,RankedAnswers)),writeln('.'))).


create_at(Ent,Rel,Tail,At):-
  At=..[tt,1,Ent,Rel,Tail].

prob_lift_int(H,M,Prog,P):-
  theory_counts_sv(Prog,M,H,MI),
  compute_prob_ex(Prog,MI,1,PG0),
  P is 1-PG0.

theory_counts([],_M,_H,[]).

theory_counts([(H,B,_V,_P)|Rest],M,E,[MI|RestMI]):-
  test_rule(H,B,M,E,MI),
  theory_counts(Rest,M,E,RestMI).

compute_prob_ex([],[],PG,PG).

compute_prob_ex([(_,_,P)|R],[MIH|MIT],PG0,PG):-
  PG1 is PG0*(1-P)^MIH,
  compute_prob_ex(R,MIT,PG1,PG).

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