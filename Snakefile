from os.path import join as j

configfile: "workflow/config.yaml"

# Import utilities
include: "workflow/workflow_utils.smk"

#EMB_DIR = j(DATA_DIR, "{data}", "embeddings")
#emb_params ={
#    "directed": ["undirected", "directed"],
#    "window_length": [10],
#    "model_name": ["node2vec", "deepwalk", "adjspec", "leigenmap"],
#    "dim": [64],
#}
#emb_params2 ={
#    "directed": ["undirected", "directed"],
#    "window_length": [10],
#    "model_name": ["node2vec", "deepwalk", "adjspec", "leigenmap"],
#    "dim": [64],
#}
#emb_paramspace = to_union_paramspace([emb_params, emb_param2])
#EMB_FILE = j(EMB_DIR, f"paper_{emb_paramspace.wildcard_pattern}.npz")


DATA_DIR = config["data_dir"]

PAPER_DIR = config["paper_dir"]
PAPER_SRC, SUPP_SRC = [j(PAPER_DIR, f) for f in ("main.tex", "supp.tex")]
PAPER, SUPP = [j(PAPER_DIR, f) for f in ("main.pdf", "supp.pdf")]

rule all:
    input:
        PAPER, SUPP

rule paper:
    input:
        PAPER_SRC, SUPP_SRC
    params:
        paper_dir = PAPER_DIR
    output:
        PAPER, SUPP
    shell:
        "cd {params.paper_dir}; make"


# rule some_data_processing:
    # input:
        # "data/some_data.csv"
    # output:
        # "data/derived/some_derived_data.csv"
    # script:
        # "workflow/scripts/process_some_data.py"
