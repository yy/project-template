import numpy as np
from os.path import join as j
import itertools
import pandas as pd
from snakemake.utils import Paramspace

# Utilities
def param2paramDataFrame(param_list):
    if isinstance(param_list, list) is False:
        param_list = [param_list]
    my_dict = {}
    cols = []
    for dic in param_list:
        my_dict.update(dic)
        cols += list(dic.keys())
    keys, values = zip(*my_dict.items())
    permutations_dicts = [dict(zip(keys, v)) for v in itertools.product(*values)]
    df = pd.DataFrame(permutations_dicts)
    df = df[cols]
    return df

def to_grid_paramspace(param_list):
    df = param2paramDataFrame(param_list)
    return Paramspace(df, filename_params="*")

def to_union_paramspace(param_list):
    df = pd.concat([param2paramDataFrame(l) for l in param_list])
    return Paramspace(df, filename_params="*")

def constrain_by(str_list):
    return "(" + ")|(".join(str_list) + ")"

def to_paramspace(dict_list):
    if isinstance(dict_list, list) is False:
        dict_list = [dict_list]
    my_dict = {}
    cols = []
    for dic in dict_list:
        my_dict.update(dic)
        cols += list(dic.keys())
    keys, values = zip(*my_dict.items())
    permutations_dicts = [dict(zip(keys, v)) for v in itertools.product(*values)]
    df = pd.DataFrame(permutations_dicts)
    df = df[cols]
    return Paramspace(df, filename_params="*")
