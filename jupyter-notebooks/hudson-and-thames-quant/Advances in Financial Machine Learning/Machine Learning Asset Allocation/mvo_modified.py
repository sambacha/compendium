import numpy as np
import pandas as pd
from mlfinlab.portfolio_optimization.mean_variance import MeanVarianceOptimisation


class MeanVarianceOptimisationModified(MeanVarianceOptimisation):
    
    def allocate(self, asset_prices, covariance, solution='inverse_variance', resample_by='B'):
        if not isinstance(asset_prices, pd.DataFrame):
            raise ValueError("Asset prices matrix must be a dataframe")
        if not isinstance(asset_prices.index, pd.DatetimeIndex):
            raise ValueError("Asset prices dataframe must be indexed by date.")

        # Calculate returns
        asset_returns = self._calculate_returns(asset_prices, resample_by=resample_by)
        assets = asset_prices.columns

        if solution == 'inverse_variance':
            
            ### Using the modified covariance matrix ###
            cov = pd.DataFrame(covariance, columns=assets, index=assets)
            
            self.weights = self._inverse_variance(covariance=cov)
        else:
            raise ValueError("Unknown solution string specified. Supported solutions - inverse_variance.")
        self.weights = pd.DataFrame(self.weights)
        self.weights.index = assets
        self.weights = self.weights.T
