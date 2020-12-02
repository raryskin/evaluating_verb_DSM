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
    print("graphing ",set)
    G = nx.Graph()
    ax = plt.gca()
    ax.set_title("Graph for "+set)
    for index, row in simverb.iterrows():
        if int(row["include"]) == 1:
            G.add_node(row["word1"])
            G.add_node(row["word2"])
            G.add_edge(row["word1"],row["word2"],weight=row[set])

    edges, weights = zip(*nx.get_edge_attributes(G,"weight").items())

    #print(G.number_of_nodes())
    pos = nx.spring_layout(G,k=0.15)
    nx.draw(G, pos, node_size=0,node_color="r",edgelist=edges, edge_color=weights, width = 5.0, edge_cmap = plt.cm.Reds,ax=ax)
    _ = ax.axis("off")
    nx.draw_networkx_labels(G, pos, font_size = 8, font_family = "sans-serif")
    print(nx.average_clustering(G))
    plt.show()
    plt.clf()

def bucketeer(value_):
    if value_<=0.25:
        return 1
    elif value_ <=0.5:
        return 2
    elif value_ <= 0.75:
        return 3
    else:
        return 4


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
simverb = pd.read_csv("simverb_12-2.csv")
#closer to 10 -> more similar
#print(simverb)

#cf_paragrams = pd.read_csv("./word_vectors/counter-fitted-vectors.txt", sep=" ", index_col=0, header=None, quoting=csv.QUOTE_NONE, encoding = "utf-8")
#closer to 0 -> more similar


sv_bucket = []
cf_bucket = []
wn_bucket = []
for index, row in simverb.iterrows():
    sv_score = row["sv_score"]
    omcf = row["one_minus_cf"]
    wn_wup = row["wn_wup"]
    sv_bucket.append(bucketeer(sv_score/10))
    cf_bucket.append(bucketeer(omcf))
    wn_bucket.append(bucketeer(wn_wup))
simverb["sv_bucket"] = sv_bucket
simverb["cf_bucket"] = cf_bucket
simverb["wn_bucket"] = wn_bucket


'''
wordNet = []
for index, row in simverb.iterrows():
    word1 = row["word1"]
    w1_syn = wn.synsets(word1, pos=wn.VERB)[0]
    word2 = row["word2"]
    w2_syn = wn.synsets(word2, pos=wn.VERB)[0]
    wordNet.append(w1_syn.path_similarity(w2_syn))
simverb["wn_wup"] = wordNet
'''



graph_this(simverb, "sv_score")
#graph_this(simverb, "cf_score")
graph_this(simverb, "one_minus_cf")
graph_this(simverb, "wn_wup")

simverb.to_csv("./simverb_12-2.csv",index=False)
