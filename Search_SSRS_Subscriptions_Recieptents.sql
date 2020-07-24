WITH subscriptionXmL
          AS (
               SELECT
                SubscriptionID ,
                OwnerID ,
                Report_OID ,
                Locale ,
                InactiveFlags ,
                ExtensionSettings ,
                CONVERT(XML, ExtensionSettings) AS ExtensionSettingsXML ,
                ModifiedByID ,
                ModifiedDate ,
                Description ,
                LastStatus ,
                EventType ,
                MatchData ,
                LastRunTime ,
                Parameters ,
                DeliveryExtension ,
                Version
               FROM
                ReportServer.dbo.Subscriptions
             ),
                 -- Get the settings as pairs
        SettingsCTE
          AS (
               SELECT
                SubscriptionID ,
                ExtensionSettings ,
    -- include other fields if you need them.
                ISNULL(Settings.value('(./*:Name/text())[1]', 'nvarchar(1024)'),
                       'Value') AS SettingName ,
                Settings.value('(./*:Value/text())[1]', 'nvarchar(max)') AS SettingValue
               FROM
                subscriptionXmL
                CROSS APPLY subscriptionXmL.ExtensionSettingsXML.nodes('//*:ParameterValue') Queries ( Settings )
             )
    SELECT
        *
    FROM
        SettingsCTE
    WHERE
        settingName IN ( 'TO', 'CC', 'BCC' )

		and upper(SettingValue) like '%NAME%' 