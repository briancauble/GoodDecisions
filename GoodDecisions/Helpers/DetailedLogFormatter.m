//
//  DetailedLogFormatter.m
//  GoodDecisions
//
//  Created by Abigail Fritz on 3/7/15.
//  Copyright (c) 2015 Brian Cauble. All rights reserved.
//

#import "DetailedLogFormatter.h"

@implementation DetailedLogFormatter

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    NSString *logLevel;
    switch (logMessage->_flag) {
        case DDLogFlagError     : logLevel = @"ERROR"; break;
        case DDLogFlagWarning   : logLevel = @"WARNING"; break;
        case DDLogFlagInfo      : logLevel = @"INFO"; break;
        case DDLogFlagDebug     : logLevel = @"DEBUG"; break;
        default                 : logLevel = @""; break;
    }
    
    return [NSString stringWithFormat:@"%@ %@ | %@:%@ | %@\n", logMessage->_timestamp, logLevel, logMessage->_function, @(logMessage->_line), logMessage->_message];
}

@end