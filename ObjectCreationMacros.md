These should be mostly self explanatory.

### Example Usage ###
```
NSArray *items = NSARRAY(NSDICT(@"Hello World!", @"title",
                                [NSImage imageNamed:@"worldHello"], @"icon",
                                NSBOOL(YES), @"isAwesome"),
                         NSDICT(@"Good Bye, World!", @"title",
                                [NSImage imageNamed:@"winkyfrownyface"], @"icon",
                                NSBOOL(NO), @"isAwesome"));
```