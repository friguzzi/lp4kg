from c_clause import Loader, RulesHandler
from clause.util.utils import get_base_dir, read_jsonl
from clause import Options
from clause import Ranking
from clause import TripleSet
# ** Example for creating ranking and corresponding rule features **

train = f"train.txt"
# when loading from disk set to "" to not use additional filter
filter_set = f"valid.txt"
target = f"test.txt"

rules = f"theory.txt"

out = f"ranking-file.txt"

options = Options()
options.set("rules_handler.collect_predictions", False)

options.set("loader.b_min_preds", -1)
options.set("loader.b_min_support", -1)
options.set("loader.b_num_unseen", 0)
options.set("loader.b_min_conf", -1)

# load data and rules
loader = Loader(options=options.get("loader"))
loader.load_data(data=train, filter=filter_set, target=target)
loader.load_rules(rules=rules)

rh=RulesHandler(options=options.get("rules_handler"))

rh.calculate_predictions(rules=rules,loader=loader)
rh.write_statistics(path="my-calculated-rules.txt")

