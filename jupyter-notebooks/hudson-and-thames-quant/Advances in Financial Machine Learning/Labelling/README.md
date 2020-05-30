# Research Notebooks
The following notebooks answer the questions at the back of chapter 3 but also explore the concept
of meta-labeling more in depth. This research is linked to the [research report](https://github.com/hudson-and-thames/presentations/blob/master/Does%20Meta%20Labeling%20Add%20to%20Signal%20Efficacy.pdf) and [slide show](https://github.com/hudson-and-thames/presentations/blob/master/Improved%20Signals.pdf) titled:
*Does Meta-Labeling Add to Signal Efficacy?*

## Chapter 3 - Part 1
Answers the following questions from Chapter 3:

1. Apply a symmetric CUSUM filter (Chapter 2, Section 2.5.2.1) where the threshold is the standard deviation of daily returns (Snippet 3.1).
2. Use Snippet 3.4 on a pandas series t1, where numDays=1.
3. On those sampled features, apply the triple-barrier method, where ptSl=[1,1] and t1 is the series you created in point 1.b.
4. Apply getBins to generate the labels.
5. Drop rare labels

## Meta-Labels MNIST (Toy Example)
A toy example showing how the concept of meta-labeling works and helps to build an intuition of the model. The data used was handwritten digits from the MNIST set. Traditionally MNIST is set up as a multi class classification problem but for our example we drop it to a binary classification and have the model predict if the number is a 3 or not a 3 based on a set with only the digits {3, 5}. This is because these two digits have a lot of overlap.

## Trend Following Question
Fit a primary model based on trend following and then add meta-labeling to improve the the model and strategy performance metrics. Show results out-of-sample.

## BBand Question
Fit a primary model based on mean reversion and then add meta-labeling to improve the the model and strategy performance metrics. Show results out-of-sample.
