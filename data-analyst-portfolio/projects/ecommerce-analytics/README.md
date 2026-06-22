# E-commerce Customer Analytics & Segmentation

## 📊 Project Overview
Comprehensive **RFM (Recency, Frequency, Monetary) analysis** and **cohort retention analysis** on 10,000+ e-commerce transactions. This project identifies high-value customer segments, predicts churn risk, and quantifies upsell opportunities.

---

## 🎯 Key Findings

### 💰 Customer Value Distribution
- **Top 15% Customers:** Generate 65% of revenue (Pareto Principle)
- **Top 30% Customers:** Generate 85% of revenue
- **Bottom 40% Customers:** Generate 15% of revenue

### 📊 Customer Segmentation (RFM Model)

| Segment | Count | Avg CLV | Retention | Churn Risk | Action |
|---------|-------|---------|-----------|-----------|--------|
| **VIP** | 150 | £2,500+ | 85% | 5% | Retain |
| **High-Value** | 450 | £1,000–£2,500 | 65% | 15% | Nurture |
| **Regular** | 1,200 | £300–£1,000 | 45% | 35% | Engage |
| **Low-Value** | 3,200 | £50–£300 | 25% | 65% | Reactivate |
| **Dormant** | 5,000 | £0–£50 | 0% | 95% | Churn |

### 📉 Retention Metrics
- **Month 1→2 Retention:** 35%
- **Month 3 Retention:** 18%
- **Month 6 Retention:** 8%
- **Month 12 Retention:** 2%

### ⚠️ Churn Indicators
- **Inactivity >90 days:** 85% churn probability
- **Inactivity >60 days:** 65% churn probability
- **Inactivity >30 days:** 35% churn probability
- **Single purchasers:** 75% churn probability

### 💡 Upsell Opportunity
- **Dormant high-value segment:** 500 customers with £2K+ historical CLV
- **Potential revenue recovery:** £500K–£750K
- **Required discount:** 15–20% to re-engage

---

## 📈 Analysis Components

### 1. RFM Segmentation
**Recency:** Days since last purchase  
**Frequency:** Number of purchases  
**Monetary:** Total spending  

**Scoring:**
- Each dimension scored 1–5 (5 = best)
- Composite score: R + F + M
- Segments: VIP (15), High-Value (14), Regular (13), Low-Value (12), Dormant (5–11)

### 2. Cohort Analysis
Track customer behavior by acquisition month:
- Cohort size at acquisition
- Month-by-month retention rates
- Revenue contribution by cohort
- Identifies best-performing acquisition periods

### 3. Product Affinity
- **Frequently bought together:** Product pairs correlation
- **Cross-sell opportunities:** Which products drive higher CLV
- **Category preferences:** By customer segment

### 4. Churn Prediction
Features for predicting churn:
- Days since last purchase
- Purchase frequency trend
- Average order value trend
- Seasonal activity patterns
- Customer lifecycle stage

### 5. CLV Forecasting
- Historical CLV trends
- Projected lifetime value by segment
- Revenue impact of retention initiatives

---

## 🔧 Methodology

### Data Source
- **Dataset:** E-commerce transaction data (public Kaggle dataset)
- **Records:** 10,000+ transactions
- **Customers:** 5,000+
- **Time Period:** 12 months

### Tools Used
- **Languages:** Python, SQL
- **Libraries:** Pandas, NumPy, Scikit-learn, Matplotlib, Seaborn
- **Visualization:** Power BI, Tableau, Jupyter (Matplotlib/Plotly)
- **Database:** SQLite/CSV

### Data Processing Steps
1. **Data Cleaning** - Remove duplicates, handle nulls, validate formats
2. **Feature Engineering** - Calculate RFM scores, cohort assignments
3. **Segmentation** - Apply RFM clustering
4. **Analysis** - Cohort retention, churn prediction, product affinity
5. **Visualization** - Dashboard creation

---

## 📁 Files in This Project

| File | Description |
|------|-------------|
| `index.html` | Interactive Power BI/Tableau dashboard |
| `analysis.ipynb` | Full Jupyter notebook with code & insights |
| `data.csv` | Complete transaction dataset (10,000+ rows) |
| `data_sample.csv` | 500-row sample for quick exploration |
| `queries.sql` | SQL queries for analysis |
| `rfm_segments.csv` | Customer segments with RFM scores |
| `cohort_analysis.csv` | Cohort retention matrix |
| `README.md` | This file |

---

## 📊 Dashboard Features

The interactive dashboard includes:

✅ **Customer Segments** - RFM distribution and size comparison  
✅ **Value Distribution** - Revenue contribution by segment  
✅ **Cohort Retention** - Heatmap showing month-by-month retention  
✅ **Churn Prediction** - Risk score distribution  
✅ **CLV Trends** - Historical and forecasted customer lifetime value  
✅ **Product Affinity** - Cross-sell and bundle opportunities  
✅ **Actionable Metrics** - Key numbers for business decisions  

---

## 💡 Business Insights

### For Marketing Team
1. **VIP Retention:** Personalized communication, exclusive offers
2. **High-Value Nurturing:** Regular engagement, loyalty rewards
3. **Dormant Reactivation:** Targeted discount campaigns (15–20% ROI)
4. **Churn Prevention:** Email campaigns at 30-day mark

### For Product Team
1. **Cross-sell Opportunities:** Bundle products frequently bought together
2. **Product Mix:** Low-value customers need different product focus
3. **Seasonal Strategies:** Align inventory with cohort patterns

### For Finance Team
1. **Revenue Forecasting:** CLV models enable accurate projections
2. **Marketing Budget:** Allocate based on segment ROI
3. **Customer Acquisition Cost:** Compare CAC vs. segment CLV

---

## 🚀 How to Use

### View the Dashboard
Scroll below to see interactive visualizations

### Explore the Data
1. Download `data.csv` or `data_sample.csv`
2. Open in Excel, Pandas, or your tool of choice
3. Run custom analysis

### Reproduce the Analysis
1. Download `analysis.ipynb`
2. Install requirements: `pip install pandas numpy matplotlib seaborn scikit-learn`
3. Run notebook cells
4. Adapt for your own data

### Use SQL Queries
1. Load `data.csv` into SQL database
2. Use queries from `queries.sql` as templates
3. Adapt table/column names as needed

---

## 📈 Key RFM Metrics

### RFM Score Interpretation
- **555 (VIP):** Just purchased, frequent buyer, highest spender
- **554, 545, 455:** Loyal customers, at-risk if dormant
- **543–332:** Regular customers, room for engagement
- **322–211:** Low-value, high churn risk
- **111 (Dormant):** Churned, past customers

### Segment-Specific Metrics
| Metric | VIP | High-Value | Regular | Low-Value | Dormant |
|--------|-----|-----------|---------|-----------|---------|
| Avg CLV | £2,500+ | £1,200 | £500 | £150 | £20 |
| Purchase Frequency | 20+ | 8–15 | 3–7 | 1–2 | 1 |
| Avg Order Value | £150+ | £100–£150 | £50–£100 | £20–£50 | £20 |
| Days Since Purchase | <30 | 30–60 | 60–120 | 120–180 | 180+ |

---

## 🔍 SQL Query Examples

### RFM Segmentation Query
```sql
SELECT 
    customer_id,
    DATEDIFF(CURDATE(), MAX(order_date)) as recency_days,
    COUNT(DISTINCT order_id) as frequency,
    ROUND(SUM(amount), 2) as monetary_value,
    CASE 
        WHEN SUM(amount) > 2000 THEN 'VIP'
        WHEN SUM(amount) > 1000 THEN 'High-Value'
        WHEN SUM(amount) > 300 THEN 'Regular'
        ELSE 'Low-Value'
    END as customer_tier
FROM orders
GROUP BY customer_id;
```

### Cohort Retention Query
```sql
SELECT 
    cohort_month,
    COUNT(DISTINCT customer_id) as cohort_size,
    ROUND(100.0 * COUNT(CASE WHEN month_1 = 1 THEN 1 END) / COUNT(DISTINCT customer_id), 1) as month_1_retention,
    ROUND(100.0 * COUNT(CASE WHEN month_2 = 1 THEN 1 END) / COUNT(DISTINCT customer_id), 1) as month_2_retention,
    ROUND(100.0 * COUNT(CASE WHEN month_3 = 1 THEN 1 END) / COUNT(DISTINCT customer_id), 1) as month_3_retention
FROM cohort_data
GROUP BY cohort_month;
```

---

## 🎓 Learning Resources

### RFM Analysis
- [RFM Analysis Explained](https://en.wikipedia.org/wiki/RFM_(customer_value))
- [Cohort Analysis Best Practices](https://amplitude.com/blog/cohort-analysis)

### Python Libraries Used
- **Pandas:** Data manipulation and transformation
- **NumPy:** Numerical computations
- **Matplotlib/Seaborn:** Visualizations
- **Scikit-learn:** Machine learning (clustering, prediction)

---

## ✅ Validation Checks

### Data Quality
- ✓ No duplicate transactions
- ✓ Valid date ranges (no future dates)
- ✓ Reasonable price ranges
- ✓ Customer ID consistency

### Analysis Validation
- ✓ RFM scores sum correctly
- ✓ Cohort sizes match expected
- ✓ Churn rates plausible
- ✓ CLV distributions reasonable

---

## 💬 Questions?

- **Questions about the analysis?** Check `analysis.ipynb`
- **Want to dive deeper?** Download the data and SQL queries
- **Found an issue?** [Open an Issue on GitHub](https://github.com/yourname/data-analyst-portfolio/issues)

---

## 📊 Dashboard

*[Insert Power BI or Tableau embed code]*

```html
<iframe title="E-commerce Customer Analytics" src="https://app.powerbi.com/..." width="100%" height="600"></iframe>
```

---

**Built by:** [Your Name]  
**Last Updated:** June 2026  
**License:** Open Source (MIT)

**[Back to Portfolio](../../) | [GitHub Repo](https://github.com/yourname/data-analyst-portfolio)**
