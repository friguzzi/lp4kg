

:-use_module(library(dcg/basics)).

main:-
  tell('test.pl'),
  phrase_from_file(triples,'test.txt'),
  told.

mainv:-
  tell('valid.pl'),
  phrase_from_file(triples,'valid.txt'),
  told.

maint:-
  tell('train.pl'),
  phrase_from_file(triples,'train.txt'),
  told.


triples-->
  triple(H),!,
  {write_canonical(H),writeln('.')},
  triples.

triples--> [].

triple(At)-->
  entity(E1),
  relation(R),
  entity(E2),
  {At =..[t,E1,R,E2]}.

entity(E)-->
  string_without("\t\n\r", ES),
  [_],
  {atom_string(E,ES)}.

relation(R)-->
  entity(R).
