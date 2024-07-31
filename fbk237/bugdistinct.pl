
:-ensure_loaded(train).
:- dynamic t/4.
out([
(tt(A,'/location/statistical_region/gdp_nominal_per_capita./measurement_unit/dated_money_value/currency',B):0.0105363 :-   t(A,'/base/aareas/schema/administrative_area/administrative_area_type',C),  t(D,'/base/aareas/schema/administrative_area/administrative_area_type',C),  t(D,'/location/statistical_region/gdp_nominal./measurement_unit/dated_money_value/currency',B)),
(tt(A,'/location/statistical_region/gdp_nominal_per_capita./measurement_unit/dated_money_value/currency',B):0.00700313 :-   t(C,'/film/film/release_date_s./film/film_regional_release_date/film_release_region',A),  t(C,'/film/film/estimated_budget./measurement_unit/dated_money_value/currency',B))
]).
mainfn(Ans):-
  out(R00),
  maplist(generate_cl,R00,Prog),
  write_ins_fn(Prog,tt(1,'/m/0chghy','/location/statistical_region/gdp_nominal_per_capita./measurement_unit/dated_money_value/currency','/m/0kz1h'),Ans).
mainfa(Ans):-
  out(R00),
  maplist(generate_cl,R00,Prog),
  write_ins_fa(Prog,tt(1,'/m/0chghy','/location/statistical_region/gdp_nominal_per_capita./measurement_unit/dated_money_value/currency','/m/0kz1h'),Ans).



generate_cl((tt(H,R,T):_P:-Body),(tt(1,H,R,T),Body1)):-!,
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

write_ins_fn(Prog,Ex,Inst):-
  %write(Ex),write(' '),
  Ex=..[Pred,_,Ent,Rel,CorrAns],
  Ex1=..[Pred,1,Ent,Rel,_Arg1],
  once(findnsols(100,I,find_inst(Prog,Ex1,CorrAns,I),Inst)).

write_ins_fa(Prog,Ex,Inst):-
  %write(Ex),write(' '),
  Ex=..[Pred,_,Ent,Rel,CorrAns],
  Ex1=..[Pred,1,Ent,Rel,_Arg1],
  findall(I,find_inst(Prog,Ex1,CorrAns,I),Inst).



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

find_inst(Prob,Ex,CorrAns,I):-
  findall(Ex,find_inst(Prob,Ex),Atoms0),
  sort(Atoms0,Atoms),
  filter_atoms(Atoms,CorrAns,Inst),
  member(I,Inst).



find_inst(Prog,Ex):-
  member((H,B),Prog),
  term_variables(B,Vars),
  H=Ex,B,
  oi(Vars).

oi(Vars):-
  sort(Vars,VarsOI),
  length(VarsOI,LOI),
  length(Vars,L),
  L=LOI.

%:- initialization(main,main).
