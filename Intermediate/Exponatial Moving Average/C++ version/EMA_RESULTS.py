import pandas as pd
import matplotlib.pyplot as plt
import plotly.graph_objects as go


aapl_df = pd.read_csv('../Data/AAPL.csv')
output_df = pd.read_csv('../Data/EMA_Output.csv')
systemVerilog_df = pd.read_csv('../Data/simulation_results.csv', names=['Index', 'buy', 'sell', 'holding', 'EMA_50', 'EMA_200', 'reset'])
# Ensure Index is integer and within bounds
systemVerilog_df['Index'] = systemVerilog_df['Index'].astype(int)
systemVerilog_df = systemVerilog_df[systemVerilog_df['Index'] < len(aapl_df)]
systemVerilog_df['Date'] = aapl_df.loc[systemVerilog_df['Index'], 'Date'].reset_index(drop=True)


print("AAPL.csv:")
print(aapl_df.head())

print("\noutput.csv:")
print(output_df.head())

# Save closing prices to a text file for the RTL Simulation
df = pd.read_csv("../DATA/AAPL.csv")
df["Close"].to_csv("../Data/APPL_closing_prices.txt", index=False, header=False)

# Convert 'Date' column to datetime
aapl_df['Date'] = pd.to_datetime(aapl_df['Date'])
output_df['Date'] = pd.to_datetime(output_df['Date'])

fig = go.Figure(data=[go.Candlestick(x=aapl_df['Date'],
                open=aapl_df['Open'],
                high=aapl_df['High'],
                low=aapl_df['Low'],
                close=aapl_df['Close'])])
fig.add_trace(go.Scatter(
                    x=output_df['Date'],
                    y=output_df['EMA_200_close'],
                    mode='lines',
                    name='EMA 200 Close Sales',
                    line=dict(color='blue')
                ))
fig.add_trace(go.Scatter(
                    x=output_df['Date'],
                    y=output_df['EMA_50_close'],
                    mode='lines',
                    name='EMA 50 Close Sales',
                    line=dict(color='orange')
                ))
fig.add_trace(go.Scatter(
                    x=output_df['Date'],
                    y=output_df['EMA_200_adjClose'],
                    mode='lines',
                    name='EMA 200 Adjusted Close Sales',
                    line=dict(color='black')
                ))
fig.add_trace(go.Scatter(
                    x=output_df['Date'],
                    y=output_df['EMA_50_adjClose'],
                    mode='lines',
                    name='EMA 50 Adjusted Close Sales',
                    line=dict(color='yellow')
                ))

# Plot EMA_50 and EMA_200 from SystemVerilog results
fig.add_trace(go.Scatter(
    x=systemVerilog_df['Date'],
    y=systemVerilog_df['EMA_50'],
    mode='lines',
    name='SV EMA 50',
    line=dict(color='cyan')
))
fig.add_trace(go.Scatter(
    x=systemVerilog_df['Date'],
    y=systemVerilog_df['EMA_200'],
    mode='lines',
    name='SV EMA 200',
    line=dict(color='purple')
))

# Plot buy and sell points
fig.add_trace(go.Scatter(
    x=systemVerilog_df['Date'][systemVerilog_df['buy'] == 1],
    y=systemVerilog_df['EMA_50'][systemVerilog_df['buy'] == 1],
    mode='markers',
    name='Buy Signal',
    marker=dict(color='lime', symbol='triangle-up', size=10)
))
fig.add_trace(go.Scatter(
    x=systemVerilog_df['Date'][systemVerilog_df['sell'] == 1],
    y=systemVerilog_df['EMA_50'][systemVerilog_df['sell'] == 1],
    mode='markers',
    name='Sell Signal',
    marker=dict(color='red', symbol='triangle-down', size=10)
))
fig.update_layout(title='AAPL Candlestick Chart with EMA Overlays', yaxis_title='Price (USD)', xaxis_title='Date')
fig.show()



