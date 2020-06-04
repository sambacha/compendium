"""
In this script, I implement method to deal with graph object of networkx library.
"""


import networkx as nx
import matplotlib.pyplot as plt


def build_graph(vertices, edges):
    """
    Building graph using networkx library.

    Parameters
    ----------
    vertices : list
        list of names of vertices
    edges : list
        list of tuple which contain information of edges.
        each tuple should be like (distance, vertex_name_1, vertex_name_2)

    Returns
    -------
    graph : networkx.classes.graph.Graph
        graph object that has vertices and edges

    """

    # make empty graph
    graph = nx.Graph()

    # adding nodes to the graph.
    graph.add_nodes_from(vertices)

    # link every pairs from edges
    for edge in edges:
        weight, vertex_1, vertex_2 = edge
        graph.add_edge(vertex_1, vertex_2, weight=round(weight, 4))

    return graph


def draw_graph(graph, color_index, cmap, label=True):
    """
    Draw network graph from graph instance of networkx

    Parameters
    ----------
    graph : networkx.classes.graph.Graph
        graph object that has vertices and edges

    color_index : matplotlib.colors
        list of vertex's color index

    cmap: color map object in matplotlib.colors
        color map for plotting graph

    label: bool
        If label is True, it shows weights of edges, default is True
    """
    pos = nx.spring_layout(graph)
    nx.draw_networkx_edges(graph, pos)
    nx.draw_networkx_edges(graph, pos, width=1)
    nx.draw_networkx_labels(graph, pos, font_size=10, font_family='sans-serif')
    labels = nx.get_edge_attributes(graph, 'weight')
    if label:
        nx.draw_networkx_edge_labels(graph, pos, edge_labels=labels)

    nx.draw(graph, pos, node_color=color_index, cmap=cmap, node_size=700, alpha=0.5)
    plt.show()
