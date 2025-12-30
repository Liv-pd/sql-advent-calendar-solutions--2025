-- SQL Advent Calendar - Day 12
-- Title: North Pole Network Most Active Users
-- Difficulty: hard
--
-- Question:
-- The North Pole Network wants to see who's the most active in the holiday chat each day. Write a query to count how many messages each user sent, then find the most active user(s) each day. If multiple users tie for first place, return all of them.
--
-- The North Pole Network wants to see who's the most active in the holiday chat each day. Write a query to count how many messages each user sent, then find the most active user(s) each day. If multiple users tie for first place, return all of them.
--

-- Table Schema:
-- Table: npn_users
--   user_id: INT
--   user_name: VARCHAR
--
-- Table: npn_messages
--   message_id: INT
--   sender_id: INT
--   sent_at: TIMESTAMP
--

-- My Solution:

WITH daily_message_counts AS (
    SELECT m.sender_id, u.user_name, DATE(m.sent_at) AS message_date, COUNT(*) AS message_count
    FROM npn_messages as m JOIN npn_users as u ON m.sender_id = u.user_id
    GROUP BY m.sender_id, u.user_name, DATE(m.sent_at)),

  ranked_users AS (
    SELECT sender_id, user_name, message_date, message_count,
        RANK() OVER (PARTITION BY message_date ORDER BY message_count DESC) AS activity_rank
    FROM daily_message_counts)
  
SELECT message_date, sender_id, user_name, message_count
FROM ranked_users
WHERE activity_rank = 1
ORDER BY message_date, user_name;
