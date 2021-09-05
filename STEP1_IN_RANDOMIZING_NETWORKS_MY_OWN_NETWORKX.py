import networkx as nx
import matplotlib.pyplot as plt
import numpy as np

pos=[]

for iterate_it_overall in range(5):

    G = nx.read_edgelist('String_PPI_hgnc_converted_score_gt_700_only_binding_CONVERTED_TO_CSV_UNIQUE.csv')
    look_here =nx.degree_histogram(G)

    for iterate_it in range(1000):
        i = 0
        while i < len(look_here):
            if look_here[i] > 1:
               mine = [node for node,degree in G.degree() if degree == i]
               np.random.shuffle(mine)
               new0 = str(mine[0]) + '_swap'
               new1 = str(mine[1]) + '_swap'
               mapping={mine[0]:new1, mine[1]:new0}
               G=nx.relabel_nodes(G,mapping, copy=False)
               mapping={new1:mine[1], new0:mine[0]}
               G=nx.relabel_nodes(G,mapping, copy=False)
            elif look_here[i] > 0:
                 pos.append(i) 
            i += 1
    nx.write_edgelist(G, "My_own_randomized_network_STRING_"+str(iterate_it_overall))



