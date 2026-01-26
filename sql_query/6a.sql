WITH TopAuthors AS (
    -- 找出推數位於前 25% 的高潛力作者 ID
    SELECT `使用者ID`
    FROM (
        SELECT 
            `使用者ID`,
            NTILE(4) OVER (ORDER BY `推數` ASC) as quartile_bucket
        FROM `使用者`
        WHERE `推數` IS NOT NULL
    ) ranked
    WHERE quartile_bucket = 4
),
AllReviews AS (
    SELECT 
        '開架' as `評論類型`,
        t.`推數` as `評論推數`,
        t.* FROM `評論_開架` t
    WHERE t.`發表日期` >= '2020.01.01'
    
    UNION ALL
    
    SELECT 
        '專櫃' as `評論類型`,
        t.`推數` as `評論推數`,
        t.* FROM `評論_專櫃` t
    WHERE t.`發表日期` >= '2020.01.01'
		
		UNION ALL
    
    SELECT 
        '專賣店' as `評論類型`,
        t.`推數` as `評論推數`,
        t.* FROM `評論_專賣店` t
    WHERE t.`發表日期` >= '2020.01.01'
		
		UNION ALL
    
    SELECT 
        '其他' as `評論類型`,
        t.`推數` as `評論推數`,
        t.* FROM `評論_其他` t
    WHERE t.`發表日期` >= '2020.01.01'
		
		UNION ALL
    
    SELECT 
        '網路' as `評論類型`,
        t.`推數` as `評論推數`,
        t.* FROM `評論_網路` t
    WHERE t.`發表日期` >= '2020.01.01'

		UNION ALL

		SELECT 
        '醫療通路' as `評論類型`,
        t.`推數` as `評論推數`,
        t.* FROM `評論_醫療通路` t
    WHERE t.`發表日期` >= '2020.01.01'
)
-- 關聯高推數作者與商品資訊
SELECT 
    r.*
FROM AllReviews r
INNER JOIN TopAuthors u ON r.`使用者ID` = u.`使用者ID`  -- 只保留高推數作者的評論
INNER JOIN `商品資訊` p ON r.`商品ID` = p.`商品ID`
WHERE p.`商品屬性` IN (
    '唇膏', '唇筆', '唇線筆', '唇蜜', '唇軸', '唇露', '其他唇彩',
    '眼線筆', '眼線液', '眼線膠', '其他眼線',
    '眼影盤', '眼影膏', '眼影筆', '眼影密', '其他眼影',
    '睫毛膏', '睫毛底膏', '睫毛定型',
    '腮紅', '腮紅霜', '腮紅蜜', '氣墊腮紅', '其它腮紅',
    '修容棒', '修容餅', '其它修容',
    '粉底液', '粉餅', '粉霜', '氣墊粉餅', 'BB霜', 'CC霜', '其它粉底',
    '遮瑕膏', '遮瑕筆', '眼部遮瑕', '其它遮瑕',
    '蜜粉', '蜜粉餅', '其它定妝'
)
ORDER BY r.`評論推數` DESC, r.`評論類型`;