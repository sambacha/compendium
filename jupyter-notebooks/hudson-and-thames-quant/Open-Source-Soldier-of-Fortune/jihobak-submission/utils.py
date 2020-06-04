"""
In this script, I write useful method for Skill Set Challenge Hudson & Thames
"""

import numpy as np


def compute_log_returns(prices):
    """
    Compute log returns for each ticker.

    Parameters
    ----------
    prices : DataFrame
        Prices for each ticker and date

    Returns
    -------
    log_returns : DataFrame
        Log returns for each ticker and date
    """

    log_returns = np.log(prices/prices.shift(1))[1:]

    return log_returns


def convert_to_distance_matrix(correlation_matrix):
    """
    Compute pair-wise distances using correlation coefficents

    References:
    ----------
        - Hierarchical Structure in Financial Markets
        (https://www.researchgate.net/publication/46462363_Hierarchical_Structure_in_Financial_Markets)

    Parameters
    ----------
    correlation_matrix : DataFrame
        correlation for every pairs of stocks.

    Returns
    -------
    distance_matrix : DataFrame
        distance matrix for every pairs of stocks.
    """

    distance_matrix = np.sqrt(2*(1-correlation_matrix))

    return distance_matrix


def get_condensed_distance_matrix(matrix):
    """
    Basically, This returns upper triangular part of square matrix(without diagonals)
    So, we can use this method to get condensed distance matrix.

    Parameters
    ----------
    matrix: numpy.ndarray
        It should be square matrix

    Returns
    -------
    condensed_distance: numpy.ndarray
        condensed distance matrix which 1-d array. If matrix has NxN shape, The lenght
        of return should be N*(N-1)/2

    """
    x_indices, y_indices = np.triu_indices_from(matrix, k=1)
    condensed_distance = matrix[x_indices.tolist(), y_indices.tolist()]
    return condensed_distance
