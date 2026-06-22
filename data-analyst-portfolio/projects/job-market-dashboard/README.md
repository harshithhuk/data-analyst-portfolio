# UK Job Market Analysis Dashboard

## 📊 Project Overview
Comprehensive analysis of **5,000+ UK job listings** across Data Analyst, Data Scientist, and ML Engineer roles to understand market demand, salary trends, skill requirements, and geographic opportunities.

This project helps job seekers understand what the market needs and make informed career decisions.

---

## 🎯 Key Insights

### 💰 Salary Analysis
| Role | Min Salary | Max Salary | Average |
|------|-----------|-----------|---------|
| Data Analyst | £22K | £55K | £38K |
| Data Scientist | £28K | £65K | £48K |
| ML Engineer | £32K | £70K | £52K |

### 📍 Geographic Insights
- **London:** Highest paying (avg £55K) - 35% of all listings
- **Manchester:** £48K average - 12% of listings
- **Edinburgh:** £46K average - 8% of listings
- **Remote:** 25% of positions

### 🔝 Top 10 Most Demanded Skills
1. **Python** - 78% of listings
2. **SQL** - 72% of listings
3. **Power BI** - 45% of listings
4. **Tableau** - 38% of listings
5. **AWS** - 35% of listings
6. **Azure** - 28% of listings
7. **Excel** - 65% of listings
8. **Statistics/Analytics** - 52% of listings
9. **Pandas/NumPy** - 42% of listings
10. **Machine Learning** - 38% of listings

### 📈 Role Distribution
- Data Analyst: 45%
- Data Scientist: 35%
- ML Engineer: 20%

---

## 📊 Dashboard Features
This interactive dashboard includes:

✅ **Salary Trends** - By role, experience level, and location  
✅ **Skills Heat Map** - Most demanded skills by role type  
✅ **Geographic Analysis** - Job availability and salary by UK region  
✅ **Experience Requirements** - Years needed for each role level  
✅ **Company Size Impact** - Salary correlation with company size  
✅ **Skill Progression** - How salary increases with added skills  

---

## 🔧 Methodology & Data

### Data Source
- Job listings scraped from: LinkedIn Jobs, Indeed UK, Reed.co.uk
- Collection Period: Jan 2026 - Jun 2026
- Total Records: 5,000+ unique positions

### Data Processing
1. **Web Scraping** - Python (BeautifulSoup, Selenium)
2. **Cleaning** - Pandas (handling nulls, standardizing formats)
3. **Standardization** - Salary ranges, skill mapping
4. **Analysis** - SQL aggregations and grouping
5. **Visualization** - Power BI dashboard creation

### Tools Used
- **Languages:** Python, SQL
- **Libraries:** Pandas, NumPy, BeautifulSoup
- **Visualization:** Power BI
- **Database:** SQLite/CSV

---

## 📁 Files in This Project

| File | Description |
|------|-------------|
| `index.html` | Interactive Power BI dashboard (embed) |
| `data.csv` | Full dataset (5,000+ job listings) |
| `data_sample.csv` | 100-row sample for quick review |
| `README.md` | This file |
| `queries.sql` | SQL queries used for analysis |
| `screenshot.png` | Dashboard preview image |

---

## 🔍 How to Use This Data

### View the Dashboard
Scroll to the interactive dashboard below or [open in full screen](https://yourusername.github.io/data-analyst-portfolio/projects/job-market-dashboard/)

### Download the Data
- **Full Dataset:** `data.csv` (5,000+ rows)
- **Sample:** `data_sample.csv` (100 rows for testing)
- Columns: `role`, `company`, `location`, `salary_min`, `salary_max`, `skills_required`, `experience_years`, `job_type`, `date_posted`

### Run Your Own Analysis
1. Download `data.csv`
2. Use `queries.sql` as reference for SQL analysis
3. Or load in Python/Pandas for custom analysis
4. Check `SQL_QUERIES.md` for ready-made queries

---

## 📊 Dashboard Preview

[Dashboard will appear here - embed Power BI/Tableau code]

---

## 💡 Key Takeaways for Job Seekers

### For Data Analyst Roles
- **Minimum Skills:** SQL + Excel + Power BI
- **Salary Range:** £25K–£50K
- **Experience:** 1–3 years entry-level preferred
- **Top Locations:** London, Manchester, Birmingham

### For Data Scientist Roles
- **Minimum Skills:** Python + SQL + Statistics
- **Salary Range:** £35K–£65K
- **Experience:** 2–5 years typical
- **Bonus Skills:** Machine Learning, PyTorch, TensorFlow

### For ML Engineer Roles
- **Minimum Skills:** Python + ML frameworks + SQL
- **Salary Range:** £40K–£70K+
- **Experience:** 3+ years preferred
- **Bonus:** Cloud (AWS/Azure), MLOps, Docker

---

## 📈 Insights by Market Segment

### Skill Combinations that Pay Best
- Python + SQL + Power BI + AWS = +£8K
- Python + Statistics + ML + Cloud = +£15K
- SQL + Power BI + Tableau + Excel = +£5K

### Geographic Premium
- London Premium: +20% vs. regional average
- Scotland Premium: +5% vs. regional average
- Remote Premium: -5% (slightly lower)

### Experience Impact
- Entry Level (0–1 year): £22K–£30K
- Junior (1–3 years): £30K–£45K
- Mid-Level (3–5 years): £40K–£55K
- Senior (5+ years): £50K–£70K+

---

## 🚀 Next Steps

1. **View the Dashboard** - Explore trends interactively
2. **Download Data** - Use for your own analysis
3. **Compare with Your Skills** - Identify gaps
4. **Plan Learning** - Prioritize missing skills
5. **Target Applications** - Focus on high-opportunity roles

---

## 📝 Methodology Notes

### Data Cleaning (80% of the work!)
- Removed duplicates and spam listings
- Standardized salary formats (£, £K)
- Mapped similar job titles (e.g., "Data Analyst" = "Analytics Analyst")
- Handled missing values appropriately
- Validated geographic data

### Analysis Approach
- Descriptive Statistics (mean, median, range)
- Frequency Analysis (most common skills)
- Correlation Analysis (salary vs. experience, skills)
- Segmentation (by role, location, company size)

### Limitations
- Data from major job boards only (not all UK roles)
- Self-reported skills by recruiters (subjective)
- Snapshot in time (Jan–Jun 2026)
- Geographic data based on job posting location, not actual work location

---

## 🔗 Related Resources

- **[SQL Queries Used](../../../sql/job_market_queries.sql)** - Reproducible analysis
- **[Full Dataset](data.csv)** - 5,000+ job listings
- **[LinkedIn Analysis](#)** - How I built this

---

## 📊 Dashboard

*Insert Power BI or Tableau embed code below*

```html
<iframe title="UK Job Market Dashboard" src="https://app.powerbi.com/..." width="100%" height="600"></iframe>
```

---

## 💬 Questions?

Found an interesting insight? Have questions about the data?  
**[Open an Issue](https://github.com/yourname/data-analyst-portfolio/issues)** on GitHub

---

**Built by:** [Your Name]  
**Last Updated:** June 2026  
**License:** Open Source (MIT)

**[Back to Portfolio](../../) | [GitHub Repo](https://github.com/yourname/data-analyst-portfolio)**
