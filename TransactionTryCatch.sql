BEGIN TRY
	BEGIN TRAN
		$selected$
	COMMIT TRAN
	PRINT 'Transaction was committed.';
END TRY
BEGIN CATCH
	ROLLBACK TRAN
	PRINT 'Error: ' + ERROR_MESSAGE();
	PRINT 'Transaction was rolled back.';
END CATCH
