-- search the jobs for a specific text

SELECT SERVERPROPERTY('SERVERNAME') as [InstanceName],

    j.job_id,

    j.name,

    js.step_id,

    js.command,

    j.enabled

FROM    msdb.dbo.sysjobs j

JOIN    msdb.dbo.sysjobsteps js

    ON  js.job_id = j.job_id

WHERE   upper(js.command) LIKE '%SEARCH TERM%' -- replace keyword with the word or stored proc that you are searching for

GO

