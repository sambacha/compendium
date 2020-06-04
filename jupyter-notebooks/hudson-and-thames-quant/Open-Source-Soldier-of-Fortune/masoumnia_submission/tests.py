import numpy as np
import pandas as pd
import networkx as nx


def check_mst(graph, in_mst):
    """
    Checks if MST is valid for graph.
    Parameters
    ----------
    graph: Pandas DataFrame
        Adjacency matrix of graph to check.

    in_mst: Pandas DataFrame
        Adjacency matrix of MST to check.
    """
    g = nx.from_numpy_array(np.array(graph))  # create nx graph from adj matrix
    g_mst = nx.minimum_spanning_tree(g)  # create nx MST
    in_g = nx.from_numpy_array(np.array(in_mst))  # put input MST into nx obj
    assert nx.is_isomorphic(g_mst, in_g)  # check if graphs are the same, raise exception if not
    return True
