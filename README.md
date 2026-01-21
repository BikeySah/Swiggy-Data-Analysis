# Swiggy-Data-Analysis
End-to-end SQL data warehouse project transforming raw Swiggy delivery data into a scalable Star Schema. Includes robust T-SQL data cleaning (handling nulls/duplicates) and dimensional modeling. Features deep-dive business analytics on revenue, geography, and cuisine performance to drive strategic decision-making.
# 🍔 Swiggy Food Delivery Business Analytics Project

### A Data Cleaning, Validation, Dimensional Modelling & Business Insight Case Study

---

## 1. Introduction

### 1.1 Project Overview

In the fast-growing food delivery ecosystem, data accuracy and analytical structure play a critical role in driving reliable business insights. Swiggy, as a large-scale food delivery platform, generates massive transactional data across multiple states, cities, restaurants, cuisines, and dishes.

This project focuses on **cleaning, validating, and transforming raw Swiggy food delivery data** into a scalable analytical model using **SQL-based data engineering techniques**. The project further derives **business KPIs and deep-dive insights** to support strategic decision-making related to revenue, customer behavior, pricing, and operational performance.

The core objective is to build a **robust star-schema data warehouse** that enables efficient reporting, BI dashboarding, and advanced analytics.

---

## 1.2 Objectives

The key objectives of this project are:

- Perform end-to-end data cleaning and validation on raw Swiggy order data  
- Identify and handle nulls, blanks, and duplicate records  
- Design and implement a **Star Schema dimensional model**  
- Populate dimension and fact tables with clean, consistent data  
- Calculate business-critical KPIs such as revenue, orders, ratings, and trends  
- Perform granular business analysis across time, location, cuisine, and restaurants  
- Build a scalable analytical foundation suitable for BI tools like **Power BI** or **Tableau**

---

## 1.3 Tools & Technologies Used

- **SQL Server** – Core data processing & transformations  
- **T-SQL** – Data cleaning, validation, and analytics queries  
- **Dimensional Modelling (Star Schema)** – Data warehouse design  
- **Relational Database Concepts** – Keys, constraints, normalization  
- **Business Intelligence Concepts** – KPIs, trends, segmentation  

---

## 2. Data Understanding & Preparation

### 2.1 Dataset Description

The raw dataset `swiggy_data` contains food delivery transaction records across multiple geographic and business dimensions.

#### Key Columns:
- `State`
- `City`
- `Order_Date`
- `Restaurant_Name`
- `Location`
- `Category` (Cuisine)
- `Dish_Name`
- `Price_INR`
- `Rating`
- `Rating_Count`

Each record represents a **single food order item**, capturing both transactional and customer feedback attributes.

---

### 2.2 Data Quality Challenges Identified

Before analysis, several data quality risks were identified:

- Missing values in critical business columns  
- Blank or empty string values  
- Duplicate transaction records  
- Mixed granularities within a single table  

Addressing these issues was essential to ensure **accurate aggregations, reliable KPIs, and trustworthy insights**.

---

## 3. Data Cleaning & Validation

### 3.1 Null Value Analysis

A comprehensive null check was performed across all business-critical columns, including:

- State  
- City  
- Order Date  
- Restaurant Name  
- Location  
- Category  
- Dish Name  
- Price  
- Rating  
- Rating Count  

This step ensured visibility into data completeness and highlighted fields requiring attention before downstream processing.

---

### 3.2 Blank & Empty String Detection

Beyond nulls, **blank and empty string values** were detected, as they often bypass standard null checks but still cause analytical inaccuracies.

Fields such as restaurant names, categories, and locations were validated to ensure meaningful values existed.

---

### 3.3 Duplicate Record Detection

Duplicate orders were identified by grouping across all business-defining attributes, including:

- Location details  
- Restaurant and dish  
- Order date  
- Price and ratings  

This ensured that repeat rows representing the same logical transaction were detected correctly.

---

### 3.4 Duplicate Removal Strategy

Using the `ROW_NUMBER()` window function, surplus duplicate rows were removed while retaining **exactly one clean record per unique order**.

This ensured:
- No revenue inflation  
- No over-counting of orders  
- Accurate trend analysis  

---

## 4. Dimensional Modelling (Star Schema)

### 4.1 Why Star Schema?

Dimensional modelling was chosen to:

- Improve query performance  
- Simplify analytical logic  
- Enable scalable BI reporting  
- Reduce data redundancy  
- Align with industry-standard analytics practices  

This approach separates descriptive attributes into dimensions and measurable values into a central fact table.

---

### 4.2 Dimension Tables Created

The following dimension tables were designed and populated:

#### 1️⃣ `dim_date`
- Full Date  
- Year  
- Month  
- Month Name  
- Quarter  
- Day  
- Week  

#### 2️⃣ `dim_location`
- State  
- City  
- Location  

#### 3️⃣ `dim_restaurant`
- Restaurant Name  

#### 4️⃣ `dim_category`
- Cuisine / Food Category  

#### 5️⃣ `dim_dish`
- Dish Name  

Each dimension contains **distinct, de-duplicated records**, ensuring consistency across the warehouse.

---

### 4.3 Fact Table Design

The central fact table `fact_swiggy_orders` stores:

- `Price_INR`
- `Rating`
- `Rating_Count`
- Foreign keys to all dimension tables  

This structure enables **multi-dimensional slicing** across time, geography, cuisine, restaurant, and dish.

---

## 5. Business KPIs & Metrics

### 5.1 Core KPIs Calculated

- Total Orders  
- Total Revenue (INR Million)  
- Average Order Value  
- Average Customer Rating  

These KPIs provide a **high-level performance snapshot** of the business.

---

## 6. Deep-Dive Business Analysis

### 6.1 Time-Based Trends

- Monthly order trends  
- Monthly revenue trends  
- Quarterly demand patterns  
- Yearly growth analysis  
- Orders by day of the week  

These analyses help identify **seasonality, peak demand periods, and growth trajectories**.

---

### 6.2 Geographic Performance

- Top cities by order volume  
- Top cities by revenue  
- Revenue contribution by state  

This insight supports **regional expansion, targeted promotions, and logistics planning**.

---

### 6.3 Restaurant & Cuisine Insights

- Top restaurants by revenue  
- Most ordered cuisines  
- Most ordered dishes  
- Cuisine-wise average ratings  

These metrics help identify **high-performing partners and customer preferences**.

---

### 6.4 Pricing & Customer Behavior Analysis

- Order distribution across price buckets  
- Rating distribution analysis  

This reveals:
- Customer spending behavior  
- Price sensitivity  
- Quality perception patterns  

---

## 7. Business Impact & Insights

### 7.1 Key Findings

- Certain cities and states dominate revenue contribution  
- A small set of restaurants generate disproportionate revenue  
- Mid-range price buckets drive maximum order volume  
- Higher-rated cuisines show stronger repeat demand  

---

### 7.2 Business Value Delivered

- Clean, analytics-ready data warehouse  
- Accurate and reliable KPI reporting  
- Scalable foundation for BI dashboards  
- Actionable insights for pricing, partnerships, and expansion  

---

## 8. Recommendations

✅ Focus marketing efforts on high-revenue cities and cuisines  
✅ Partner closely with top-performing restaurants  
✅ Optimize pricing strategies around popular spending ranges  
✅ Use ratings to improve quality control and customer satisfaction  
✅ Extend the warehouse to support real-time analytics dashboards  

---

## 9. Conclusion

This project demonstrates a **full-cycle data engineering and analytics workflow**, transforming raw Swiggy transaction data into a structured, high-performance analytical model. By combining **data cleaning, dimensional modelling, and business analysis**, the project delivers enterprise-grade insights suitable for decision-makers and BI platforms.

---

## 10. Future Scope

- Integration with Power BI / Tableau dashboards  
- Incremental data loading & automation  
- Customer segmentation analysis  
- Predictive analytics for demand forecasting  
- Advanced pricing optimization models  

---

## 👤 Author

**Bikey Sah**  
Aspiring Data Analyst | SQL | Data Engineering | Business Analytics
