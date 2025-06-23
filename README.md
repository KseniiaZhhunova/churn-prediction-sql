SQL project analyzing churn behavior in a subscription-based fintech app

# Churn Prediction Audit (SQL) – Fintech App

> *This project analyzes churn behavior using SQL across a simulated fintech user lifecycle dataset. This project reflects the patterns and logic I’ve encountered in real-world churn and retention work.*

---

## Business Case

Your team has been asked to investigate potential user churn risks in a subscription-based finance platform. The product team suspects that support ticket trends, failed payments, and early inactivity may be predictive of churn.

---

## Dataset Overview

**Note**: This dataset was synthetically generated to simulate churn patterns in a fintech app, modeled to mirror typical user lifecycles.

**Tables used:**
- `users`: user_id, signup_date, country, plan_type, age
- `transactions`: payment activity and success/failure flags
- `logins`: login frequency over time
- `support_tickets`: complaints, refund requests, or downgrade issues

---

## Project Goals

1. **Define churn behavior**
   - Example: no login for 30+ days, refund + downgrade, or repeated payment failures
2. **Identify churn risk signals**
   - Early login drop-off
   - Support escalation
   - Failed payment patterns
3. **Surface insights for the product team**
   - What patterns precede churn?
   - Are there demographic or regional risk concentrations?

---

## Churn Definition

For this analysis, a user is considered **churned** if they meet one or more of the following:

1. **Have not logged in for 30+ days** since their last recorded activity
2. **AND have fewer than 3 successful transactions**
3. **OR have submitted a support ticket for a 'Refund Request' or 'Downgrade Dispute'**

---

## Tools Used

- MySQL + SQL Workbench
- GitHub for version control
- Manual data exploration via SQL queries
- Dataset generated and cleaned using Python (Faker, Pandas)

---

## File Structure

/churn-prediction-sql
├── README.md ← this file
├── data/
│ ├── data_users.csv
│ ├── data_transactions.csv
│ ├── data_logins.csv
│ └── data_support_tickets.csv
├── sql/
│ └── churn_queries.sql ← main analysis queries
├── insights.md ← summary of findings


---

## Questions or Feedback?

I welcome feedback from data leaders and hiring managers — connect with me on via LinkedIn or reach out directly.




