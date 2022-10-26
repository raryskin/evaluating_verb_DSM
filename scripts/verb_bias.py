#source: https://github.com/wilcoxeg/verb_transitivity/blob/master/arg_structure_extractor.py

import pandas as pd
import os
import csv
import time
import sys
from collections import Counter

pd.options.mode.chained_assignment = None

target_verbs = ["Strike", "Whack", "Hit", "Rub", "Poke", "Bop", "Smack", "Clean", "Tease", "Feed", "Scuff", "Pinch", "Knock", "Pat", "Locate", "Feel", "Spot", "Point", "Pet", "Look", "Squeeze", "Pick", "Cuddle", "Find", "Hug", "Select", "Choose"]

print("Target verbs:", target_verbs)

target_verb_bias = ["Instrument", "Instrument", "Instrument", "Instrument", "Instrument", "Instrument", "Instrument", "Instrument", "Instrument", "Equibiased", "Equibiased", "Equibiased", "Equibiased", "Equibiased", "Equibiased", "Equibiased", "Equibiased", "Equibiased", "Modifier", "Modifier", "Modifier", "Modifier", "Modifier", "Modifier", "Modifier", "Modifier", "Modifier"]



"""
======
This script will read in raw data files from the googe syntactic ngrams corpus and extract information
about verb transitivity. Google ngram corpus data downloadable from this link: 
http://commondatastorage.googleapis.com/books/syntactic-ngrams/index.html

Place the files you wish to extract transitivity information from in a directory titled "verb_args"
in the same directory as this script. Script outputs a tsv file, and clips verbs that occur less than
2,000 times. Note: script keeps verb forms seperate, (i.e. there are different entries for "give", "gives"
and "gave")
======
"""

def row2dict(date_row):
    date_row = date_row.dropna()
    date_dict = {}
    for item in date_row.values:
        split_dates = item.split(",")
        date_dict[split_dates[0]] = int(split_dates[1])
    return date_dict


def sum_dicts(set_of_dicts):
    # print(set_of_dicts)
    initial = Counter(set_of_dicts[0])
    for i in range(1,len(set_of_dicts)):
        initial = initial + Counter(set_of_dicts[i])
    return sorted(initial.items())


csv.field_size_limit(sys.maxsize)
col_names = ["verb", "arg_structure", "count"]
result = pd.DataFrame()

verb_bias_df = pd.DataFrame()

syntgram_dir = "../data/triarcs"
# syntgram_dir = "/home/ecain/borgstore/ecain/syntactic-ngrams/triarcs"

for filename in os.listdir(syntgram_dir):
    print("Filename:",filename)
    start = time.time()
    raw_data = []

    # This because normal reading in the CSV was generating errors!
    # df = pd.read_csv(open("./verb_args/"+filename, 'rt'), encoding='utf-8', engine='c', names=col_names, usecols=[0,1,2], sep="\t")
    with open(syntgram_dir + "/" + filename) as f:
        reader = csv.reader(f, delimiter='\t', quotechar = None, doublequote= True)
        raw_data = [r for r in reader]
        
    df = pd.DataFrame(data=raw_data)
    print(df)
    dates = df.loc[:, ~ df.columns.isin([0,1,2])]

    # print(dates)
    date_row = dates.loc[0,:]

    dates["counts"] = dates.apply(lambda row: row2dict(row), axis = 1)

    # print(dates["counts"])
    df = df[[0,1,2]]
    df.columns = ["verb", "arg_structure", "count"]
    df["count"] = df["count"].astype(int)
    df["year_count"] = dates["counts"]

    # print(df)
    df_subset = df[df.verb.isin(target_verbs)]
    print("\nSubset:")
    print(df_subset)

    verb_bias_df = pd.concat([verb_bias_df, df_subset], axis = 0)

    verb_bias_df.to_csv("../data_output/verb_bias_data.tsv", sep = "\t", index = False)


    # # contains prepc & vmod
    # df_subset["prepc_vmod"] = df_subset.arg_structure.str.contains("(?=prepc)(?=.*vmod)", regex=True)

    # # contains prepc & nn
    # df_subset["prepc_nn"] = df_subset.arg_structure.str.contains("(?=prepc)(?=.*nn)", regex=True)

    # #iobj & dobj
    # df_subset["iobj_dobj"] = df_subset.arg_structure.str.contains("(?=iobj)(?=.*dobj)", regex=True)

    # #dobj & pobj
    # df_subset["dobj_pobj"] = df_subset.arg_structure.str.contains("(?=dobj)(?=.*pobj)", regex=True)

    # #dobj only
    # df_subset["dobj"] = df_subset.arg_structure.str.contains("dobj") & ~df_subset.arg_structure.str.contains("iobj") & ~df_subset.arg_structure.str.contains("pobj")

    # #other
    # df_subset["other"] = ~df_subset["dobj"] & ~df_subset["dobj_pobj"] & ~df_subset["iobj_dobj"]

    # #Check column
    # df_subset["check"] = df_subset["dobj"] + df_subset["dobj_pobj"] + df_subset["iobj_dobj"] + df_subset["other"]

    # # print(df_subset)
    # df_type = df_subset[["verb","dobj","dobj_pobj","iobj_dobj","other"]]
    # for col in ["dobj","dobj_pobj","iobj_dobj","other"]:
    #     df_type[col] = df_type[col].replace({True: 1, False: 0})
    # df_type = df_type.set_index("verb")

    # df_type = df_type.idxmax(axis=1)

    # # arg_data = df_subset.groupby(["verb", "iobj_dobj", "dobj_pobj", "dobj"])["count"].sum()
    # # arg_data = arg_data.unstack().unstack().reset_index()
    # # print(arg_data)

    # df_subset["alternation"] = df_type.values

    # df_subset = df_subset.drop(["arg_structure", "dobj", "dobj_pobj","iobj_dobj","check","other"], axis = 1)

    # # print(df_subset)

    # for verb in pd.unique(df_subset.verb):
    #     for alternation in pd.unique(df_subset.alternation):
    #         # print(verb, alternation)
    #         temp = df_subset[(df_subset["verb"] == verb) & (df_subset["alternation"] == alternation)]
    #         if len(temp) != 0:
    #             # print(temp)
    #             total_count = temp["count"].sum()
    #             year_counts = sum_dicts(temp["year_count"].values)
    #         else:
    #             total_count = 0
    #             year_counts = -1

    #         new_row = {"verb":[verb], "alternation":[alternation], "total_count": [total_count], "year_count":[year_counts]}
    #         new_row = pd.DataFrame(new_row)
    #         # print()
    #         result = pd.concat([result, new_row], axis = 0)


    # end = time.time()
    # print(start - end)

    # result.to_csv("../data_output/verb_dative_alternation.tsv", sep='\t', index=False)

    