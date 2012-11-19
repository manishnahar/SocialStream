//
//  SocialStreamModel.h
//  SocialStreams
//
//  Created by ManishNaharMac on 17/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpConnectionHandler.h"
#import "SocialStreamDetailViewController.h"

@protocol SocialStreamModelProtocol;

@interface SocialStreamModel : NSObject {
    NSURL *baseURL;
    SocialStreamModelType modelType;
    HttpConnectionHandler *connectionHandler;
    BOOL useSocialServiceStreamModel;
    IBOutlet UITableViewCell *streamDataModelTableViewCell;
    id <SocialStreamModelProtocol> delegate;
}

@property (nonatomic, retain) CLLocation *location;
@property (nonatomic, retain) NSString *idFromAPI;
@property (nonatomic, retain) NSString *accessToken;
@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) NSString *secretKeyFromAPI;
@property (nonatomic, assign) id <SocialStreamModelProtocol> delegate;
@property (nonatomic, retain) NSString *hashTag;
@property (nonatomic, retain) NSString *phoneNumber;
@property (nonatomic, retain) NSString *venueName;


+ (SocialStreamModel *) instagramSocialStreamModelWithCredentials:(NSDictionary *)credentials_;
+ (SocialStreamModel *) fourSquareSocialModelWithCredentials:(NSDictionary *)credentials_;
+ (SocialStreamModel *) twitterSocialModelWithCredentials:(NSDictionary *)credentials_;
+ (SocialStreamModel *) yelpSocialModelWithCredentials:(NSDictionary *)credentials_;

- (id)initWithCredentials:(NSDictionary *)credentials_;
- (NSString *) name;

- (void) changeLocation:(CLLocation *)location;
- (SocialStreamDetailViewController *) detailViewControllerForDataModel:(SocialStreamDataModel *)ssdm;
- (UITableViewCell *) tableViewCellForSocialStreamDataModel:(SocialStreamDataModel *)ssdm;
- (CGFloat) tableViewCellHeightForSocialStreamDataModel:(SocialStreamDataModel *)ssdm;
- (void) refreshAll;
- (BOOL)isSearchUsingLocation;
- (void)getSocialStreamDataWithLocation:(CLLocation *)location;

- (BOOL) requiresUserAuthentication;
- (BOOL) isUserAuthenticated;
- (BOOL) hasUserAllowedToUseSocialServiceModel;
- (void) authenticate;

- (void)cancelRequest;

@end

@protocol SocialStreamModelProtocol

- (void)socialStreamModelIsFinished:(NSArray *)itemsArray_;

@end
