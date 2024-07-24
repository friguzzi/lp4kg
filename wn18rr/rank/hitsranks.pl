

:-[rank].

main(H1,H3,H5,H10,MRR):-
  findall(R,rank(_G,_A,R),FilteredRanks),
  findall(A,rank(_,A,_R),Args),
  length(Args,NT),
  maplist(rankl,Args,FilteredRanks,Ranks),
  maplist(hits(Ranks,NT),[1,3,5,10],[H1,H3,H5,H10]),
  maplist(rr,Ranks,RR),
  sum_list(RR,SRR),
  MRR is SRR/NT.

rr(Rank,RR):-
  RR is 1/Rank.

hits(Ranks,N,K,H):-
  maplist(hit(K),Ranks,Hits),
  sum_list(Hits,S),
  H is S/N.

hit(K,R,H):-
  (R=< K->
    H=1
  ;
    H=0
  ).

/**
 * rankl(:Element:term,+OrderedList:list,-Rank:float) is det
 * 
 * The predicate returns the rank of Element in the list OrderedList.
 * Group of records with the same value are assigned the average of the ranks.
 * OrderedList is a list of pairs (S - E) where S is the score and E is the element.
 * 
 * https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.rank.html
 */
rankl(E,L,R):-
  rank_group(L,E,+inf,0.0,1.0,R).

/**
* rank_group(+OrderedList:list,:Element:term,+CurrentScore:float,+LengthOfCurrentGroup:float,+CurrentPosition:float,-Rank:float) is det
* 
* CurrentScore is the score of the current group. LengthOfCurrentGroup is the number of elements in the current group.
* CurrentPosition is the position of the first element in the list.
*/
rank_group([],_E,_S,_NG,_N,+inf).

rank_group([(S1 - E1)|T],E,S,NG,N,R):-
N1 is N+1.0,
(E1==E->
  (S1<S->
    rank_group_found(T,S1,1.0,N1,R)
  ;
    NG1 is NG+1.0,
    rank_group_found(T,S1,NG1,N1,R)
  )
;
  (S1<S->
    rank_group(T,E,S1,1.0,N1,R)
  ;
    NG1 is NG+1.0,
    rank_group(T,E,S1,NG1,N1,R)
  )
).

/**
* rank_group_found(+OrderedList:list,+CurrentScore:float,+LengthOfCurrentGroup:float,+CurrentPosition:float,-Rank:float) is det
* 
* CurrentScore is the score of the current group. LengthOfCurrentGroup is the number of elements in the current group.
* CurrentPosition is the position of the first element in the list. The group contains the element to be ranked.
*/
rank_group_found([],_S,NG,N,R):-
R is N-(NG+1.0)/2.

rank_group_found([(S1 - _E1)|T],S,NG,N,R):-
(S1<S->
  R is N-(NG+1.0)/2
;
  N1 is N+1.0,
  NG1 is NG+1.0,
  rank_group_found(T,S1,NG1,N1,R)
).