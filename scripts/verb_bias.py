#source: https://github.com/wilcoxeg/verb_transitivity/blob/master/arg_structure_extractor.py

import pandas as pd
import os
import csv
import time
import sys
from collections import Counter

print("init", os.getcwd())

pd.options.mode.chained_assignment = None

target_verbs = ["strike", "whack", "hit", "rub", "poke", "bop", "smack", "clean", "tease", "feed", "scuff", "pinch", "knock", "pat", "locate", "feel", "spot", "point", "pet", "look", "squeeze", "pick", "cuddle", "find", "hug", "select", "choose"]

# print("Target verbs:", target_verbs)

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

def check_bias_alt(arg_structure):
    # print(arg_structure)
    
    holder = []
    root_index = -1
    connection_target_index_word = "with"
    with_index = -1
    connection_target_index = -1

    counter = 1
    for word in arg_structure.split(" "):
        temp = word.split("/")
        if temp[0] == "with":
            connection_target_index = int(temp[3])
            with_index = counter
        if temp[3] == "0":
            root_index = counter
            root_verb = temp[0]
        else:
            counter = counter + 1
        holder.append(temp)

    if (re.search("(?="+root_verb+")(?=.*with/)", arg_structure) == None):
        return "no_with"
    elif (root_index == with_index): # If root verb is not followed by "with"
        return "neither"
    if root_index == connection_target_index:
        # print("Instrument bias")
        return "instrument"
    else:
        # print("Modifier bias")
        return "modifier"


csv.field_size_limit(sys.maxsize)
col_names = ["verb", "arg_structure", "count"]
result = pd.DataFrame()

# syntgram_dir = "../data/triarcs"
syntgram_dir = "/home/ecain/borgstore/ecain/syntactic-ngrams/triarcs" ## Issue when submitted through slurm

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
    df = df[df.verb.isin(target_verbs)]

    # print(df)
    dates = df.loc[:, ~ df.columns.isin([0,1,2])]

    # print(dates)
    date_row = dates.loc[0,:]

    dates["counts"] = dates.apply(lambda row: row2dict(row), axis = 1)

    # print(dates["counts"])
    df = df[[0,1,2]]
    df.columns = ["verb", "arg_structure", "count"]
    df["count"] = df["count"].astype(int)
    df["year_count"] = dates["counts"]

    # Filtered earlier to reduce memory constraints
    # df = df[df.verb.isin(target_verbs)]
    # print("\nSubset:")
    # print(df)

    df["bias"] = df["arg_structure"].apply(check_bias_alt)

    for verb in pd.unique(df.verb):
        for bias in pd.unique(df.bias):
            print(verb, bias)
            temp = df[(df["verb"] == verb) & (df["bias"] == bias)]
            if len(temp) != 0:
                print(temp)
                total_count = temp["count"].sum()
                year_counts = sum_dicts(temp["year_count"].values)
            else:
                total_count = 0
                year_counts = -1

            new_row = {"verb":[verb], "bias":[bias], "total_count": [total_count], "year_count":[year_counts]}
            new_row = pd.DataFrame(new_row)
            print()
            result = pd.concat([result, new_row], axis = 0)

    end = time.time()
    print(start - end)

    result.to_csv("../data_output/verb_bias.tsv", sep='\t', index=False)
    print(filename,"done")

    
