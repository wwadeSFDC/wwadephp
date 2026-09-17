PHP_OTPService.OTPRequest req = new PHP_OTPService.OTPRequest();
req.action = 'GENERATE';
req.accountId = new Account(Id = '001VW00000afWtOYAU');
List<PHP_OTPService.OTPResult> results = PHP_OTPService.execute(new List<PHP_OTPService.OTPRequest>{ req });
System.debug('RESULT: ' + JSON.serialize(results[0]));
