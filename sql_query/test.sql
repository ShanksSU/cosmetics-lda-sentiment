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
FilteredData AS (
    SELECT 
        r.*, 
        p.`品牌ID`,
        PERCENT_RANK() OVER (ORDER BY r.`人氣` ASC) as pct_rank
    FROM AllComments r
    INNER JOIN `商品資訊` p ON r.`商品ID` = p.`商品ID`
    WHERE r.`商品屬性` IN ('洗髮乳')
)

SELECT *
FROM FilteredData
WHERE pct_rank >= 0.75
ORDER BY `人氣` DESC, `評論類型`;