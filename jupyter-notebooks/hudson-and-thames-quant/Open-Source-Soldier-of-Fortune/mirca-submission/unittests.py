import numpy as np
from numpy.linalg import eig
import pandas_datareader as pdr
from core import compute_adjacency_mst_and_distances

stocks = ['MSFT', 'AAPL', 'AMZN', 'FB']
prices = pdr.get_data_yahoo(stocks, start="2019-06-30",
                            end="2019-12-31")[['Adj Close']]
prices.dropna(axis='columns', inplace=True)
prices.columns = prices.columns.droplevel(0)
log_returns = prices.apply(np.log).apply(np.diff)
distances, adjacency = compute_adjacency_mst_and_distances(log_returns)


def test_is_connected():
    """Check whether the a graph is connected or not by verifying if
    the second smallest eigenvalue of its Laplacian matrix is positive."""
    n_nodes = adjacency.shape[0]
    eigvals, _ = eig(np.diag(np.sum(adjacency, axis=0)) - adjacency)
    assert np.sort(eigvals.real)[1] > 1e-10

def test_symmetry():
    np.testing.assert_allclose(adjacency, adjacency.T)
    np.testing.assert_allclose(distances, distances.T)

def test_is_valid_tree_graph():
    """Check whether the input matrix represents an adjacency matrix of
    a tree graph. Recall that a tree graph is a graph whose number of edges
    is equal to n_nodes - 1, where n_nodes is the number of nodes"""
    n_edges = int(.5*np.sum(adjacency > 0))
    n_nodes = adjacency.shape[0]
    assert n_edges == (n_nodes - 1)
