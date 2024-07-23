

:- include(train).
%:- include(valid).


:- include(theory_no_inv).
r(S,R,T):-
  t(S,R,T).

r(S,i(R),T):-
  t(T,R,S).

main:-
  open('out_conf.pl',write,St),
  in(R),
  maplist(confidence, R, RC, S),
  maplist(write_rule(St),RC,S),
  close(St).

confidence(((tt(A,R,B):_P):-Body),((tt(A,R,B):C):-Body),(SupportBody,SupportRule)):-
  (aggregate_all(count, (A,B),Body,SupportBody)->
    (aggregate_all(count, (A,B),(t(A,R,B),Body),SupportRule)->
      true
    ;
      SupportRule=0
    ), 
    (SupportBody=0->
      C=0
    ;
      C is SupportRule/SupportBody
    )
  ;
    SupportBody=0,
    SupportRule=0,
    C=0
  ).
%,
%  write(((tt(A,R,B):P):-Body)),write(C),write(' '),write(SupportBody),write(' '),write(SupportRule),nl.
  
  
write_rule(S,R,(SB,SR)):-
  write(S,'('),
  write_canonical(S,R),
  write(S,'), %'),
  write(S,SB),write(S,' '),write(S,SR),nl(S).

:- initialization(main,main).