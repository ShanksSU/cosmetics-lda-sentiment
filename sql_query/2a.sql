WITH popularity_quartiles AS (
    SELECT
        `商品ID`,
				`品牌ID`,
        `商品人氣`,
        `上市日期`,
        NTILE(4) OVER (ORDER BY `商品人氣` ASC) as quartile -- (1低人氣 - 4高人氣)
    FROM `商品資訊`
    WHERE 
        `上市日期` >= '2020-01-01'
        AND `商品屬性` IN (
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
),

TargetProducts AS (
    SELECT `商品ID`, `品牌ID`, `商品人氣`
    FROM popularity_quartiles
    WHERE quartile = 4
),

AllComments AS (
    SELECT '開架' as `評論類型`, t.* FROM `評論_開架` t
    UNION ALL
    SELECT '專櫃' as `評論類型`, t.* FROM `評論_專櫃` t
    UNION ALL
    SELECT '專賣店' as `評論類型`, t.* FROM `評論_專賣店` t
    UNION ALL
    SELECT '其他' as `評論類型`, t.* FROM `評論_其他` t
    UNION ALL
    SELECT '網路' as `評論類型`, t.* FROM `評論_網路` t
    UNION ALL
    SELECT '醫療通路' as `評論類型`, t.* FROM `評論_醫療通路` t
)

SELECT 
    p.`商品人氣`,
    c.`評論類型`,
    c.* FROM AllComments c
INNER JOIN TargetProducts p ON c.`商品ID` = p.`商品ID`;