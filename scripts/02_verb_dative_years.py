import pandas as pd
import json
import os
import csv
import time
import sys
from collections import Counter

pd.options.mode.chained_assignment = None

year_grid = pd.DataFrame()

result = pd.read_csv("../data_output/verb_dative_alternation.tsv", sep='\t')

print(result)

def get_cols(input_string, lower = 1800, upper = 2008):
    print("Starting")
    if input_string != "-1":
        a = input_string.replace("[(","").replace(")]","")
        print(a)
        year_dict = {}
        for item in a.split("), ("):
            set = item.replace("'","").split(", ")
            year_dict[set[0]] = int(set[1])

        dict_to_add = {}

        for i in range(lower, upper+1):
            i = str(i)
            if i in year_dict.keys():
                dict_to_add["y"+i] = year_dict[i]
            else:
                dict_to_add["y"+i] = 0
    else:
        dict_to_add = {}

        for i in range(lower, upper+1):
            i = str(i)
            dict_to_add["y"+i] = 0


    return dict_to_add

years = []

for i in range(1800, 2008+1):
    years.append("y"+str(i))

## issues with fragmented dataframe
result[years] = result.apply(lambda x: pd.Series(get_cols(x["year_count"])), axis = 1)

print("de-fragmented frame")
unfragmented = result.copy()
print(unfragmented)

unfragmented.to_csv("../data_output/dative_alternation_split.tsv", sep = "\t", index = False)