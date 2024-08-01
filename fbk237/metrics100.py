from clause import Ranking
from clause import TripleSet
# ** Example for creating ranking and corresponding rule features **

target = f"test.txt"

out = f"ranking-file-100.txt"

testset = TripleSet(target)
ranking = Ranking(out)

ranking.compute_scores(testset.triples,False, True)

print("*** EVALUATION RESULTS ****")
print("Num triples: " + str(len(testset.triples)))
print("hits@1  " + '{0:.6f}'.format(ranking.hits.get_hits_at_k(1)))
print("hits@3  " + '{0:.6f}'.format(ranking.hits.get_hits_at_k(3)))
print("hits@5  " + '{0:.6f}'.format(ranking.hits.get_hits_at_k(5)))
print("hits@10 " + '{0:.6f}'.format(ranking.hits.get_hits_at_k(10)))
print("MRR     " + '{0:.6f}'.format(ranking.hits.get_mrr()))
print()
