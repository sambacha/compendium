<div align="center">
  <img src="https://raw.githubusercontent.com/hudson-and-thames/mlfinlab/master/.github/logo/hudson_and_thames_logo.png" height="300"><br>
</div>

-----------------

# Research Repo

Contains all the Jupyter Notebooks used in our research.

All of the research we do in these notebooks is on the full tick history dataset from Tick Data LLC, but not provided because of royalty fees.  The data can be purchased for about $750 US Dollars for the full history of a single ticker.

We do provide a 2 year sample on tick, volume, and dollar bars to help the community get started. 

## Contributing

<div align="center">
  <img src="https://raw.githubusercontent.com/hudson-and-thames/research/master/Chapter3/readme_image.png" height="350"><br>
</div>

Our hope is that the sample data and notebooks will enable the community to build on the research and contribute to the open source community. 

A good place to start for new users is to use the data provided to answer the questions at the back of the chapters in Advances in Financial Machine Learning.

Please review the [Guidelines](https://github.com/hudson-and-thames/research/tree/master/Guidelines.md) for research

### Sample Data

The following [folder](https://github.com/hudson-and-thames/research/tree/master/Sample-Data) contains 2 years sample data on S&P500 Emini Futures, for the period 2015-01-01 to 2017-01-01.

Specifically the following data structures:
* Dollar Bars: Sampled every $70'000
* Volume Bars: Sampled every 28'000 contracts
* Tick Bars: Sampled every 2'800 ticks

## Installation

Recommended versions:
* Anaconda 3
* Python 3.6

### Installation for Mac OS X and Ubuntu Linux

1. Make sure you install the latest version of the Anaconda 3 distribution. To do this you can follow the install and update instructions found on this link: https://www.anaconda.com/download/#mac
2. Launch a terminal
3. Create a New Conda Environment. From terminal: ```conda create -n <env name> python=3.6 anaconda``` accept all the requests to install.
4. Now activate the environment with ```source activate <env name>```.
5. From Terminal: go to the directory where you have saved the file, example: cd Desktop/research/.
6. Install Python requirements, by running the command: ```pip install -r requirements.txt```
7. (Optional) Continue to Chapter-specific Installation 

### Installation for Windows

1. Download and install the latest version of [Anaconda 3](https://www.anaconda.com/distribution/#download-section)
2. Launch Anaconda Navigator
3. Click Environments, choose an environment name, select Python 3.6, and click Create
4. Click Home, browse to your new environment, and click Install under Jupyter Notebook
5. Launch Anaconda Prompt and activate the environment: ```conda activate <env name>```
6. From Anaconda Prompt: go to the directory where you have saved the file, example: cd Desktop/research/.
7. Install Python requirements, by running the command: ```pip install -r requirements.txt```
8. (Optional) Continue to Chapter-specific Installation 

### Chapter-specific Installation

We will create a symlink inside each of the Chapters for ease of dataset changes. You may change the symlink of `official_data` to your own dataset rather than using the 2 year sample; the format follows Tick Data LLC.

Create a symbolic link inside the Chapter folder to where you saved the official data:

``` cd Chapter3; ln -s ../Sample-Data official_data ```

## Additional Research Repo
BlackArbsCEO has a great repo based on de Prado's research. It covers many of the questions at the back of every chapter and was the first source on Github to do so. It has also been a good source of inspiration for our research.

* [Adv Fin ML Exercises](https://github.com/BlackArbsCEO/Adv_Fin_ML_Exercises)
