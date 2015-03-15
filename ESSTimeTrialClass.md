# ESSTimeTrialClass - easily implement a time limit into your app #

This will terminate the application once a certain date has been reached (or terminate the app immediately if the date has been passed before starting the app).

## timeTrialWithEndDate:endMessage: ##
```
+ (ESSTimeTrialClass *)timeTrialWithEndDate:(NSDate *)aDate endMessage:(NSString *)string;
```

Will return an ESSTimeTrialClass object, starting a timer with the endDate.

## initWithEndDate:endMessage: ##
```
- (id)initWithEndDate:(NSDate *)aDate endMessage:(NSString *)string;
```

Will return an ESSTimeTrialClass object and will start a timer with the endDate.

## setEndDate: ##
```
- (void)setEndDate:(NSDate *)aDate;
```

When "init"ed normally, use this to set an enddate. No timer is started (see startTimer/endTimer).

## setEndMessage: ##
```
- (void)setEndMessage:(NSString *)string;
```

When "init"ed normally, use this to set an endmessage.

## startTimer ##
```
- (void)startTimer;
```

When "init"ed normally, use this to start the timer after you set the endDate (setEndDate:) and endMessage (setEndMessage:).

## endTimer ##
```
- (void)endTimer;
```

Use this to stop the timer (maybe useful when the user wants to register with a serial or something)