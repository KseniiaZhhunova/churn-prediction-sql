# Churn Analysis – Insights

This analysis evaluates user churn within a simulated fintech product using SQL logic that mimics real-world business definitions.

---

## Key Metrics

- **Total Users**: 750
- **Churned Users**: 157
- **Churn Rate**: 20.9%

---

## Segment Highlights

### By Plan Type:
- **Free Plan**: 35.2% churn
- **Basic Plan**: 18.6% churn
- **Premium Plan**: 8.9% churn

Insight: Users on the Free Plan are 4x more likely to churn than Premium users.

---

### By Age Group:
- **Under 25**: 28.5% churn
- **25–34**: 22.1% churn
- **35–44**: 17.4% churn
- **45–54**: 15.6% churn
- **55+**: 11.2% churn

Insight: Younger users show the highest disengagement. Tailored onboarding or engagement strategies could reduce this.

---

### Support Ticket Impact:
- Users with refund/downgrade issues churned at **42.7%**
- Users with no ticket churned at **16.3%**

Insight: Support interactions, especially negative ones, are strong predictors of churn. Proactive handling could drive retention.

---

## Recommendations

1. **Enhance onboarding and product value for Free users**  
   → Introduce limited-time features or gamify milestones

2. **Target 18–25 segment with early lifecycle engagement**  
   → Push notifications, welcome emails, or community building

3. **Flag and prioritize refund/downgrade tickets for intervention**  
   → Predictive retention efforts may help recover users before exit

---

## Analysis Notes

- Churn is defined as **30+ days inactive with < 3 successful transactions**, OR a **support ticket related to refund/downgrade**
- All logic was written in **SQL** and performed using **synthetic data**
- See `sql/churn_queries.sql` for detailed logic and CTE breakdown

---