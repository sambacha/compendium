"""
Tests MST(Minimum Spanning Tree) class in mst.py
"""

import itertools
import unittest

from mst import MinimumSpanningTree


class TestMST(unittest.TestCase):
    """
    Tests MST(Minimum Spanning Tree) class
    """

    @classmethod
    def setUpClass(cls):
        # Setup graph information.
        cls.vertices = ['A', 'B', 'C', 'D', 'E']
        cls.edges = [
            [1, 'A', 'E'],
            [2, 'C', 'D'],
            [3, 'A', 'B'],
            [4, 'B', 'E'],
            [5, 'B', 'C'],
            [6, 'E', 'C'],
            [7, 'E', 'D']
        ]

        # correct path and distance
        cls.paths = {
            ('A', 'B'): (['A', 'B'], 3),
            ('A', 'C'): (['A', 'B', 'C'], 8),
            ('A', 'D'): (['A', 'B', 'C', 'D'], 10),
            ('A', 'E'): (['A', 'E'], 1),
            ('B', 'A'): (['B', 'A'], 3),
            ('B', 'C'): (['B', 'C'], 5),
            ('B', 'D'): (['B', 'C', 'D'], 7),
            ('B', 'E'): (['B', 'A', 'E'], 4),
            ('C', 'A'): (['C', 'B', 'A'], 8),
            ('C', 'B'): (['C', 'B'], 5),
            ('C', 'D'): (['C', 'D'], 2),
            ('C', 'E'): (['C', 'B', 'A', 'E'], 9),
            ('D', 'A'): (['D', 'C', 'B', 'A'], 10),
            ('D', 'B'): (['D', 'C', 'B'], 7),
            ('D', 'C'): (['D', 'C'], 2),
            ('D', 'E'): (['D', 'C', 'B', 'A', 'E'], 11),
            ('E', 'A'): (['E', 'A'], 1),
            ('E', 'B'): (['E', 'A', 'B'], 4),
            ('E', 'C'): (['E', 'A', 'B', 'C'], 9),
            ('E', 'D'): (['E', 'A', 'B', 'C', 'D'], 11)
        }

        # This tree will be used for final test whether tree make a correct tree as a result.
        cls.mst = MinimumSpanningTree(cls.vertices, cls.edges)
        cls.mst.build()

    def test_find_parent_when_connected(self):
        """
        Test whether tree find root parent of vertex correctly when vertices are connected.
        """
        vertices = ['A', 'B', 'E']
        edges = [
            [1, 'A', 'E'],
            [3, 'A', 'B'],
        ]
        mst = MinimumSpanningTree(vertices, edges)
        mst.build()
        parent = list(mst.parent.values())

        # root parent should be 'A'
        self.assertListEqual(parent, ['A', 'A', 'A'])

    def test_find_parent_when_disconnected(self):
        """
        Test whether tree find root parent of vertex correctly when vertices are not fully connected.
        """
        vertices = ['A', 'E', 'C', 'D']
        edges = [
            [1, 'A', 'E'],
            [2, 'C', 'D'],
        ]
        mst = MinimumSpanningTree(vertices, edges)
        mst.build()
        parent = list(mst.parent.values())
        answer = ['A', 'A', 'C', 'C']
        self.assertListEqual(parent, answer)

    def test_check_connected_when_connected(self):
        """
        Test whether tree check root connection of tree correctly when vertices are connected.
        """
        vertices = ['A', 'B', 'E']
        edges = [
            [1, 'A', 'E'],
            [3, 'A', 'B'],
        ]
        mst = MinimumSpanningTree(vertices, edges)
        mst.build()

        for pairs in list(itertools.combinations(vertices, 2)):
            # All pairs should be connected
            vertex_1, vertex_2 = pairs
            is_connected = mst.check_connected(vertex_1, vertex_2)
            self.assertTrue(is_connected)

    def test_check_connected_when_disconnected(self):
        """
        Test whether tree check root connection of tree correctly vertices are not fully connected.
        """
        vertices = ['A', 'E', 'C', 'D']
        edges = [
            [1, 'A', 'E'],
            [2, 'C', 'D'],
        ]
        mst = MinimumSpanningTree(vertices, edges)
        mst.build()

        for pairs in list(itertools.combinations(vertices, 2)):
            # All pairs should be connected except {'A', 'E'} and {'C', 'D'}
            vertex_1, vertex_2 = pairs
            pairs_set = set(pairs)
            is_connected = mst.check_connected(vertex_1, vertex_2)
            if pairs_set in ({'A', 'E'}, {'C', 'D'}):
                pass
            else:
                is_connected = not is_connected

            self.assertTrue(is_connected)

    def test_union_parent(self):
        """
        Test whether tree union parents of two vertices correctly
        """
        vertices = ['A', 'B', 'E']
        edges = [
            [1, 'A', 'E'],
            [3, 'A', 'B'],
        ]
        mst = MinimumSpanningTree(vertices, edges)
        mst.union_parent('A', 'B')

        # After union, parent of all vertices should be 'A' except vertex 'E'
        parent = list(mst.parent.values())
        self.assertListEqual(parent, ['A', 'A', 'E'])

    def test_the_number_of_edges(self):
        """
        Test the number of edges in MST.
        When there are 'N' vertices, there should be 'N-1' edges.
        """
        num_vertices = len(self.mst.vertices)
        num_edges = len(self.mst.graph_edges)

        self.assertEqual(num_vertices-1, num_edges)

    def test_path_of_vertices(self):
        """
        Test the path of vertices of MST
        """
        for pair, answer in self.paths.items():
            answer_path, _ = answer
            path, _ = self.mst.find_path(*pair)
            self.assertListEqual(answer_path, path)

    def test_distance_of_vertices(self):
        """
        Test the path of vertices of MST.
        """
        for pair, answer in self.paths.items():
            _, answer_distance = answer
            _, distance = self.mst.find_path(*pair)
            self.assertEqual(answer_distance, distance)


if __name__ == '__main__':
    unittest.main()
