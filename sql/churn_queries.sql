-- CHURN DEFINITION (Business Logic)
--
-- A user is considered churned if:
-- 1. They have not logged in for 30+ days after signup
--    AND have made fewer than 3 successful transactions
-- OR
-- 2. They submitted a support ticket related to a refund or downgrade
--


-- USER CHURN DETECTION QUERY

WITH last_login AS (
    SELECT user_id, MAX(login_date) AS last_login
    FROM logins
    GROUP BY user_id
),

txn_summary AS (
    SELECT user_id, COUNT(*) AS txn_count
    FROM transactions
    WHERE success_flag = 1
    GROUP BY user_id
),

support_flags AS (
    SELECT user_id, 
            MAX(CASE 
                    WHEN issue_type IN ('Refund Request', 'Downgrade Dispute') THEN 1 
                    ELSE 0 
                END) AS support_issue_flag
    FROM support_tickets
    GROUP BY user_id
)

SELECT 
    u.user_id,
    u.signup_date,
    COALESCE(l.last_login, NULL) AS last_login,
    COALESCE(t.txn_count, 0) AS txn_count,
    COALESCE(s.support_issue_flag, 0) AS support_issue_flag,

    CASE
        WHEN 
            (DATEDIFF(CURDATE(), COALESCE(l.last_login, u.signup_date)) > 30 AND COALESCE(t.txn_count, 0) < 3)
            OR COALESCE(s.support_issue_flag, 0) = 1
        THEN 1 ELSE 0
    END AS churned

FROM users u
LEFT JOIN last_login l ON u.user_id = l.user_id
LEFT JOIN txn_summary t ON u.user_id = t.user_id
LEFT JOIN support_flags s ON u.user_id = s.user_id
ORDER BY churned DESC, u.user_id;


-- CHURN RATE SUMMARY

SELECT 
    COUNT(*) AS total_users,
    SUM(churned) AS churned_users,
    ROUND(SUM(churned) / COUNT(*) * 100, 2) AS churn_rate_percent
FROM (
    SELECT 
        u.user_id,
        u.signup_date,
        COALESCE(l.last_login, NULL) AS last_login,
        COALESCE(t.txn_count, 0) AS txn_count,
        COALESCE(s.support_issue_flag, 0) AS support_issue_flag,
        CASE
            WHEN (DATEDIFF(CURDATE(), COALESCE(l.last_login, u.signup_date)) > 30 AND COALESCE(t.txn_count, 0) < 3)
                 OR COALESCE(s.support_issue_flag, 0) = 1
            THEN 1 ELSE 0
        END AS churned
    FROM users u
    LEFT JOIN (
        SELECT user_id, MAX(login_date) AS last_login
        FROM logins
        GROUP BY user_id
    ) l ON u.user_id = l.user_id
    LEFT JOIN (
        SELECT user_id, COUNT(*) AS txn_count
        FROM transactions
        WHERE success_flag = 1
        GROUP BY user_id
    ) t ON u.user_id = t.user_id
    LEFT JOIN (
        SELECT user_id,
               MAX(CASE WHEN issue_type IN ('Refund Request', 'Downgrade Dispute') THEN 1 ELSE 0 END) AS support_issue_flag
        FROM support_tickets
        GROUP BY user_id
    ) s ON u.user_id = s.user_id
) churn_data;


-- CHURN BY PLAN TYPE

SELECT u.plan_type,
       COUNT(*) AS total_users,
       SUM(churned) AS churned_users,
       ROUND(SUM(churned)/COUNT(*)*100, 1) AS churn_rate_percent
FROM (
    SELECT 
        u.user_id,
        u.plan_type,
        CASE
            WHEN (DATEDIFF(CURDATE(), COALESCE(l.last_login, u.signup_date)) > 30 AND COALESCE(t.txn_count, 0) < 3)
                 OR COALESCE(s.support_issue_flag, 0) = 1
            THEN 1 ELSE 0
        END AS churned
    FROM users u
    LEFT JOIN (
        SELECT user_id, MAX(login_date) AS last_login
        FROM logins
        GROUP BY user_id
    ) l ON u.user_id = l.user_id
    LEFT JOIN (
        SELECT user_id, COUNT(*) AS txn_count
        FROM transactions
        WHERE success_flag = 1
        GROUP BY user_id
    ) t ON u.user_id = t.user_id
    LEFT JOIN (
        SELECT user_id,
               MAX(CASE WHEN issue_type IN ('Refund Request', 'Downgrade Dispute') THEN 1 ELSE 0 END) AS support_issue_flag
        FROM support_tickets
        GROUP BY user_id
    ) s ON u.user_id = s.user_id
) u
GROUP BY u.plan_type
ORDER BY churn_rate_percent DESC;


-- 🔍 CHURN BY AGE GROUP

SELECT age_group,
       COUNT(*) AS total_users,
       SUM(churned) AS churned_users,
       ROUND(SUM(churned) / COUNT(*) * 100, 1) AS churn_rate_percent
FROM (
    SELECT 
        u.user_id,
        CASE 
            WHEN u.age < 25 THEN '1. Under 25'
            WHEN u.age BETWEEN 25 AND 34 THEN '2. 25-34'
            WHEN u.age BETWEEN 35 AND 44 THEN '3. 35-44'
            WHEN u.age BETWEEN 45 AND 54 THEN '4. 45-54'
            ELSE '5. 55+' 
        END AS age_group,
        CASE
            WHEN (DATEDIFF(CURDATE(), COALESCE(l.last_login, u.signup_date)) > 30 AND COALESCE(t.txn_count, 0) < 3)
                 OR COALESCE(s.support_issue_flag, 0) = 1
            THEN 1 ELSE 0
        END AS churned
    FROM users u
    LEFT JOIN (
        SELECT user_id, MAX(login_date) AS last_login
        FROM logins
        GROUP BY user_id
    ) l ON u.user_id = l.user_id
    LEFT JOIN (
        SELECT user_id, COUNT(*) AS txn_count
        FROM transactions
        WHERE success_flag = 1
        GROUP BY user_id
    ) t ON u.user_id = t.user_id
    LEFT JOIN (
        SELECT user_id,
               MAX(CASE WHEN issue_type IN ('Refund Request', 'Downgrade Dispute') THEN 1 ELSE 0 END) AS support_issue_flag
        FROM support_tickets
        GROUP BY user_id
    ) s ON u.user_id = s.user_id
) age_churn_data
GROUP BY age_group
ORDER BY age_group ASC;