import networkx as nx
import matplotlib.pyplot as plt
import sys


input_filename = sys.argv[1]
output_filename = sys.argv[2]

G = nx.read_edgelist(input_filename)

nx.double_edge_swap(G,nswap=100000, max_tries=500000)
nx.write_edgelist(G, output_filename)
