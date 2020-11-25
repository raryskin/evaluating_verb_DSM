import os
import csv
import pandas as pd
import networkx as nx
import matplotlib.pyplot as plt
from nltk.corpus import wordnet as wn
from scipy.spatial import distance


def import_vectors(filez):
    cols = ["word1","word2","pos","sv_score",'relation']
    simverb = pd.read_csv(filez,sep='\t')
    simverb.columns = cols


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

###update###
def vec(db, word):
    return db.loc[word].as_matrix()

def cos_distance(db, word1, word2):
    return distance.cosine(vec(db, word1), vec(db, word2))


#import_vectors("SimVerb-3500.txt")
simverb = pd.read_csv("simverb_cf_updated.csv")
#closer to 10 -> more similar
#print(simverb)

#cf_paragrams = pd.read_csv("./word_vectors/counter-fitted-vectors.txt", sep=" ", index_col=0, header=None, quoting=csv.QUOTE_NONE, encoding = "utf-8")
#closer to 0 -> more similar

'''
inverse = []
for index, row in simverb.iterrows():
    inverse.append(1/float(row["cf_score"]))
simverb["inverse"] = inverse
'''

#graph_this(simverb, "sv_score")
graph_this(simverb, "cf_score")
#graph_this(simverb, "inverse_cf")


#simverb.to_csv("./simverb_cf_updated.csv",index=False)