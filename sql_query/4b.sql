WITH AllComments AS (
    -- 符合條件 A：合併所有通路
    -- 符合條件 B：發表時間 >= 2020/1/1
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
    -- 符合條件 C：篩選彩妝屬性
    SELECT 
        r.*, 
        p.`品牌ID`,
        -- 計算百分比排名 (0 ~ 1)
        PERCENT_RANK() OVER (ORDER BY r.`人氣` ASC) as pct_rank
    FROM AllComments r
    INNER JOIN `商品資訊` p ON r.`商品ID` = p.`商品ID`
    WHERE r.`商品屬性` IN (
        '唇膏', '唇筆', '唇線筆', '唇蜜', '唇釉', '唇露', '其它唇彩',
        '眼線筆', '眼線液', '眼線膠', '其他眼線',
        '眼影盤', '眼影膏', '眼影筆', '眼影蜜', '其它眼影',
        '睫毛膏', '睫毛底膏', '睫毛定型',
        '腮紅', '腮紅霜', '腮紅蜜', '氣墊腮紅', '其它腮紅',
        '修容棒', '修容餅', '其它修容',
        '粉底液', '粉餅', '粉霜', '氣墊粉餅', 'BB霜', 'CC霜', '其它粉底',
        '遮瑕膏', '遮瑕筆', '眼部遮瑕', '其它遮瑕',
        '蜜粉', '蜜粉餅', '其它定妝'
    )
)


-- 符合條件 D：取出 <= 第一四分位數 (即排名後 75% 的資料)
SELECT *
FROM FilteredData
WHERE pct_rank <= 0.25
ORDER BY `人氣` DESC, `評論類型`;