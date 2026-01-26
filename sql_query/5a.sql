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
        NTILE(4) OVER (
            ORDER BY r.`推數` ASC
        ) as quartile_bucket
    FROM AllComments r
    INNER JOIN `商品資訊` p ON r.`商品ID` = p.`商品ID`
    WHERE r.`商品屬性` IN (
        '唇膏', '唇筆', '唇線筆', '唇蜜', '唇釉', '唇露', '其他唇彩',
        '眼線筆', '眼線液', '眼線膠', '其他眼線',
        '眼影盤', '眼影膏', '眼影筆', '眼影蜜', '其他眼影',
        '睫毛膏', '睫毛底膏', '睫毛定型',
        '腮紅', '腮紅霜', '腮紅蜜', '氣墊腮紅', '其它腮紅',
        '修容棒', '修容餅', '其它修容',
        '粉底液', '粉餅', '粉霜', '氣墊粉餅', 'BB霜', 'CC霜', '其它粉底',
        '遮瑕膏', '遮瑕筆', '眼部遮瑕', '其它遮瑕',
        '蜜粉', '蜜粉餅', '其它定妝'
    )
)

SELECT *
FROM FilteredData
WHERE quartile_bucket = 4
ORDER BY `推數` DESC, `評論類型`;