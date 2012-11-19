//
//  TwitterSocialStreamDataModel.m
//  SocialStreams
//
//  Created by ManishNaharMac on 27/08/12.
//
//

#import "TwitterSocialStreamDataModel.h"

@implementation TwitterSocialStreamDataModel

@synthesize createdTime;
@synthesize fromUserName;
@synthesize tweetText;
@synthesize mediaArray;


- (id) initWithDictionary:(NSDictionary *)dict {

    self = [super initWithDictionary:dict];
    
    if( self != nil ){
        [self setCreatedTime:[dict objectForKey:@"created_at"]];
        [self setFromUserName:[dict objectForKey:@"from_user"]];
        [self setTweetText:[dict objectForKey:@"text"]];
        [self setMediaArray:[[dict objectForKey:@"entities"] objectForKey:@"media"]];
        [self setLocationName:[dict objectForKey:@"location"]];
    }
    return self;
}

- (void) dealloc {

    [self.createdTime release];
    [self.fromUserName release];
    [self.tweetText release];
    [self.mediaArray release];
    
    [super dealloc];
}

- (NSString *)locationNameString {
    return [self locationName];
}

@end
