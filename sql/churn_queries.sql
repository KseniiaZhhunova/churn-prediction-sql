-- Churn Definition (Business Logic)
--
-- A user is considered churned if:
-- 1. They have not logged in for 30+ days after signup
--    AND have made fewer than 3 successful transactions
-- OR
-- 2. They submitted a support ticket related to a refund or downgrade
--
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