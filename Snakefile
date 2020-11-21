from os.path import join as j

# You can use config file to set the path variables.
# configfile: "workflow/config.yaml"
# DATA_DIR = config["data_dir"]
# PAPER_DIR = config["paper_dir"]

# Paper
PAPER_DIR = "paper/current"
FIG_DIR = "figs"
PAPER_SRC, SUPP_SRC = [j(PAPER_DIR, f) for f in ("main.tex", "supp.tex")]
PAPER, SUPP = [j(PAPER_DIR, f) for f in ("main.pdf", "supp.pdf")]

# Data
DATA_DIR = "data"
RAW_DATA_DIR = j(DATA_DIR, "raw")
DERIVED_DATA_DIR = j(DATA_DIR, "derived")


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
