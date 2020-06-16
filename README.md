# ampute-impute-stockprice
<b> KNN Imputation for a portfolio</b>

It a topic of concern how to deal with the missing stock price data due to various reasons. One of the prominent reason why the stock prices have missing values is that the markets close for holidays, daily stock prices are not always observed. This creates gaps in information, making it difficult to predict the following day's stock prices. To predict what should be the actual pattern, there are various methods to impute data. Imputation is the process of replacing missing data with substituted values.

The objective of this study is to:
1. Generate or <b>ampute</b> missingness in multivariate data for a portfolio with 10 stocks with the introduction of missingness as per day of the week (eg. Higher chances of missing data later in the week).

2. After amputation, Use the <b>KNN imputation</b> to predict the missing values of stocks in the portfolio.

