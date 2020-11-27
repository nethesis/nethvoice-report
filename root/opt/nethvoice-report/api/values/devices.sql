SELECT Concat(Coalesce(vendor, ""), ",", Coalesce(model, ""), ",", 
              Coalesce(extension, ""), ",", Coalesce(type, "")) 
FROM   asterisk.rest_devices_phones 
WHERE  extension IS NOT NULL; 
