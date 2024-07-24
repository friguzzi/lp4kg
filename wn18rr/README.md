# Confidence computation 

## Computation of the confidence of the rules

run swipl with

```
% swipl confidence.pl
```
run PyClause with 

```
% python confidence.py
```

## Computation of Hits@K and MRR

### With PyClause:

1. computation of the scores of the possible answers
```
% /usr/bin/time python ranking.py 
...
Ranking file written to:  ranking-file.txt
      1,24 real         1,00 user         0,03 sys
```
1. computation of the metrics
```
% /usr/bin/time python metrics.py 
>>> loading triple set from path test.txt ...
>>> ... read and indexed 3134 triples.
*** EVALUATION RESULTS ****
Num triples: 3134
hits@1  0.344288
hits@3  0.452138
hits@5  0.494257
hits@10 0.547543
MRR     0.412144

        0,25 real         0,21 user         0,02 sys
```
### With Prolog
1. computation of all the possible answers
```
% cd rank
% /usr/bin/time swipl computeinsts.pl > inst.pl
        5,79 real         5,59 user         0,16 sys
```
1. computation of the scores for the answers
```
% /usr/bin/time swipl inst2ranks.pl > rank.pl
      283,08 real      2778,12 user        32,34 sys
```
1. computation of the metrics
```
/usr/bin/time swipl hitsranks.pl
0.19495851946394385
0.40523292916400766
0.48851308232291
0.5449904275686024
0.32174862969445756
        2,02 real         1,94 user         0,03 sys
```
