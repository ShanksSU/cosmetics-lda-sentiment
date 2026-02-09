WITH AllComments AS (
    SELECT '開架' as `評論類型`, t.* FROM `評論_開架` t WHERE t.`發表日期` >= '2020.01.01'
    UNION ALL
    SELECT '專櫃' as `評論類型`, t.* FROM `評論_專櫃` t WHERE t.`發表日期` >= '2020.01.01'
    UNION ALL
    SELECT '專賣店' as `評論類型`, t.* FROM `評論_專賣店` t WHERE t.`發表日期` >= '2020.01.01'
    UNION ALL
    SELECT '其他' as `評論類型`, t.* FROM `評論_其他` t WHERE t.`發表日期` >= '2020.01.01'
    UNION ALL
    SELECT '網路' as `評論類型`, t.* FROM `評論_網路` t WHERE t.`發表日期` >= '2020.01.01'
    UNION ALL
    SELECT '醫療通路' as `評論類型`, t.* FROM `評論_醫療通路` t WHERE t.`發表日期` >= '2020.01.01'
),
EnrichedData AS (
    SELECT 
        r.`評論ID`,
        r.`使用者ID`,
        r.`商品ID`,
        r.`評論` as text_content,
        r.`評分` as rating,
        r.`人氣` as popularity,
        r.`發表日期`,
        r.`是否為購入品` as is_purchased, --  重要特徵：購買 vs 試用
        p.`品牌ID`,
        p.`商品價格` as price, --  價格特徵
        u.`肌膚類型` as skin_type, --  使用者特徵
        u.`年齡` as user_age, -- 
        u.`心得總數` as user_review_count, --  權威度特徵
        DATEDIFF(NOW(), r.`發表日期`) as days_since_posted
    FROM AllComments r
    INNER JOIN `商品資訊` p ON r.`商品ID` = p.`商品ID`
    LEFT JOIN `使用者` u ON r.`使用者ID` = u.`使用者ID` -- 關聯使用者資料表 [cite: 1]
    WHERE r.`商品屬性` = '洗髮乳'
)

SELECT 
    *,
    -- 計算日均人氣以消除時間偏差
    (popularity / NULLIF(days_since_posted, 0)) as daily_popularity,
    -- 在「同一年份」內計算排名，避免 2020 年文章霸榜
    PERCENT_RANK() OVER (PARTITION BY YEAR(`發表日期`) ORDER BY popularity ASC) as pct_rank_by_year
FROM EnrichedData;