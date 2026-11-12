import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import os

print("RETAIL SALES ANALYTICS PROJECT")
print("=" * 50)

os.makedirs("output", exist_ok=True)

df = pd.read_csv("retail_sales_50000.csv")

print("\n1. DATASET OVERVIEW")
print("Rows:", df.shape[0])
print("Columns:", df.shape[1])
print(df.head())

print("\n2. DATA INFORMATION")
df.info()

print("\n3. MISSING VALUES")
print(df.isnull().sum())

print("\n4. DUPLICATE RECORDS")
print("Duplicates:", df.duplicated().sum())

df["Order_Date"] = pd.to_datetime(df["Order_Date"], errors="coerce")
df["Discount"] = df["Discount"].fillna(0)
df["Payment_Method"] = df["Payment_Method"].fillna("Unknown")

print("\n5. BUSINESS PERFORMANCE")

total_sales = df["Sales"].sum()
total_profit = df["Profit"].sum()
total_orders = len(df)
average_order_value = df["Sales"].mean()
profit_margin = (total_profit / total_sales) * 100

print("Total Orders:", total_orders)
print("Total Revenue:", round(total_sales, 2))
print("Total Profit:", round(total_profit, 2))
print("Average Order Value:", round(average_order_value, 2))
print("Profit Margin:", round(profit_margin, 2), "%")

print("\n6. CATEGORY ANALYSIS")
category_sales = df.groupby("Category")["Sales"].sum().sort_values(ascending=False)
print(category_sales)

print("\n7. CITY ANALYSIS")
city_sales = df.groupby("City")["Sales"].sum().sort_values(ascending=False)
print(city_sales)

print("\n8. TOP 10 PRODUCTS")
top_products = df.groupby("Product")["Sales"].sum().sort_values(ascending=False).head(10)
print(top_products)

print("\n9. PAYMENT METHOD ANALYSIS")
payment_analysis = df.groupby("Payment_Method")["Sales"].sum()
print(payment_analysis)

print("\n10. MONTHLY SALES ANALYSIS")
df["Month"] = df["Order_Date"].dt.to_period("M").astype(str)
monthly_sales = df.groupby("Month")["Sales"].sum()
print(monthly_sales)

plt.figure(figsize=(12, 6))
monthly_sales.plot(kind="line", marker="o")
plt.title("Monthly Sales Trend")
plt.xlabel("Month")
plt.ylabel("Revenue")
plt.xticks(rotation=45)
plt.tight_layout()
plt.savefig("output/monthly_sales_trend.png")
plt.close()

plt.figure(figsize=(10, 6))
category_sales.plot(kind="bar")
plt.title("Category-wise Sales")
plt.xlabel("Category")
plt.ylabel("Revenue")
plt.xticks(rotation=45)
plt.tight_layout()
plt.savefig("output/category_sales.png")
plt.close()

plt.figure(figsize=(10, 6))
city_sales.plot(kind="bar")
plt.title("City-wise Sales")
plt.xlabel("City")
plt.ylabel("Revenue")
plt.xticks(rotation=45)
plt.tight_layout()
plt.savefig("output/city_sales.png")
plt.close()

plt.figure(figsize=(10, 6))
top_products.plot(kind="bar")
plt.title("Top 10 Products")
plt.xlabel("Product")
plt.ylabel("Revenue")
plt.xticks(rotation=45)
plt.tight_layout()
plt.savefig("output/top_10_products.png")
plt.close()

plt.figure(figsize=(8, 6))
payment_analysis.plot(kind="pie", autopct="%1.1f%%")
plt.title("Payment Method Distribution")
plt.ylabel("")
plt.tight_layout()
plt.savefig("output/payment_method.png")
plt.close()

plt.figure(figsize=(10, 6))
df.boxplot(column="Sales", by="Category")
plt.title("Sales Distribution by Category")
plt.suptitle("")
plt.xlabel("Category")
plt.ylabel("Sales")
plt.tight_layout()
plt.savefig("output/sales_distribution.png")
plt.close()

df.to_csv("output/retail_sales_cleaned.csv", index=False)

print("\nPYTHON EDA COMPLETED SUCCESSFULLY!")
print("6 charts saved in output folder.")
print("Cleaned dataset saved.")
