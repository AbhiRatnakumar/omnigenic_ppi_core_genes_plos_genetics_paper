import networkx as nx
import matplotlib.pyplot as plt

G = nx.read_edgelist('My_own_randomized_network_STRING_TEST.csv_UNIQUE_DEGREE.csv')

print (nx.info(G))

for x in range(1, 1):
    nx.double_edge_swap(G,nswap=10)
    print (nx.info(G))
    nx.write_edgelist(G, "UNIQUE_degree_network_"+ str(x) + ".txt")
