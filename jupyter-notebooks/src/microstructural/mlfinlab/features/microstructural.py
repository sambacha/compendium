import numpy as np
import pandas as pd
from sklearn.linear_model import LinearRegression

def tick_rule(tick_prices):
    """
    Applies the tick rule to classify trades as buy-initiated or sell-initiated

    :param tick_prices: a series of tick prices
    :return: a series of tick signs
    """
    price_change = tick_prices.diff()
    aggressor = pd.Series(index=tick_prices.index, data=np.nan)

    aggressor.iloc[0] = 1.
    aggressor[price_change < 0] = -1.
    aggressor[price_change > 0] = 1.
    aggressor = aggressor.fillna(method='ffill')
    return aggressor

def roll_model(prices):
    """
    Estimates 1/2*(bid-ask spread) and unobserved noise based on price sequences

    :param prices: a series of prices
    :return: a tuple with estimated of values of (spread, unobserved noise)
    """
    price_change = prices.diff()
    autocorr = price_change.autocorr(lag=1)
    spread_squared = np.max([-autocorr, 0])
    spread = np.sqrt(spread_squared)
    noise = price_change.var() - 2 * (spread ** 2)
    return spread, noise

def high_low_estimator(high, low, window):
    """
    Estimates volatility using Parkinson's method

    :param high: a series of high prices
    :param low: a series of low prices
    :param window: length of the rolling estimation window
    :return: volatility estimate
    """
    log_high_low = np.log(high / low)
    volatility = log_high_low.rolling(window=window).mean() / np.sqrt(8. / np.pi)
    return volatility

class CorwinShultz:
    """
    A class that encapsulates all the functions for Corwin and Shultz estimator
    """

    @staticmethod
    def get_beta(high, low, sample_length):
        """
        Computes beta in Corwin and Shultz bid-ask spread estimator

        :param high: a series of high prices
        :param low: a series of low prices
        :param sample_length: number of values per sample
        :return: beta estimate
        """
        log_high_low = np.log(high / low) ** 2
        sum_neighbors = log_high_low.rolling(window=2).sum()
        beta = sum_neighbors.rolling(window=sample_length).mean()
        return beta

    @staticmethod
    def get_gamma(high, low):
        """
        Computes gamma in Corwin and Shultz bid-ask spread estimator

        :param high: a series of high prices
        :param low: a series of low prices
        :return: gamma estimate
        """
        high_over_2_bars = high.rolling(window=2).max()
        low_over_2_bars = low.rolling(window=2).min()
        gamma = np.log(high_over_2_bars / low_over_2_bars) ** 2
        return gamma

    @staticmethod
    def get_alpha(beta, gamma):
        """
        Computes alpha in Corwin and Shultz bid-ask spread estimator

        :param beta: Corwin and Shultz beta estimate
        :param gamma: Corwin and Shultz gamma estimate
        :return: aplha estimate
        """
        denominator = 3 - 2 ** 1.5
        beta_term = (np.sqrt(2) - 1) * np.sqrt(beta) / denominator
        gamma_term = np.sqrt(gamma / denominator)
        alpha = beta_term - gamma_term
        alpha[alpha < 0] = 0
        return alpha

    @staticmethod
    def get_becker_parkinson_volatility(beta, gamma):
        """
        Computes Becker-Parkinson implied volatility

        :param beta: Corwin and Shultz beta estimate
        :param gamma: Corwin and Shultz gamma estimate
        :return: volatility estimate
        """
        k2 = np.sqrt(8 / np.pi)
        denominator = 3 - 2 ** 1.5
        beta_term = (2 ** (-.5) -1) * np.sqrt(beta) / (k2 * denominator)
        gamma_term = np.sqrt(gamma / (k2 ** 2 * denominator))
        volatility = beta_term + gamma_term
        volatility[volatility < 0] = 0
        return volatility



def corwin_shultz_spread(high, low, sample_length=1):
    """
    Computes an estimate of the bid-ask spread according to Corwin and Shultz estimator

    :param high: a series of high prices
    :param low: a series of low prices
    :param sample_length: number of values per sample
    :return: spread estimate
    """
    beta = CorwinShultz.get_beta(high, low, sample_length)
    gamma = CorwinShultz.get_gamma(high, low)
    alpha = CorwinShultz.get_alpha(beta, gamma)
    spread = 2 * (np.exp(alpha) - 1) / (1 + np.exp(alpha))
    return spread

def becker_parkinson_volatility(high, low, sample_length=1):
    """
    Computes implied volatility according Becker-Parkinson method

    :param high: a series of high prices
    :param low: a series of low prices
    :param sample_length: number of values per sample
    :return: volatility estimate
    """
    beta = CorwinShultz.get_beta(high, low, sample_length)
    gamma = CorwinShultz.get_gamma(high, low)
    volatility = CorwinShultz.get_becker_parkinson_volatility(beta, gamma)
    return volatility

def kyles_lambda(tick_prices, tick_volumes, tick_signs, regressor=LinearRegression()):
    """
    Estimates price impact coefficient based on Kyle's model

    :param tick_prices: a series of tick prices
    :param tick_volumes: a series of associated tick volumes
    :param regressor: a regressor to fit the estimate
    :return: Kyle's lambda
    """
    price_change = tick_prices.diff()
    net_order_flow = tick_signs * tick_volumes
    x_val   = net_order_flow.values[1:].reshape(-1, 1)
    y_val = price_change.dropna().values
    lambda_ = regressor.fit(x_val  , y_val)
    return lambda_.coef_[0]

def amihuds_lambda(close, dollar_volume, regressor=LinearRegression()):
    """
    Estimates price impact coefficient based on Amihud's model

    :param close: a series of clsoe prices
    :param dollar_volume: a series of associated dollar volumes
    :param regressor: a regressor to fit the estimate
    :return: Amihud's lambda
    """
    log_close = np.log(close)
    abs_change = np.abs(log_close.diff())
    x_val   = dollar_volume.values[1:].reshape(-1, 1)
    y_val = abs_change.dropna()
    lambda_ = regressor.fit(x_val  , y_val)
    return lambda_.coef_[0]

def hasbroucks_lambda(close, hasb_flow, regressor=LinearRegression()):
    """
    Estimates price impact coefficient based on Hasbrouck's model

    :param close: a series of clsoe prices
    :param hasb_flow: a series of net square root dollar volume of the form sum(tick_sign * sqrt(tick_price * tick_volume))
    :param regressor: a regressor to fit the estimate
    :return: Hasbrouck's lambda
    """
    ratio = pd.Series(index=close.index[1:], data=close.values[1:]/close.values[:-1])
    log_ratio = np.log(ratio)
    x_val   = hasb_flow.values[1:].reshape(-1, 1)
    y_val = log_ratio
    lambda_ = regressor.fit(x_val  , y_val)
    return lambda_.coef_[0]


def hasbroucks_flow(tick_prices, tick_volumes, tick_sings):
    """
    A helper function that computes net square root doolar volume

    :param tick_prices: a series of tick prices
    :param tick_volumes: a series of associated tick volumes
    :param tick_signs: a series of associated tick signs
    :return: net square root doolar volume
    """
    return (np.sqrt(tick_prices * tick_volumes) * tick_sings).sum()

def vpin(buy_volumes, sell_volumes, volume, num_bars):
    """
    Estimates Volume-Synchronized Probability of Informed Trading

    :param buy_volumes: a series of total volume from buy-initiated trades in each bar
    :param sell_volumes: a series of total volume from sell-initiated trades in each bar
    :param volume: volume sampling threshold used with volume bars
    :param num_bars: the size of the rolling window for the estimate
    :return: volume-synchronized probability of informed trading
    """
    abs_diff = (buy_volumes - sell_volumes).abs()
    estimated_vpin = abs_diff.rolling(window=num_bars).mean() / volume
    return estimated_vpin

def dollar_volume(tick_prices, tick_volumes):
    """
    Computes total dollar volume

    :param tick_prices: a series of tick prices
    :param tick_volumes: a series of tick_volumes
    :return: total dollar volume
    """
    return (tick_prices * tick_volumes).sum()
