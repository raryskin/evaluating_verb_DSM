import os
import csv
import pandas as pd
import networkx as nx
import numpy as np
import matplotlib.pyplot as plt
from nltk.corpus import wordnet as wn
from scipy.spatial import distance

def import_vectors(filez):
    cols = ["word1","word2","pos","sv_score",'relation']
    simverb = pd.read_csv(filez,sep='\t')
    simverb.columns = cols

def normalize(word_vec):
    norm=np.linalg.norm(word_vec)
    if norm == 0: 
       return word_vec
    return word_vec/norm

def graph_this(simverb,set):
    G = nx.Graph()
    for index, row in simverb.iterrows():
        if int(row["include"]) == 1: 
            G.add_node(row["word1"])
            G.add_node(row["word2"])
            G.add_edge(row["word1"],row["word2"],weight=row[set])

    edges, weights = zip(*nx.get_edge_attributes(G,"weight").items())

    #print(G.number_of_nodes())
    pos = nx.spring_layout(G,k=0.1)
    nx.draw(G, pos, node_color="r",edgelist=edges, edge_color=weights, width = 5.0, edge_cmap = plt.cm.Greys)
    nx.draw_networkx_labels(G, pos, font_size = 8, font_family = "sans-serif")
    plt.show()
    plt.clf()

def vec(db, word):
    #print(db.loc[word])
    return db.loc[word].to_numpy()


def cos_distance(db, word1, word2):
    if word1 not in db.index or word2 not in db.index:
        return 99999
    else:
        vec1 = vec(db, word1)
        #print(word1 in db.index)
        #print(vec1)
        vec2 = vec(db, word2)
        #print(word2 in db.index)
        #print(vec2)
        return distance.cosine(vec1, vec2)

def cos_distance_minus(db, word1, word2):
    if word1 not in db.index or word2 not in db.index:
        return 99999
    else:
        vec1 = vec(db, word1)
        #print(word1 in db.index)
        #print(vec1)
        vec2 = vec(db, word2)
        #print(word2 in db.index)
        #print(vec2)
        return 1 - distance.cosine(vec1, vec2)

def cos_distance_normalized(db, word1, word2):
    if word1 not in db.index or word2 not in db.index:
        return 99999
    else:
        vec1 = normalize(vec(db, word1))
        #print(word1 in db.index)
        #print(vec1)
        vec2 = normalize(vec(db, word2))
        #print(word2 in db.index)
        #print(vec2)
        return distance.cosine(vec1, vec2)


#import_vectors("SimVerb-3500.txt")
simverb = pd.read_csv("simverb_11-25.csv")
#closer to 10 -> more similar
#print(simverb)

#cf_paragrams = pd.read_csv("./word_vectors/counter-fitted-vectors.txt", sep=" ", index_col=0, header=None, quoting=csv.QUOTE_NONE, encoding = "utf-8")
#closer to 0 -> more similar

'''
minus = []
normalized = []
for index, row in simverb.iterrows():
    word1 = row["word1"]
    word2 = row["word2"]
    minus.append(cos_distance_minus(cf_paragrams, word1, word2))
    normalized.append(cos_distance_normalized(cf_paragrams, word1, word2))

simverb["one_minus_cf"] = minus
simverb["normalized_cf"] = normalized
'''

wordNet = []
for index, row in simverb.iterrows():
    word1 = row["word1"]
    word2 = row["word2"]
    wordNet.append()

graph_this(simverb, "sv_score")
#graph_this(simverb, "cf_score")
graph_this(simverb, "one_minus_cf")


#simverb.to_csv("./simverb_11-25.csv",index=False)