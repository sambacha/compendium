import numpy as np
from scipy.sparse.csgraph import connected_components
from scipy.sparse import csr_matrix

def compute_adjacency_mst_and_distances(log_returns):
    """Computes the adjacency matrix of a minimum spannig tree
    and the distance matrix of a given dataframe of log returns.

    Parameters
    ----------
    log_returns : pandas.DataFrame
        A pandas dataframe that stores the logreturns of N stocks
        during T timestamps.

    Returns
    -------
    adjacency_matrix : numpy nd-array
        An adjacency matrix of minimum spanning tree graph
    distances : numpy nd-array
        Distance matrix where distances[i,j] represents the distance
        between stock i and stock j as described in the second page
        of [2]

    References
    ----------
    [1] https://en.wikipedia.org/wiki/Adjacency_matrix
    [2] https://arxiv.org/pdf/1703.00485.pdf
    """
    # compute the correlation coefficients between each pair or stocks time series
    correlation_coefficients = np.corrcoef(log_returns.T)
    # compute distances
    distances = np.sqrt(2 * (1 - correlation_coefficients))
    # get the number of nodes of the graph
    n_nodes = distances.shape[0]
    # since distances is a symmetric matrix, we only need the upper triangular part
    upper_vec_dist = distances[np.triu_indices(n_nodes, k=1)]
    # sort distances
    idx_sorted = np.argsort(upper_vec_dist)
    # get the edge pairs of the upper triangular part
    edge_pairs = np.asarray(np.triu_indices(n_nodes, k=1))
    # sort those edge pairs according to increasing distances
    edge_pairs_sorted = edge_pairs[:,idx_sorted]
    # initialize adjacency matrix as a fully disconnected graph
    adjacency = np.zeros((n_nodes, n_nodes))
    # loop over the N * (N - 1) edges
    for k in range(len(upper_vec_dist)):
        # get the pair with the k-th smallest distance
        i, j = edge_pairs_sorted[:, k]
        # compute the connected components of the current graph
        n_comp, labels = connected_components(csgraph=csr_matrix(adjacency),
                                              directed=False, return_labels=True)
        # if node i and j do not belog to the same component
        # then it means they are disconnected, in which case
        # we should connect them
        if not labels[i] == labels[j]:
            adjacency[i, j] = 1 # connect nodes i and j
        # we can terminate the loop earlier if the graph is already a tree
        # note: a tree is a connected graph whose number of edges is exactly
        # n_nodes - 1
        if (int(0.5*np.sum(adjacency > 0)) == (n_nodes - 1)
            and n_comp == 1):
            break
    # since we only looped over the pairs of the upper triangular part
    # we need to symmetrize the adjacency matrix
    adjacency = .5 * (adjacency + adjacency.T)
    return distances, adjacency
