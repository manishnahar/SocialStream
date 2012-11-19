//
//  TwitterSocialStreamModel.m
//  SocialStreams
//
//  Created by ManishNaharMac on 21/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TwitterSocialStreamModel.h"
#import "TwitterSocialStreamDataModel.h"
#import "TwitterSocialStreamDetailViewController.h"

@interface TwitterSocialStreamModel()

- (void) getLocationBasedTweetsDidStart:(HttpConnectionHandler *)ch;
- (void) getLocationBasedTweetsDidFail:(HttpConnectionHandler *)ch;
- (void) getLocationBasedTweetsDidFinish:(HttpConnectionHandler *)ch;

@end

@implementation TwitterSocialStreamModel

- (void)dealloc {
    
    [super dealloc];
}

- (id) initWithCredentials:(NSDictionary *)credentials_ {
    self = [super initWithCredentials:credentials_];
    if( self != nil ){
        modelType = kTwitterSocialStreamModel;
    }
    return self;
}

- (void)getSocialStreamDataWithLocation:(CLLocation *)location {
    if([self isSearchUsingLocation]) {
        [self changeLocation:location];
    } else if ([self isValidHashTag]) {
        NSString *strUrl = [NSString stringWithFormat:@"http://search.twitter.com/search.json?q=%@&include_entities=true&result_type=recent",self.hashTag];
        
        NSURL *url = [NSURL URLWithString:strUrl];
        connectionHandler = [HttpConnectionHandler connectionForURL:url];
        [connectionHandler setTarget:self];
        [connectionHandler setStartSelector:@selector(getLocationBasedTweetsDidStart:)];
        [connectionHandler setFailSelector:@selector(getLocationBasedTweetsDidFail:)];
        [connectionHandler setFinishSelector:@selector(getLocationBasedTweetsDidFinish:)];
        [connectionHandler setRequestMethod:kGET];
        [connectionHandler start];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Twitter" message:@"Please provide valid latitude and longitude or Twitter Hash to search data for Twitter." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}

- (void) changeLocation:(CLLocation *)location {
 
    //[connectionHandler cancel];
    connectionHandler = nil;
    
    //NSString *strURL = [NSString stringWithFormat:@"http://api.twitter.com/1/geo/search.json?lat=%f&long=%f",location.coordinate.latitude,location.coordinate.longitude];

    if(self.hashTag == nil) {
        self.hashTag = @"";
    }
    
    //NSString *strURL = [NSString stringWithFormat:@"http://search.twitter.com/search.json?q=%@&include_entities=true&geocode=%f,%f,15mi&result_type=recent",self.hashTag, location.coordinate.latitude,location.coordinate.longitude];

    NSString *strURL = [NSString stringWithFormat:@"http://search.twitter.com/search.json?include_entities=true&geocode=%f,%f,15mi&result_type=mixed&include_my_retweet=true",location.coordinate.latitude,location.coordinate.longitude];

    //NSString *strURL = @"https://api.twitter.com/1/statuses/show.json?id=241422243186499584&include_entities=true";

    NSURL *url = [NSURL URLWithString:strURL];
    connectionHandler = [HttpConnectionHandler connectionForURL:url];
    [connectionHandler setTarget:self];
    [connectionHandler setStartSelector:@selector(getLocationBasedTweetsDidStart:)];
    [connectionHandler setFailSelector:@selector(getLocationBasedTweetsDidFail:)];
    [connectionHandler setFinishSelector:@selector(getLocationBasedTweetsDidFinish:)];
    [connectionHandler setRequestMethod:kGET];
    [connectionHandler start];
}

- (SocialStreamDetailViewController *) detailViewControllerForDataModel:(SocialStreamDataModel *)ssdm {
    TwitterSocialStreamDetailViewController *socialStreamDetailViewController =
    [[TwitterSocialStreamDetailViewController alloc] initWithNibName:@"TwitterSocialStreamDetailViewController"
                                                                bundle:[NSBundle mainBundle]];
    [socialStreamDetailViewController setSocialStreamDataModel:ssdm];
    return [socialStreamDetailViewController autorelease];
}

- (UITableViewCell *) tableViewCellForSocialStreamDataModel:(SocialStreamDataModel *)ssdm {
    [[NSBundle mainBundle] loadNibNamed:@"TwitterSocialStreamTableViewCell"
                                  owner:self
                                options:nil];
    return streamDataModelTableViewCell;
}

- (CGFloat) tableViewCellHeightForSocialStreamDataModel:(TwitterSocialStreamDataModel *)ssdm {
    CGSize maximumLabelSize = CGSizeMake( 320.0f, MAXFLOAT);
    CGSize expectedLabelSize = [ssdm.tweetText sizeWithFont:[UIFont systemFontOfSize:[UIFont labelFontSize]]
                                          constrainedToSize:maximumLabelSize 
                                              lineBreakMode:UILineBreakModeWordWrap];
    return expectedLabelSize.height + 40.0f;
}

- (BOOL) requiresUserAuthentication {
    return NO;
}

- (BOOL) isUserAuthenticated {
    return NO;
}

- (NSString *)name {
    return @"Twitter";
}

- (void) authenticate {

}

- (void) getLocationBasedTweetsDidStart:(HttpConnectionHandler *)ch {
    
}

- (void) getLocationBasedTweetsDidFail:(HttpConnectionHandler *)ch {

}

- (void) getLocationBasedTweetsDidFinish:(HttpConnectionHandler *)ch {
    NSError *jsonError = nil;
    NSDictionary *timeline = [NSJSONSerialization JSONObjectWithData:[ch httpResponseData]
                                                        options:NSJSONReadingMutableLeaves 
                                                          error:&jsonError];
    if (timeline) {
        NSLog(@"%@", timeline);
        
        NSMutableArray *recordsArray = [NSMutableArray array];
        NSArray *results = [timeline objectForKey:@"results"];
        NSMutableArray *filterdArray = [NSMutableArray array];
        
        if([results count]) {
            
            if([self isSearchUsingLocation]) {
                if([self venueName] != nil && [[self venueName] length]) {
                    for(NSDictionary *result in results) {
                        if([Utility compareInputLocationName:[result objectForKey:@"location"] withSearchLocation:[self venueName]]) {
                            [filterdArray addObject:result];
                        }
                    }
                } else {
/*                    NSDictionary *cloesetVenue = [self getClosestLocationFromLocations:results withRequestedLocation:[self location]];
                    [filterdArray addObject:cloesetVenue];
 */
                    [filterdArray addObjectsFromArray:results];
                }
            } else {
                [filterdArray addObjectsFromArray:results];
            }
        }
        
        if([filterdArray count]) {
            for(NSDictionary *result in filterdArray) {
                TwitterSocialStreamDataModel *twitterData = [[TwitterSocialStreamDataModel alloc] initWithDictionary:result];
                [twitterData setModelType:kTwitterSocialStreamModel];
                [recordsArray addObject:twitterData];
                [twitterData release];
            }
        }
        
        if([recordsArray count]) {
            [self.delegate socialStreamModelIsFinished:(NSArray *) recordsArray];
        }
    }
    else {
        NSLog(@"%@", jsonError);
    }
}

- (void)cancelRequest {
    [connectionHandler cancel];
}

- (BOOL)isValidHashTag {
    NSString *replacedString = [[self hashTag] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return (replacedString != nil && [replacedString length] != 0);
}

- (BOOL)isSearchUsingLocation {
    return ([self isValidHashTag] == NO && ([[self location] coordinate].latitude != 0.0 && [[self location] coordinate].longitude != 0.0));
}

- (NSDictionary*)getClosestLocationFromLocations:(NSArray *)locationsArray withRequestedLocation:(CLLocation*)location_ {
    
    NSArray *sortedVenues = [locationsArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDictionary *locationDict1 = [(NSDictionary *)obj1 objectForKey:@"location"];
        NSDictionary *locationDict2 = [(NSDictionary *)obj2 objectForKey:@"location"];
        
        CLLocation *location1 = [[CLLocation alloc] initWithLatitude:[[locationDict1 objectForKey:@"lat"] doubleValue]
                                                           longitude:[[locationDict1 objectForKey:@"lng"] doubleValue]];
        
        CLLocation *location2 = [[CLLocation alloc] initWithLatitude:[[locationDict2 objectForKey:@"lat"] doubleValue]
                                                           longitude:[[locationDict2 objectForKey:@"lng"] doubleValue]];
        
        NSNumber *distance_location1 = [NSNumber numberWithDouble:[location1 distanceFromLocation:self.location]];
        NSNumber *distance_location2 = [NSNumber numberWithDouble:[location2 distanceFromLocation:self.location]];
        
        return [distance_location1 compare:distance_location2];
    }];
    
    return [sortedVenues objectAtIndex:0];
}
@end

//    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
//    [params setObject:[NSString stringWithFormat:@"%f",location.coordinate.latitude] forKey:@"lat"];
//    [params setObject:[NSString stringWithFormat:@"%f",location.coordinate.longitude] forKey:@"long"];
//    

//    
//    TWRequest *request = [[TWRequest alloc] initWithURL:url 
//                                             parameters:params 
//                                          requestMethod:TWRequestMethodGET];

//----Not required to authenticate----
//    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
//    ACAccountType *accountTypeTwitter = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
//    [accountStore requestAccessToAccountsWithType:accountTypeTwitter withCompletionHandler:^(BOOL granted, NSError *error) {
//        if(granted) {
//            NSArray *accounts = [accountStore accountsWithAccountType:accountTypeTwitter];
//            if( [accounts count] != 0 ){
//                dispatch_sync(dispatch_get_main_queue(), ^{
//                    DPLog(@"Authenticated");
//                });
//            }
//        }
//    }];
