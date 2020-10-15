SELECT
    T0.StockId
    ,T0.QuoteId
    ,T0.QuoteDay
    ,T0.QuoteClose
    ,AVG(T0.QuoteClose) OVER (PARTITION BY T0.StockId ORDER BY T0.QuoteId ROWS 19 PRECEDING) AS MA20
    ,AVG(T0.QuoteClose) OVER (PARTITION BY T0.StockId ORDER BY T0.QuoteId ROWS 19 PRECEDING)
        + (STDEV(T0.QuoteClose) OVER (PARTITION BY T0.StockId ORDER BY T0.QuoteId ROWS 19 PRECEDING) * 2) AS UpperBollinger
    ,AVG(T0.QuoteClose) OVER (PARTITION BY T0.StockId ORDER BY T0.QuoteId ROWS 19 PRECEDING)
        - (STDEV(T0.QuoteClose) OVER (PARTITION BY T0.StockId ORDER BY T0.QuoteId ROWS 19 PRECEDING) * 2) AS LowerBollinger
FROM
    dbo.Quotes AS T0
