//
//  SocialStreamModel.m
//  SocialStreams
//
//  Created by ManishNaharMac on 17/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "SocialStreamModel.h"
#import "InstagramSocialStreamModel.h"
#import "FoursquareSocialStreamModel.h"
#import "TwitterSocialStreamModel.h"
#import "YelpSocialStreamModel.h"


@implementation SocialStreamModel

@synthesize location;
@synthesize idFromAPI;
@synthesize accessToken;
@synthesize userId;
@synthesize secretKeyFromAPI;
@synthesize delegate;
@synthesize hashTag;
@synthesize phoneNumber;
@synthesize venueName;

-(id)initWithCredentials:(NSDictionary *)credentials_ {
    self = [super init];
    if( self != nil ){
        
    }
    return self;
}

+ (InstagramSocialStreamModel *) instagramSocialStreamModelWithCredentials:(NSDictionary *)credentials_ {
    InstagramSocialStreamModel *insgStreamModel = [[[InstagramSocialStreamModel alloc] initWithCredentials:credentials_] autorelease];
    return insgStreamModel;
}

+ (FoursquareSocialStreamModel *) fourSquareSocialModelWithCredentials:(NSDictionary *)credentials_ {
    return [[[FoursquareSocialStreamModel alloc] initWithCredentials:credentials_] autorelease];
}

+ (TwitterSocialStreamModel *) twitterSocialModelWithCredentials:(NSDictionary *)credentials_ {
    return [[[TwitterSocialStreamModel alloc] initWithCredentials:credentials_] autorelease];
}

+ (YelpSocialStreamModel *) yelpSocialModelWithCredentials:(NSDictionary *)credentials_ {
    return [[[YelpSocialStreamModel alloc] initWithCredentials:credentials_] autorelease];
}

- (void) changeLocation:(CLLocation *)location {
    [self doesNotRecognizeSelector:@selector(changeLocation:)];
}

- (void)getSocialStreamDataWithLocation:(CLLocation *)location {
    
}

- (SocialStreamDetailViewController *) detailViewControllerForDataModel:(SocialStreamDataModel *)ssdm {
    return nil;
}

- (UITableViewCell *) tableViewCellForSocialStreamDataModel:(SocialStreamDataModel *)ssdm {
    return nil;
}

- (CGFloat) tableViewCellHeightForSocialStreamDataModel:(SocialStreamDataModel *)ssdm {
    return 80.0f;
}

- (void) refreshAll {

}

- (BOOL) requiresUserAuthentication {
    return NO;
}

- (BOOL) isUserAuthenticated {
    return NO;
}

- (BOOL) hasUserAllowedToUseSocialServiceModel {
    return useSocialServiceStreamModel;
}

- (NSString *) name {
    return @"";
}

- (void) authenticate {
    
}

- (BOOL)isSearchUsingLocation {
    return YES;
}

- (void) dealloc {
    [super dealloc];
}

- (void)cancelRequest {
    [connectionHandler cancel];
}

@end
