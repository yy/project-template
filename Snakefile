rule all:
    input:
        "data/some_data.csv"
    output:
        "data/derived/some_derived_data.csv"
    script:
        "workflow/scripts/process_some_data.py"
