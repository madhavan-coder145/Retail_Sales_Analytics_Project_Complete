import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv("retail_sales_50000.csv", parse_dates=["Order_Date"])

# Basic inspection
print(df.shape)
print(df.info())
print(df.isna().sum())

# Cleaning
df["Discount"] = df["Discount"].fillna(0)
df["Payment_Method"] = df["Payment_Method"].fillna("Unknown")
df = df.drop_duplicates()

# Derived fields
df["Month"] = df["Order_Date"].dt.to_period("M").astype(str)
df["Profit_Margin"] = df["Profit"] / df["Sales"].replace(0, pd.NA)

# Summary
summary = df[["Sales", "Profit", "Quantity"]].describe()
print(summary)

# Monthly trend
monthly = df.groupby("Month", as_index=False)[["Sales", "Profit"]].sum()
monthly.plot(x="Month", y="Sales", kind="line", figsize=(12,5), title="Monthly Sales Trend")
plt.xticks(rotation=45)
plt.tight_layout()
plt.show()

# Category analysis
category = df.groupby("Category", as_index=False)[["Sales", "Profit"]].sum().sort_values("Sales", ascending=False)
category.plot(x="Category", y="Sales", kind="bar", figsize=(10,5), title="Sales by Category")
plt.tight_layout()
plt.show()

# City analysis
city = df.groupby("City", as_index=False)[["Sales", "Profit"]].sum().sort_values("Sales", ascending=False)
print(city)

# Top products
top_products = df.groupby(["Product","Category"], as_index=False)[["Sales","Profit"]].sum().sort_values("Sales", ascending=False).head(10)
print(top_products)

# Export cleaned data and summaries
df.to_csv("retail_sales_cleaned.csv", index=False)
monthly.to_csv("monthly_summary.csv", index=False)
category.to_csv("category_summary.csv", index=False)
city.to_csv("city_summary.csv", index=False)
