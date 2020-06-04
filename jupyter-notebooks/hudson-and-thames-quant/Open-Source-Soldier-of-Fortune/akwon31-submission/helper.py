import numpy as np
import pandas as pd
import networkx as nx

# Calculates the log of the given dataframe
def calc_log(data):
    return np.log(data)

# Calculates the returns of each day
def calc_diff(data):
    return data.apply(np.diff)

# Calculates the correlation of the returns
def calc_corr(data):
    return data.corr()

# Calculates the distance based on the equation from the paper
def calc_dist(data):
    return np.sqrt(2 * (1 - data))

# Given a dataframe, returns a graph that connects all the non-zero edges
def all_connected(data):
    g = nx.Graph()
    for i in data.columns:
        for j in data.index:
            edge_length = data.loc[i, j]
            if edge_length != 0:
                g.add_edge(i, j, length = edge_length)
    return g

# Returns the MST of a given dataframe using Kruskal's Algorithm
def minimum_spanning_tree(data):

    # Initilize edge and vertex counts
    number_edge = 0
    number_vertex = len(data)

    # Initilize a copy of the distance matrix with all 0's
    new_data = data.copy()
    new_data[:] = 0

    # Check who the parent is in order to search for cycles
    def find(i):
        while parent[i] != i:
            i = parent[i]
        return i

    # Initialize a list of parents and vertex to track cycles
    parent = list(np.linspace(0,number_vertex - 1,number_vertex).astype(int))
    vertex = list(np.linspace(0,number_vertex - 1,number_vertex).astype(int))

    # Terminate program when number of edges = number of vertex - 1
    while number_edge < number_vertex - 1:
        # Placeholder variables for calculation
        d_min = 100
        a, b = -1, -1

        # Iterates through the upper triangle of the matrix
        for i in range(len(vertex)):
            for j in range(i + 1, len(vertex)):
                if find(i) != find(j) and data.iloc[i, j] < d_min:
                    d_min = data.iloc[i, j]
                    a, b = i, j

        # Link the two points together
        parent[find(a)] = find(b)

        # Set the distance for the new distance matrix
        new_data.iloc[a, b] = data.iloc[a, b]
        number_edge += 1

    return new_data
