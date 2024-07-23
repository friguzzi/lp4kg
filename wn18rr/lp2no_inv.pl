%:-use_module(library(tipc/tipc_linda)).
%:-use_module(library(apply)).
%:- use_module(library(apply_macros)).

/*
:-include(train).
train:-
  tell('train.txt'),
  t(2,A,REL,B),
  write_canonical(A),write('\t'),write_canonical(REL),write('\t'),write_canonical(B),write('\n'),
  fail.
train:- told.

:-include(valid).
valid:-
  tell('valid.txt'),
  t(2,A,REL,B),
  write_canonical(A),write('\t'),write_canonical(REL),write('\t'),write_canonical(B),write('\n'),
  fail.
valid:- told.

:-include(test).
test:-
  tell('test.txt'),
  t(2,A,REL,B),
  write_canonical(A),write('\t'),write_canonical(REL),write('\t'),write_canonical(B),write('\n'),
  fail.
test:- told.
*/


:- style_check(-discontiguous).
:-include(theory).

main:-
  in(R),
  open('theory_no_inv.pl',write,S),
  maplist(remove_inv,R,R_no_inv),
  writeln(S,'in(['),
  write_rules(R_no_inv,S),
  writeln(S,']).'),
  close(S).


remove_inv( (tt(X,RH,Y):P :- Body),(tt(X,RH,Y):P :- Body_no_inv) ):-
  and2list(Body,BodyL),
  maplist(remove_inv_lit,BodyL,BodyL_no_inv),
  list2and(BodyL_no_inv,Body_no_inv).
%  write_canonical((tt(X,RH,Y):P :- Body_no_inv)).

and2list((A,B),[A|L]):-
  !,
  and2list(B,L).

and2list(A,[A]).

list2and([A],A):-
  !.

list2and([A|L],(A,B)):-
  list2and(L,B).

remove_inv_lit(r(A,i(R),B),t(B,R,A)):-!.
remove_inv_lit(r(A,R,B),t(A,R,B)).



write_rules([(H:P:-B)],S):-!,
  copy_term((H,B),(H1,B1)),
  numbervars((H1,B1),0,_M),
  and2list(B1,BL),
  write(S,'('),
  write_disj_clause(S,([H1:P]:-BL)),
  writeln(S,')').

write_rules(([H:P:-B|T]),S):-!,
  copy_term((H,B),(H1,B1)),
  numbervars((H1,B1),0,_M),
  and2list(B1,BL),
  write(S,'('),
  write_disj_clause(S,([H1:P]:-BL)),
  writeln(S,'),'),
  write_rules(T,S).



write_disj_clause(S,(H:-[])):-!,
  write_head(S,H),
  format(S,".~n~n",[]).

write_disj_clause(S,(H:-B)):-
  write_head(S,H),
  format(S,' :- ',[]),
  write_body(S,B).


write_head(S,[A:1.0|_Rest]):-!,
  format(S,"~q:1.0",[A]).

write_head(S,[A:P,'':_P]):-!,
  format(S,"~q:~g",[A,P]).

write_head(S,[A:P]):-!,
  format(S,"~q:~g",[A,P]).

write_head(S,[A:P|Rest]):-
  format(S,"~q:~g ; ",[A,P]),
  write_head(S,Rest).

write_body(S,[]):-!,
  format(S,"  true",[]).

write_body(S,[A]):-!,
  format(S,"  ~q",[A]).

write_body(S,[A|T]):-
  format(S,"  ~q,",[A]),
  write_body(S,T).
