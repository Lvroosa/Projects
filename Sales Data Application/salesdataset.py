import streamlit as st
import pandas as pd
import numpy as np

df = pd.read_csv('sales.csv')

st.title('Sales Dashboard')

# Converting the date column to ymd format
df['Date'] = pd.to_datetime(df['Date']).dt.strftime('%Y-%m-%d')

# Create a start date and end date sidebar filter
start_date = st.sidebar.date_input('Start date', pd.to_datetime(df['Date']).min())
end_date = st.sidebar.date_input('End date', pd.to_datetime(df['Date']).max())

# Filtering dataFrame by date range
filtered_df = df[
    (pd.to_datetime(df['Date']) >= pd.to_datetime(start_date)) &
    (pd.to_datetime(df['Date']) <= pd.to_datetime(end_date))
]

# Creating a sidebar filter to choose market
market = st.sidebar.multiselect('Market', df['Market'].unique())

# Further filtering the DataFrame by selected markets
if market:
    filtered_df = filtered_df[filtered_df['Market'].isin(market)]

# Creating metric of total sales and one of total profit side by side
col1, col2 = st.columns(2)
col1.metric('Total Sales', f"${filtered_df['Sales'].sum():,}")
col2.metric('Total Profit', f"${filtered_df['Profit'].sum():,}")

# Creating a stacked bar chart of sales and profit by product type
st.subheader('Sales and Profit by Product Type')
product_data = filtered_df.groupby('Product Type')[['Sales', 'Profit']].sum().reset_index()
st.bar_chart(product_data.set_index('Product Type'))