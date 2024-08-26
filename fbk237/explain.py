from c_clause import PredictionHandler, Loader
from clause import Options

from clause.util.utils import read_jsonl
targets= [('/m/014g22','/people/person/spouse_s./people/marriage/spouse','/m/0dx_q')]
train = f"train.txt"
rules = f"out005.txt"
opts = Options()
loader = Loader(opts.get("loader"))
loader.load_data(data=train)
loader.load_rules(rules=rules)

opts.set("prediction_handler.collect_explanations", True)
opts.set("prediction_handler.aggregation_function", "noisyor")
opts.set("prediction_handler.num_top_rules", -1)
scorer = PredictionHandler(options=opts.get("prediction_handler"))

scorer.calculate_scores(triples=targets, loader=loader)
scores_str = scorer.get_scores(as_string=True)
print(scores_str)

scorer.write_explanations(path="my-exp.txt", as_string=True)
