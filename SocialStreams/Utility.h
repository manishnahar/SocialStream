//
//  Utility.h
//  SocialStreams
//
//  Created by ManishNaharMac on 04/09/12.
//
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

+ (NSString *)getFormatedDate:(NSString *)str_;
+ (NSString*)timeString:(NSString *)inputStr;
+ (BOOL)compareInputLocationName:(NSString *)inputLocationName withSearchLocation:(NSString *)searchLocationName;

@end
