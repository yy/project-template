from os.path import join as j

# configfile: "workflow/config.yaml"

CURR_PAPER_DIR = "paper/current/"

PAPER_SRC = j(CURR_PAPER_DIR, "main.tex")
PAPER = j(CURR_PAPER_DIR, "main.pdf")
SUPP_SRC = j(CURR_PAPER_DIR, "supp.tex")
SUPP = j(CURR_PAPER_DIR, "supp.pdf")

rule all:
    input:
        PAPER, SUPP

rule paper:
    input:
        PAPER_SRC, SUPP_SRC
    params:
        paper_dir = CURR_PAPER_DIR
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
