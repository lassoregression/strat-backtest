# strat-backtest
<h1>Algorithmic Trading System (MATLAB)</h1>


<h2>Description</h2>
The primary objective of this project was to design and implement an algo trading system that operates on real-time market data, focusing on the Mag 7 stocks. These are high-cap stocks known for their influence and stability in the market.


The trading strategy utilizes two primary technical indicators: the Moving Average Convergence Divergence, or MACD, and the Relative Strength Index, or RSI. These indicators help us determine the optimal entry and exit points by signaling potential reversals and ongoing trends in the stock prices.


The system buys stocks when the MACD crosses above its signal line and the RSI indicates an oversold condition. Conversely, it sell stocks when the MACD crosses below its signal line and the RSI indicates an overbought condition.<br />


<h2>Languages and Utilities Used</h2>

- <b>MATLAB</b> 
- <b>IBMatlab (Interactive Brokers)</b>


<h2>Screenshot of the GUI:</h2>

<p align="center">
The GUI tracks open positions and calculates individual security P&L alongside overall portfolio P&L. It features an interactive table displaying current positions, entry prices, and current prices for each security. Additionally, a real-time line chart visualizes the profit and loss over time, providing a clear view of the performance of individual securities as well as the entire portfolio. The interface includes buttons for loading data and initiating trades, ensuring a user-friendly experience for backtesting trading strategies.
<br>
  <br/>
<img src="https://i.imgur.com/FHw8Rzm.png" height="80%" width="80%" alt="Trading Strat Simulation"/>
<br />
<br />

- <b>Note: This is a backtest run using weekly 5-second ticker data (resulting in the negative P&L and trades ending on May 11). The screenshot is to verify the functionality of the GUI and strategy, and it does not reflect live data.</b>
</p>

<!--
 ```diff
- text in red
+ text in green
! text in orange
# text in gray
@@ text in purple (and bold)@@
```
