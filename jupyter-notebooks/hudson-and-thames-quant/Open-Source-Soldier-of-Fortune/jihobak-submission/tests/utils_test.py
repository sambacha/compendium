"""
Tests the helpful functions in utils.py
"""


import unittest

import pandas as pd
import numpy as np

from utils import compute_log_returns, convert_to_distance_matrix, get_condensed_distance_matrix

class TestUtils(unittest.TestCase):
    """
    Tests the helpful functions in utils.py
    """

    @classmethod
    def setUpClass(cls):
        # Setup the test DataFrame.
        dates = ['2019-03-08', '2019-03-11', '2019-03-12', '2019-03-13', '2019-03-14']
        tickers = ['A', 'AAL', 'AAP', 'AAPL', 'ABBV']
        price_df = pd.DataFrame(
            [
                [77.31999206542969, 31.48783874511719, 151.5386199951172, 170.676025390625, 72.27434539794922],
                [78.62882995605469, 31.625986099243164, 155.22299194335938, 176.58860778808594, 72.74014282226562],
                [79.25348663330078, 30.510934829711914, 154.6338653564453, 178.57266235351562, 73.35501098632812],
                [79.45179748535156, 31.418764114379886, 154.46414184570312, 179.36231994628906, 73.53201293945312],
                [79.92772674560547, 31.70492744445801, 153.76519775390625, 181.3562164306641, 74.48225402832031]
            ],
            index=dates,
            columns=tickers
        )

        log_return_df = pd.DataFrame(
            [
                [0.016785873796730088, 0.00437772786211795, 0.024022230818820878, 0.034055606386720214,
                 0.006424172260119417],
                [0.007912981645542772, -0.035893989197571814, -0.003802577112059322, 0.011172812868994686,
                 0.008417415341449637],
                [0.0024991096719357416, 0.02932015932520719, -0.001098185842968431, 0.004412303423459131,
                 0.0024100432300667354],
                [0.005972293833622591, 0.009066810999034041, -0.004535228805356812, 0.01105524995724105,
                 0.012840034458037093]
            ],
            index=dates[1:],
            columns=tickers
        )

        correlation_matrix = pd.DataFrame(
            [
                [1., -0.17552371, 0.86072519, 0.98166472, -0.07896089],
                [-0.17552371, 1., 0.08879477, -0.07166557, -0.5426112],
                [0.86072519, 0.08879477, 1., 0.92660873, -0.12612797],
                [0.98166472, -0.07166557, 0.92660873, 1., -0.03350142],
                [-0.07896089, -0.5426112, -0.12612797, -0.03350142, 1.]
            ]
        )

        distance_matrix = pd.DataFrame(
            [
                [0., 1.53331256, 0.527778, 0.1914956, 1.46898665],
                [1.53331256, 0., 1.34996684, 1.464012, 1.75648012],
                [0.527778, 1.34996684, 0., 0.38312208, 1.50075179],
                [0.1914956, 1.464012, 0.38312208, 0., 1.43770749],
                [1.46898665, 1.75648012, 1.50075179, 1.43770749, 0.]
            ]
        )

        cls.price_df = price_df
        cls.log_return_df = log_return_df
        cls.correlation_matrix = correlation_matrix
        cls.distance_matrix = distance_matrix

    def test_compute_log_returns(self):
        """
        Tests for correct calculation of log returns
        """
        output_is_close = np.allclose(self.log_return_df, compute_log_returns(self.price_df))

        self.assertTrue(output_is_close, "output is different from what we expect")

    def test_convert_to_distance_matrix(self):
        """
        Tests for correct calculation of log returns
        """
        output_is_close = np.allclose(self.distance_matrix, convert_to_distance_matrix(self.correlation_matrix))

        self.assertTrue(output_is_close, "output is different from what we expect")

    def test_get_condensed_distance_matrix(self):
        """
        Test whether it returns upper triangular part of square matrix(without diagonals) as 1-d array.
        """
        test_matrix = np.array([
            [0, 1, 2, 3, 4],
            [0, 0, 5, 6, 7],
            [0, 0, 0, 8, 9],
            [0, 0, 0, 0, 10],
            [0, 0, 0, 0, 0]
        ])

        answer = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        self.assertListEqual(answer, list(get_condensed_distance_matrix(test_matrix)))


if __name__ == '__main__':
    unittest.main()
