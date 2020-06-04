"""
Implementation of Minimum Spanning Tree
"""


from collections import defaultdict
import heapq


class MinimumSpanningTree:
    """
    Minimum Spanning Tree class using 'Kruskal algorithm' to get distances

    A Minimum Spanning Tree (MTS) constructs a graph with vertices without
    loops using edges, such that the total weight of all edges is minimized.

    Reference:
        You can find Kruskal algorithm in the first 2 pages of the below paper.
        - A review of two decades of correlations, hierarchies, networks and clustering in financial markets
        (https://arxiv.org/pdf/1703.00485.pdf)

    """
    def __init__(self, vertices, edges):
        """
        Parameters
        ----------
            vertices: (list) : List of name of vertices.
                ex) ['AAPL', 'AMZN', 'XYL', 'GLW'...]
            edges : (list) : List of tuple which contain weight, name of vertices.
                             The list should be arranged in ascending order by weight of each tuple.

        Examples
        --------
            >>>> vertices = ['AAPL', 'AMZN', 'XYL', 'GLW'...]
            >>>> edges = [(0.5738119476776615, 'XYL', 'GE'),
                     (0.6393385878075669, 'GLW', 'GE'),
                     (0.6748059132700998, 'NTRS', 'XYL'),
                     (0.7090918442572199, 'NTRS', 'GE'),
                     (0.7506079746487421, 'NTRS', 'GLW'),
                     (0.7592144174674299, 'GLW', 'XYL')
                     ...
                     ]

            >>>> mst = MinimumSpanningTree(vertices, edges)
            >>>> graph = mst.build()
        """
        self.vertices = vertices
        self.edges = edges
        self.parent = {}
        self.rank = {}
        self.init_table()
        self.__graph_edges = []
        self.__graph_map = defaultdict(dict)

    def init_table(self):
        """
        This initializes dictionaries used to build tree.
        """
        for vertex in self.vertices:
            self.parent[vertex] = vertex
            self.rank[vertex] = 0

    @property
    def graph_edges(self):
        """
        Return every edges of tree graph
        """
        return self.__graph_edges

    @property
    def graph_map(self):
        """
        Return map of graph
        """
        return self.__graph_map

    def find_parent(self, vertex):
        """
        This method is used for finding parent(root) of vertex(node)

        Parameters
        ----------
            vertex: (string) : name of vertex

        Return
        -------
            parent of vertex: (string) : name of parent of vertex

        """
        if self.parent[vertex] != vertex:
            self.parent[vertex] = self.find_parent(self.parent[vertex])

        return self.parent[vertex]

    def check_connected(self, vertex_1, vertex_2):
        """
        This method is used to check whether two vertices is connected
        If vertices are connected, it will return True, else Fasle

        Parameters
        ----------
            vertex_1: (string) : name of vertex
            vertex_2: (string) : name of vertex

        Return
        -------
            connected: (bool) : If vertices are connected, it will return True, else False
        """
        parent1 = self.find_parent(vertex_1)
        parent2 = self.find_parent(vertex_2)

        return parent1 == parent2

    def union_parent(self, vertex_1, vertex_2):
        """
        This method is used to union parents of vertices.
        It unions based on the parent of 'vertex_1' vertex.

        Parameters
        ----------
            vertex_1: (string) : name of vertex
            vertex_2: (string) : name of vertex

        """
        parent1 = self.find_parent(vertex_1)
        parent2 = self.find_parent(vertex_2)

        if parent1 != parent2:
            self.parent[parent2] = parent1

    def build(self):
        """
        It builds the minimum spanning tree(MST) based on Kruskal's algorithm

        Note:
             If there are N vertices, this MST selects N-1 shortest edges(links) that span all the
             vertices without forming loops. We can finish build tree when there are N-1 edges in tree
             before looping all edges.

        Return
        -------
            graph_edges: (list) list of edges of MST after build.
        """

        # find necessary edges for MST
        for edge in self.edges:
            _, vertex_1, vertex_2 = edge
            if not self.check_connected(vertex_1, vertex_2):
                self.union_parent(vertex_1, vertex_2)
                self.__graph_edges.append(edge)

                if len(self.__graph_edges) == len(self.vertices)-1:
                    break

        # build graph map from edges
        graph_edges = self.__graph_edges.copy()

        for vertex in self.vertices:
            # get edges that contain 'vertex'

            rm_ix = []
            if graph_edges:
                for i, (distance, vertex_1, vertex_2) in enumerate(graph_edges):
                    # if the edge contains 'vertex', Let's add it to graph_map
                    # and save the index of edge to remove it from graph_edges
                    if vertex in (vertex_1, vertex_2):
                        rm_ix.append(i)
                        if vertex == vertex_1:
                            self.__graph_map[vertex][vertex_2] = distance
                        else:
                            self.__graph_map[vertex][vertex_1] = distance

        print(f"The building of tree is completed")
        return self.__graph_edges

    def find_path(self, start_vertex, end_vertex):
        """
        Find the path and calculate distance between two vertices in graph of MST by using dijkstra algorithm
        (https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm)

        Parameters
        ----------
            start_vertex: (string) : name of start vertex
            end_vertex: (string) : name of end vertex

        Return
        -------
            path_record: (list) : list of name of all vertices between 'start_vertex' and 'end_vertex'
            distance: (float) : distance between 'start_vertex' and 'end_vertex'
        """

        graph = self.graph_map.copy()

        # make a dictionary for saving distance between 'start_vertex' and others
        # and initialize distance value with 'inf'
        distances = {vertex: [float('inf'), start_vertex] for vertex in self.vertices}

        # Initialize distance to 'start_vertex'(itself) as '0'
        distances[start_vertex] = [0, start_vertex]

        # make a queue for saving every vertices
        queue = []

        # save distance(0) from 'start_vertex' to 'start_vertex' to 'MinHeap'
        heapq.heappush(queue, [distances[start_vertex][0], start_vertex])

        while queue:

            # Take a vertex from the queue one by one and check and
            # update all the weights of the adjacent vertices.
            current_distance, current_vertex = heapq.heappop(queue)

            # Ignore if there is a shorter path..
            if distances[current_vertex][0] < current_distance:
                continue

            for adjacent, weight in graph[current_vertex].items():
                distance = current_distance + weight

                # if it is closer to the current vertex than to the adjacent vertex.
                if distance < distances[adjacent][0]:
                    # Update the distance
                    distances[adjacent] = [distance, current_vertex]
                    heapq.heappush(queue, [distance, adjacent])

        # backtrack path between start_vertex and end_vertex using 'distances'
        path = end_vertex
        path_record = []

        if distances[end_vertex][1] == start_vertex:
            # If two vertices are directly connected
            path_record.append(end_vertex)
        else:
            # backtrack until we find 'start_vertex'
            while distances[path][1] != start_vertex:
                path_record.append(path)
                path = distances[path][1]
            path_record.append(path)

        path_record.append(start_vertex)

        # we should revert the order of list.
        path_record = path_record[::-1]
        # distance between start_vertex and end_vertex
        distance = distances[end_vertex][0]

        return path_record, distance
