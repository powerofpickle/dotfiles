import decimal
from decimal import Decimal
import math
import matplotlib.pyplot as plt
import numpy as np
import sympy
import pandas as pd

try:
    import torch
    from torch import tensor
except ModuleNotFoundError:
    pass

def div_ceil(n, d):
    return math.ceil(n / d)

def round_up_to(number, multiple):
    if multiple <= 0:
        raise ValueError("Multiple must be a positive number.")
    return math.ceil(number / multiple) * multiple

def full_float(x):
    return f"{x:.100g}"
