#source: https://github.com/wilcoxeg/verb_transitivity/blob/master/arg_structure_extractor.py

import pandas as pd
import os
import csv
import time
import sys

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

dative_verbs = pd.read_csv("../data/dative_verbs.csv")

dv = dative_verbs["verb"].values

csv.field_size_limit(sys.maxsize)
col_names = ["verb", "arg_structure", "count"]
result = pd.DataFrame()

start = time.time()
raw_data = []

# This because normal reading in the CSV was generating errors!
# df = pd.read_csv(open("./verb_args/"+filename, 'rt'), encoding='utf-8', engine='c', names=col_names, usecols=[0,1,2], sep="\t")
with open("../data/unlex_verbargs/head_set.tsv") as f:
    reader = csv.reader(f, delimiter='\t')
    raw_data = [r for r in reader]
    
df = pd.DataFrame(data=raw_data)
df = df[[0,1,2]]
df.columns = ["verb", "arg_structure", "count"]
df["count"] = df["count"].astype(int)

print(df)
df_subset = df[df.verb.isin(dv)]

#iobj & dobj
df_subset["iobj_dobj"] = df_subset.arg_structure.str.contains("(?=iobj)(?=.*dobj)", regex=True)

#dobj & pobj
df_subset["dobj_pobj"] = df_subset.arg_structure.str.contains("(?=dobj)(?=.*pobj)", regex=True)

#dobj only
df_subset["dobj"] = df_subset.arg_structure.str.contains("dobj") & ~df_subset.arg_structure.str.contains("iobj") & ~df_subset.arg_structure.str.contains("pobj")

#other?


arg_data = df_subset.groupby(["verb", "iobj_dobj", "dobj_pobj", "dobj"])["count"].sum()
arg_data = arg_data.unstack().unstack().reset_index()
print(arg_data)
# Rename columns: xtrans = when there is an indirect object, but no direct object. Infrequent occurance
# arg_data.columns = ["verb", "intrans", "trans", "xtrans", "ditrans"]
# arg_data = arg_data.fillna(0)
# # Total counts for each verb form
# arg_data["total"] = arg_data["intrans"] + arg_data["trans"] + arg_data["xtrans"] + arg_data["ditrans"]
# # Filter verb forms that occur less than 2,000 times.
# arg_data = arg_data[arg_data["total"] > 2000]
# # Calculate percentages of transitivity, intransitivity and ditransitivity
# arg_data["percent_intrans"] = arg_data["intrans"] / arg_data["total"]
# arg_data["percent_trans"] = arg_data["trans"] / arg_data["total"]
# arg_data["percent_ditrans"] = arg_data["ditrans"] / arg_data["total"]

# end = time.time()
# print(start - end)
# result = result.append(arg_data)

# result.to_csv("verb_transitivity.tsv", sep='\t', index=False)



# for filename in os.listdir("../data/unlex_verbargs"):
    # print(filename)
    # start = time.time()
    # raw_data = []
    
    # # This because normal reading in the CSV was generating errors!
    # # df = pd.read_csv(open("./verb_args/"+filename, 'rt'), encoding='utf-8', engine='c', names=col_names, usecols=[0,1,2], sep="\t")
    # with open("../data/unlex_verbargs/"+filename) as f:
    #     reader = csv.reader(f, delimiter='\t')
    #     raw_data = [r for r in reader]
        
    # df = pd.DataFrame(data=raw_data)
    # df = df[[0,1,2]]
    # df.columns = ["verb", "arg_structure", "count"]
    # df["count"] = df["count"].astype(int)

    # df["dobj"] = df.arg_structure.str.contains("dobj") #Construction contains direct obj dependency
    # df["iobj"] = df.arg_structure.str.contains("iobj") #Construction contains indirect obj dependency
    
    # arg_data = df.groupby(["verb", "dobj", "iobj"])["count"].sum()
    # arg_data = arg_data.unstack().unstack().reset_index()
    # # Rename columns: xtrans = when there is an indirect object, but no direct object. Infrequent occurance
    # arg_data.columns = ["verb", "intrans", "trans", "xtrans", "ditrans"]
    # arg_data = arg_data.fillna(0)
    # # Total counts for each verb form
    # arg_data["total"] = arg_data["intrans"] + arg_data["trans"] + arg_data["xtrans"] + arg_data["ditrans"]
    # # Filter verb forms that occur less than 2,000 times.
    # arg_data = arg_data[arg_data["total"] > 2000]
    # # Calculate percentages of transitivity, intransitivity and ditransitivity
    # arg_data["percent_intrans"] = arg_data["intrans"] / arg_data["total"]
    # arg_data["percent_trans"] = arg_data["trans"] / arg_data["total"]
    # arg_data["percent_ditrans"] = arg_data["ditrans"] / arg_data["total"]
    
    # end = time.time()
    # print(start - end)
    # result = result.append(arg_data)
    
    # result.to_csv("verb_transitivity.tsv", sep='\t', index=False)

    