//
//  Utility.m
//  SocialStreams
//
//  Created by ManishNaharMac on 04/09/12.
//
//

#import "Utility.h"

@implementation Utility

+ (NSString *)getFormatedDate:(NSString *)str {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:([str doubleValue])];
    NSString *formatedDate = [NSString stringWithFormat:@"%@", date];
    return formatedDate;
}

+ (NSString*)timeString:(NSString *)inputStr
{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    NSDate *date = [Utility dateFromUnix:[NSNumber numberWithDouble:[inputStr doubleValue]]];
	dateFormatter.dateFormat = @"eee, dd MMM yyyy h:mm a";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    return [dateFormatter stringFromDate:date];
}

+ (NSDate *) dateFromUnix:(NSNumber *)number {
    return [NSDate dateWithTimeIntervalSince1970:([number doubleValue])];
}

+ (NSNumber *) unixEpochFromDate:(NSDate *)date {
    return [NSNumber numberWithDouble:(floor([date timeIntervalSince1970]))];
}

+ (BOOL)compareInputLocationName:(NSString *)inputLocationName withSearchLocation:(NSString *)searchLocationName
{
    if(inputLocationName == nil || [inputLocationName length] == 0) {
        return YES;
    }
    
    NSArray *searchComponents = [searchLocationName componentsSeparatedByString:@" "];
    
    /*    BOOL found = NO;
     
     for(NSString *str in searchComponents) {
     if ([inputLocationName rangeOfString:str].location != NSNotFound) {
     found = YES;
     break;
     }
     }
     */
    __block NSString *result = nil;
    [searchComponents indexOfObjectWithOptions:NSEnumerationConcurrent
                                   passingTest:^(NSString *obj, NSUInteger idx, BOOL *stop)
     {
         if ([inputLocationName rangeOfString:obj options:NSCaseInsensitiveSearch].location != NSNotFound)
         {
             result = obj;
             *stop = YES;
         }
         return NO;
     }];
    
    return (result != nil);
}


@end
