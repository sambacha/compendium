'''
Author: Justin Simcock
~~~~~~~~~~~~~~~~~~~~~~~

Implements Kruskal Algorithm on financial returns as explained here:
https://arxiv.org/pdf/1703.00485.pdf

Implementation of Kruskal Algorithm uses NetworkX UnionFind class.

NetworkX UnionFind authors:

Aric Hagberg <hagberg@lanl.gov>
Dan Schult <dschult@colgate.edu>
Pieter Swart <swart@lanl.gov>

Python Class implementation:
https://networkx.github.io/documentation/networkx-1.10/_modules/networkx/utils/union_find.html#UnionFind.union

NetworkX's UnionFind class makes use of the code from the following:

Josiah Carlson: http://aspn.activestate.com/ASPN/Cookbook/Python/Recipe/215912
D. Eppstein: http://www.ics.uci.edu/~eppstein/PADS/UnionFind.py
'''

import yfinance as yf
import pandas as pd
import networkx as nx
import numpy as np
import matplotlib.pyplot as plt


def daily_log_returns(ticker_list):
    '''
    Computes daily close to close log returns for a list of tickers

    Parameters
    ==========
    ticker_list: list

    Returns
    =======
    pd.Dataframe
    '''
    log_returns_list = []
    for ticker in ticker_list:
        ticker_df = yf.Ticker(ticker).history(period='max')
        ticker_df['log_return_' + ticker] = np.log(
            ticker_df['Close']) - np.log(ticker_df['Close'].shift(1))
        log_returns_list.append(ticker_df['log_return_' + ticker])

    return pd.concat(log_returns_list, axis=1)


def compute_distance(returns_df, correlation_method='pearson'):
    '''
    Computes a distance metric as defined in Marti et. al, 19.
    See: https://arxiv.org/pdf/1703.00485.pdf

    Note
    ====
    Performs correlation computation using pandas default
    setting of pearson correlation coefficient.

    Parameters
    ==========
    returns_df: pd.Dataframe
    correlation_method: 'pearson', 'kendall', or 'spearman'

    Returns
    =======
    pd.Dataframe
    '''

    return np.sqrt(2 * (1 - returns_df.corr(method=correlation_method)))


class KruskalMST():
    '''
    Constructs a Minimum Spanning Tree according to Kruskal Algorithm
    ...

    Attributes
    ----------
    distance_df: pd.Dataframe of distance metrics

    Methods
    -------
    construct_graph: Generates an undirected Graph with vertices
                    as tickers and edge values as distance


    '''

    import networkx as nx

    def __init__(self, distance_df):

        self.distance_df = distance_df
        self.graph = self._construct_graph(distance_df)

    def _construct_graph(self, distance_df):
        '''
        Generates an undirected Graph with vertices as tickers
        and edge values as distance

        Parameters
        ==========
        distance_df: pd.Dataframe

        Returns
        =======
        networkx.Graph object
        '''

        G = nx.Graph()
        for i in distance_df.index:
            for j in distance_df.columns:
                G.add_edge(i, j, distance=distance_df.loc[i, j])

        return G

    def _min_span_edges(self, data=True):
        '''
        Computes minumum spanning edges between nodes in Graph
        based on Kruskal algorithm. Only works for undirected graphs.
        Directed graphs will throw an error.

        Parameters
        ==========
        data: Bool


        Returns
        =======
        generator

        '''

        from networkx.utils import UnionFind
        ##############################################################
        # networkx implementation for finding minimum spanning edges #
        ##############################################################
        
        if self.graph.is_directed():
            raise nx.NetworkXError(
                "Mimimum spanning tree not defined for directed graphs.")

        subtrees = UnionFind()
        edges = sorted(self.graph.edges(data=True))
        for u, v, d in edges:
            if subtrees[u] != subtrees[v]:
                if data:
                    yield (u, v, d)
                else:
                    yield (u, v)
                subtrees.union(u, v)

    def min_span_tree(self):
        '''
        Creates Tree with networkx Graph object with nodes/edges organized
        according to minimum spanning edges

        Parameters
        ==========
        None

        Returns
        =======
        networkx.Graph
        '''
        T = nx.Graph()
        edges = self._min_span_edges(self.graph)

        T.add_nodes_from(self.graph.nodes.items())

        T.add_edges_from(edges)
        return T
