select 
    so.name, su.name, so.crdate 
from 
    sysobjects so 
join 
    sysusers su on so.uid = su.uid  
order by 
    so.crdate
