import numpy as np
from os.path import join as j
import itertools
import pandas as pd
from snakemake.utils import Paramspace
from random import randint
from time import sleep
import string

# =================
# Utility function
# =================
def make_filename(prefix, ext, names):
    """Build a filename template: prefix_key1={key1}_key2={key2}.ext"""
    retval = prefix
    for key in names:
        retval += "_" + str(key) + "={" + str(key) + "}"
    return retval + "." + ext


def to_paramspace(dict_list):
    """Convert param dict(s) to a Snakemake Paramspace (Cartesian product, ~ separator)."""
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


def partial_format(filename, **params):
    """Format some placeholders, leave the rest as {name}."""
    field_names = [v[1] for v in string.Formatter().parse(filename) if v[1] is not None]
    fields = {field_name:"{"+field_name+"}" for field_name in field_names}
    for k,v in params.items():
        fields[k] = v
    return filename.format(**fields)

def to_list_value(params):
    """Ensure all dict values are lists (wrap scalars)."""
    for k, v in params.items():
        if isinstance(v, list):
            continue
        else:
            params[k]=[v]
    return params

def _expand(filename, **params):
    params = to_list_value(params)
    retval_filename = []
    keys, values = zip(*params.items())
    for bundle in itertools.product(*values):
        d = dict(zip(keys, bundle))
        retval_filename.append(partial_format(filename, **d))
    return retval_filename

def expand(filename, *args, **params):
    """Custom expand() with partial_format support and positional param dicts."""
    retval = []
    if len(args) == 0:
        return _expand(filename, **params)
    for l in args:
        retval += _expand(filename, **l, **params)
    return retval
