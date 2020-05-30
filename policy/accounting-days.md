# Day Count Interval 

0 indicates US (NASD) 30/360 - This assumes 30 day months and 360 day years as per the National Association of Securities Dealers standard, and performs specific adjustments to entered dates which fall at the end of months.

1 indicates Actual/Actual - This calculates based upon the actual number of days between the specified dates, and the actual number of days in the intervening years. Used for US Treasury Bonds and Bills, but also the most relevant for non-financial use.

2 indicates Actual/360 - This calculates based on the actual number of days between the specified dates, but assumes a 360 day year.

3 indicates Actual/365 - This calculates based on the actual number of days between the specified dates, but assumes a 365 day year.

4 indicates European 30/360 - Similar to 0, this calculates based on a 30 day month and 360 day year, but adjusts end-of-month dates according to European financial conventions.