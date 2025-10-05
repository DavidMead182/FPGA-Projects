import pandas as pd
import matplotlib.pyplot as plt
import plotly.graph_objects as go


aapl_df = pd.read_csv('../Data/AAPL.csv')
output_df = pd.read_csv('../Data/EMA_Output.csv')

print("AAPL.csv:")
print(aapl_df.head())

print("\noutput.csv:")
print(output_df.head())

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
fig.update_layout(title='AAPL Candlestick Chart with EMA Overlays', yaxis_title='Price (USD)', xaxis_title='Date')
fig.show()

