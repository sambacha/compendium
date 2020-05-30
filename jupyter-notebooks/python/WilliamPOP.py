
import pandas as pd
import numpy as np
import talib
from scipy.stats import ks_2samp


try:
    import pandas_datareader.data as web
except ImportError:
    import pandas.io.data as web

start = '1948-01-01'
end = '2017-01-15'
data =  web.DataReader('SPY', 'yahoo', start=start, end=end)




#%%


# Calculate William's R and SMA

# use 'point in time' data, i.e. as was, no use of 'Adj Close'
data['wilR5'] = talib.WILLR(high=data.High.values, low=data.Low.values, close=data.Close.values, timeperiod=5)
data['sma'] = data['Close'].rolling(window=50, ).mean()



# quick visual
a = data.ix['2016-01-01':'2017-01-01'] #.plot()
a.wilR5.plot(ylim=(-100,200))
a.Close.plot(secondary_y=True)
a['sma'].plot(secondary_y=True)




#%%

# now cut data in two-week streaks and for each, determine WilR in the beginning and max high and low over the period
# looks like no 'two-week period' is implemented in pandas' groupby, so we require some manual work


# for that, add all non-weekend days with no trading (so grouping by dayofweek will work cleanly)
t = pd.date_range(min(data.index), max(data.index), freq='B')
data = data.reindex(index=t, method='pad')

data['tmp'] = 0
data.ix[data.index.dayofweek==0, 'tmp']=1 # mark all Mondays

data.ix[0,'tmp'] = 1 # first value in the cumsum '1', so Monday of second week>0
data['groups'] = (data['tmp'].cumsum()/2).apply(np.floor)
del data['tmp']
data = data[data['groups']>0] # start with first full week


# calculate aggregated values
g = data.reset_index().groupby('groups')

z = pd.DataFrame({'date' : g['index'].first()
                 ,'close' : g['Close'].first()
                 ,'wilR5' : g['wilR5'].first()
                 ,'sma' : g['sma'].first()
                 #,'close_max' : g['High'].max()
                 ,'close_maxp' : g['High'].max()/g['Close'].first()-1
                 #,'close_min' : g['Low'].min()
                 ,'close_minp' : g['Low'].min()/g['Close'].first()-1
                 })



z['signal'] = 0
z.ix[z['wilR5']>-25,'signal'] = 1
z.ix[z['wilR5']<-75,'signal'] = -1

z['trend'] = 0
z.ix[z['close']>z['sma'],'trend'] = 1
z.ix[z['close']<z['sma'],'trend'] = -1



#z.groupby('signal').describe()
z.groupby(['trend','signal']).describe()



#%%

# up trend - check out highest highs

a1 = z.ix[(z['signal'] == 1) & (z['trend'] == 1), 'close_maxp']
a2 = z.ix[(z['signal'] == -1) & (z['trend'] == 1), 'close_maxp']
ks_2samp(a1, a2)


#%%

# up trend - check out lowest lows

a1 = z.ix[(z['signal'] == 1) & (z['trend'] == 1), 'close_minp']
a2 = z.ix[(z['signal'] == -1) & (z['trend'] == 1), 'close_minp']
ks_2samp(a1, a2)


#%%


# down trend - check out highest highs

a1 = z.ix[(z['signal'] == 1) & (z['trend'] == -1), 'close_maxp']
a2 = z.ix[(z['signal'] == -1) & (z['trend'] == -1), 'close_maxp']
ks_2samp(a1, a2)



#%%

# down trend - check out lowest lows

a1 = z.ix[(z['signal'] == 1) & (z['trend'] == -1), 'close_minp']
a2 = z.ix[(z['signal'] == -1) & (z['trend'] == -1), 'close_minp']
ks_2samp(a1, a2)
