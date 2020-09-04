;WITH UpdateAll AS(
	SELECT A.KCBGL_ID, A.RankID,
	 RANK() OVER ( 
	    PARTITION BY A.BG_ID
		ORDER BY A.RankID
	) newRankID

  FROM [KP].[ITReq].[KanbanCardBGLink] A INNER JOIN
	   [KP].[ITReq].[KanbanCard] B ON A.KC_ID = B.KC_ID LEFT JOIN
	   [KP].[ITReq].[KanbanCardSprint] D ON B.KC_ID = D.KC_ID LEFT JOIN
	   [KP].[ITReq].[KanbanCardStatusLink] E ON D.KCS_ID = E.KCS_ID

	WHERE D.KS_ID = (SELECT MAX(D1.KS_ID) FROM [KP].[ITReq].[KanbanCardSprint] D1 WHERE D.KC_ID = D1.KC_ID )
	AND E.KCSt_ID <> 5
)
UPDATE UpdateAll
SET RankID = newRankID