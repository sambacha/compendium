import numbers
from math import log, ceil
import numpy as np
import pandas as pd
from mlfinlab.portfolio_optimization.cla import CLA


def _infnone(number):
    '''
    Converts a Nonetype object to inf

    :param number: (int/float/None) a number
    :return: (float) -inf or number
    '''
    return float("-inf") if number is None else number


class CLAModified(CLA):
    
    def _initialise(self, asset_prices, covariance, resample_by):
        
        # Initial checks
        if not isinstance(asset_prices, pd.DataFrame):
            raise ValueError("Asset prices matrix must be a dataframe")
        if not isinstance(asset_prices.index, pd.DatetimeIndex):
            raise ValueError("Asset prices dataframe must be indexed by date.")

        # Resample the asset prices
        asset_prices = asset_prices.resample(resample_by).last()

        # Calculate the expected returns
        if self.calculate_returns == "mean":
            self.expected_returns = self._calculate_mean_historical_returns(asset_prices=asset_prices)
        elif self.calculate_returns == "exponential":
            self.expected_returns = self._calculate_exponential_historical_returns(asset_prices=asset_prices)
        else:
            raise ValueError("Unknown returns specified. Supported returns - mean, exponential")
        self.expected_returns = np.array(self.expected_returns).reshape((len(self.expected_returns), 1))
        if (self.expected_returns == np.ones(self.expected_returns.shape) * self.expected_returns.mean()).all():
            self.expected_returns[-1, 0] += 1e-5

        # Calculate the covariance matrix
        self.cov_matrix = np.asarray(covariance)

        # Intialise lower bounds
        if isinstance(self.weight_bounds[0], numbers.Real):
            self.lower_bounds = np.ones(self.expected_returns.shape) * self.weight_bounds[0]
        else:
            self.lower_bounds = np.array(self.weight_bounds[0]).reshape(self.expected_returns.shape)

        # Intialise upper bounds
        if isinstance(self.weight_bounds[0], numbers.Real):
            self.upper_bounds = np.ones(self.expected_returns.shape) * self.weight_bounds[1]
        else:
            self.upper_bounds = np.array(self.weight_bounds[1]).reshape(self.expected_returns.shape)

        # Initialise storage buffers
        self.weights = []
        self.lambdas = []
        self.gammas = []
        self.free_weights = []

    def allocate(self, asset_prices, covariance, solution="cla_turning_points", resample_by="B"):
        
        # Some initial steps before the algorithm runs
        self._initialise(asset_prices=asset_prices, covariance=covariance, resample_by=resample_by)
        assets = asset_prices.columns

        # Compute the turning points, free sets and weights
        free_weights, weights = self._init_algo()
        self.weights.append(np.copy(weights))  # store solution
        self.lambdas.append(None)
        self.gammas.append(None)
        self.free_weights.append(free_weights[:])
        while True:

            # 1) Bound one free weight
            lambda_in, i_in, bi_in = self._bound_free_weight(free_weights)

            # 2) Free one bounded weight
            lambda_out, i_out = self._free_bound_weight(free_weights)

            # 3) Compute minimum variance solution
            if (lambda_in is None or lambda_in < 0) and (lambda_out is None or lambda_out < 0):
                self.lambdas.append(0)
                covar_f, covar_fb, mean_f, w_b = self._get_matrices(free_weights)
                covar_f_inv = np.linalg.inv(covar_f)
                mean_f = np.zeros(mean_f.shape)

            # 4) Decide whether to free a bounded weight or bound a free weight
            else:
                if self._infnone(lambda_in) > self._infnone(lambda_out):
                    self.lambdas.append(lambda_in)
                    free_weights.remove(i_in)
                    weights[i_in] = bi_in  # set value at the correct boundary
                else:
                    self.lambdas.append(lambda_out)
                    free_weights.append(i_out)
                covar_f, covar_fb, mean_f, w_b = self._get_matrices(free_weights)
                covar_f_inv = np.linalg.inv(covar_f)

            # 5) Compute solution vector
            w_f, gamma = self._compute_w(covar_f_inv, covar_fb, mean_f, w_b)
            for i in range(len(free_weights)):
                weights[free_weights[i]] = w_f[i]
            self.weights.append(np.copy(weights))  # store solution
            self.gammas.append(gamma)
            self.free_weights.append(free_weights[:])
            if self.lambdas[-1] == 0:
                break

        # 6) Purge turning points
        self._purge_num_err(10e-10)
        self._purge_excess()

        # Compute the specified solution
        self._compute_solution(assets=assets, solution=solution)
