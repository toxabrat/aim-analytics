/*
Вывести список пользователей, смотревших video_id 1 и 3 (посмотрел и видео 1, и видео 3),
но не смотревших видео 2.
таблицы: reports_stg.watch_content
 */
SELECT DISTINCT w.user_id
FROM reports_stg.watch_content w
GROUP BY w.user_id
HAVING count(*) FILTER (
        WHERE w.video_id = 1
    ) > 0
    AND count(*) FILTER (
        WHERE w.video_id = 2
    ) = 0
    AND count(*) FILTER (
        WHERE w.video_id = 3
    ) > 0
    