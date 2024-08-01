from c_clause import RankingHandler, Loader
from clause.util.utils import get_base_dir, read_jsonl
from clause import Options
from clause import Ranking
from clause import TripleSet
# ** Example for creating ranking and corresponding rule features **

train = f"train.txt"
# when loading from disk set to "" to not use additional filter
filter_set = f"valid.txt"
target = f"test.txt"

rules = f"out005.txt"

out = f"ranking-file-all.txt"

options = Options()
options.set("ranking_handler.disc_at_least", 20)
options.set("ranking_handler.aggregation_function", "noisyor")
options.set("ranking_handler.num_top_rules", -1)
options.set("ranking_handler.num_threads", -1)
options.set("ranking_handler.topk", 100000000)


options.set("loader.b_min_preds", -1)
options.set("loader.b_min_support", -1)
options.set("loader.b_num_unseen", 0)
options.set("loader.b_min_conf", -1)

# load data and rules
loader = Loader(options=options.get("loader"))
loader.load_data(data=train, filter=filter_set, target=target)
loader.load_rules(rules=rules)

# create ranker
# if later rule features should be returned the respective option has to be set
options.set("ranking_handler.collect_rules", False)
ranker = RankingHandler(options=options.get("ranking_handler"))
# create ranking
ranker.calculate_ranking(loader=loader)
# write complete ranking to file (same as AnyBURL's ranking files)
ranker.write_ranking(path=out, loader=loader)

#head_rules = ranker.get_rules(direction="head", as_string=True)
#tail_rules = ranker.get_rules(direction="tail", as_string=True)

# write rule features
#ranker.write_rules(path="local/rule-feats_head.txt", loader=loader, direction="head", as_string=False)
#ranker.write_rules(path="rule-feats_tail.txt", loader=loader, direction="tail", as_string=False)
