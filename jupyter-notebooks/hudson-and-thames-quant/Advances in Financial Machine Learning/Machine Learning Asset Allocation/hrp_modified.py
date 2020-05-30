import numpy as np
import pandas as pd
from scipy.cluster.hierarchy import dendrogram, linkage
from scipy.spatial.distance import squareform
from sklearn.covariance import OAS
import matplotlib.pyplot as plt
from mlfinlab.portfolio_optimization.hrp import HierarchicalRiskParity


class HierarchicalRiskParityModified(HierarchicalRiskParity):
    
    def allocate(self, asset_prices, covariance, resample_by='B', use_shrinkage=False):
        if not isinstance(asset_prices, pd.DataFrame):
            raise ValueError("Asset prices matrix must be a dataframe")
        if not isinstance(asset_prices.index, pd.DatetimeIndex):
            raise ValueError("Asset prices dataframe must be indexed by date.")

        # Calculate the returns
        asset_returns = self._calculate_returns(asset_prices, resample_by=resample_by)

        num_assets = asset_returns.shape[1]
        assets = asset_returns.columns

        
        ### Using the modified covariance matrix ###
        cov = pd.DataFrame(covariance, columns=assets, index=assets)
        
        
        if use_shrinkage:
            cov = self._shrink_covariance(covariance=cov)
        corr = self._cov2corr(covariance=cov)

        # Step-1: Tree Clustering
        distances, self.clusters = self._tree_clustering(correlation=corr)

        # Step-2: Quasi Diagnalization
        self.ordered_indices = self._quasi_diagnalization(num_assets, 2 * num_assets - 2)
        self.seriated_distances, self.seriated_correlations = self._get_seriated_matrix(assets=assets,
                                                                                        distances=distances,
                                                                                        correlations=corr)

        # Step-3: Recursive Bisection
        self._recursive_bisection(covariances=cov, assets=assets)