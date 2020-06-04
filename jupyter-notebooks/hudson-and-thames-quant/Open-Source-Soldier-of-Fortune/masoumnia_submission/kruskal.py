import numpy as np
import pandas as pd


def mst(matrix):
    """
    Minimum spanning tree function.
    Parameters
    ----------
    matrix : Pandas DataFrame
        Adjacency matrix of graph structure to return the MST of.
    """
    upp = upper_df(matrix)  # upper triangular matrix to reduce redundant computations
    graph = upp.replace(matrix, 0)  # intialize 0 edge adjacency matrix
    for pair in edges(upp):
        i, j = pair
        if j not in dfs(graph, i, []):  # use depth first to check connection
            graph[i][j] = graph[j][i] = matrix[i][j]
    return graph


def dfs(matrix, vtx, path):
    """
    Depth First Search Function on node of adjacency matrix.
    Parameters
        ----------
        matrix: Pandas DataFrame
            Adjacency matrix of graph to reference nodes from.

        vtx: str, int
            Label of starting node to perform depth first search from.

        path: list
            List used in modifying recursion of depth first search.
    """
    src = vtx  # initialize source node
    path += [src]  # append source node

    neighbors = matrix[src].where(matrix[src] > 0)\
        .dropna()\
        .index.tolist()  # list of source node neighbors

    for neighbor in neighbors:
        if neighbor not in path:
            # recursively search for new paths
            path = dfs(matrix, neighbor, path)

    return path


def edges(matrix):
    """
    Function returning sorted list of edge pairs.
    Parameters
        ----------
        matrix: Pandas DataFrame
            Adjacency matrix of graph structure to derive list of pairs from.
    """
    raw_edges = matrix.unstack()  # series of raw edge pairs
    edges_ord = raw_edges.sort_values(
        kind="mergesort")  # edge pairs by distance
    pairs = edges_ord[edges_ord != 0].index.tolist()  # remove non-edges
    return pairs


def upper_df(matrix):
    """
    Upper triangular matrix of symmetric data frame
    Parameters
        ----------
        matrix : Pandas DataFrame
            Symmetric matrix to derive upper triangular from.
    """
    pd.testing.assert_frame_equal(
        matrix, matrix.T)  # assert symmetric dataframe
    col = matrix.columns
    ind = matrix.index
    matrix = pd.DataFrame(np.triu(matrix), index=ind, columns=col)
    return matrix
