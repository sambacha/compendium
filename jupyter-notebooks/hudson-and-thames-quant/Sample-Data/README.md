# Sample Data
The following folder contains 2 years sample data on S&P500 Emini Futures, for the period 2015-01-01 to 2017-01-01.

Specifically the following data structures:
* Dollar Bars: Sampled every $70'000
* Volume Bars: Sampled every 28'000 contracts
* Tick Bars: Sampled every 2'800 ticks

The following fields are available:
* Date Time
* Open
* High
* Low
* Close
* Cumulative Dollars
* Cumulative Volume
* Cumulative Ticks

## Recreate Data
To create the data structures from first principles, make use of the [mlfinlab package](https://github.com/hudson-and-thames/mlfinlab).
We made use of raw tick data.

## Purpose
Our hope is that the following samples will enable the community to build on the research and contribute to the open source community.

A good place to start for new users is to use the data provided to answer the questions at the back of chapter 2 of Advances in Financial Machine Learning.
