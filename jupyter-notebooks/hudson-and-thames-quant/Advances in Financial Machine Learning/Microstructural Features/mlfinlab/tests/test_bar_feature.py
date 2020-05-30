import unittest
import pandas as pd
import numpy as np

from mlfinlab.data_structures import BarFeature

class TesBarFeature(unittest.TestCase):
    def test_bar_feature(self):
        # Arrange
        name = 'test_feature'
        func = lambda df: np.max(df.values) * 2
        dframe = pd.DataFrame({'1': range(10)})
        # Act
        bar_feature = BarFeature(name=name, function=func)
        computed_bar_feature = bar_feature.compute(dframe)
        function_result = func(dframe)
        # Assert
        self.assertTrue(bar_feature.name == name)
        self.assertTrue(computed_bar_feature == function_result)
