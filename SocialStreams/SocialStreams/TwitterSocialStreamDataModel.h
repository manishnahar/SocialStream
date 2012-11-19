//
//  TwitterSocialStreamDataModel.h
//  SocialStreams
//
//  Created by ManishNaharMac on 27/08/12.
//
//

#import <Foundation/Foundation.h>
#import "SocialStreamDataModel.h"

@interface TwitterSocialStreamDataModel : SocialStreamDataModel

@property (nonatomic, retain) NSString *createdTime;
@property (nonatomic, retain) NSString *fromUserName;
@property (nonatomic, retain) NSString *tweetText;
@property (nonatomic, retain) NSArray *mediaArray;

@end
