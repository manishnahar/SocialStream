//
//  YelpSocialStreamModel.m
//  SocialStreams
//
//  Created by ManishNaharMac on 31/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YelpSocialStreamModel.h"
#import "YelpSocialStreamDataModel.h"
#import "YelpSocialStreamDetailViewController.h"

@interface YelpSocialStreamModel()

- (void) getVenuesDidStart:(HttpConnectionHandler *)ch;
- (void) getVenuesDidFail:(HttpConnectionHandler *)ch;
- (void) getVenuesDidFinish:(HttpConnectionHandler *)ch;

@end


@implementation YelpSocialStreamModel


- (id) initWithCredentials:(NSDictionary *)credentials_ {
    self = [super initWithCredentials:credentials_];
    if( self != nil ){
        modelType = kYelpSocialStreamModel;
    }
    return self;
}

- (void)getSocialStreamDataWithLocation:(CLLocation *)location {
    if([self isSearchUsingLocation]) {
        [self changeLocation:location];
    } else if([self isValidPhoneNumber]) {
        NSString *strUrl = [NSString stringWithFormat:@"http://api.yelp.com/phone_search?phone=%@&ywsid=W-CrDKW7uzEUpDbTuJ0FyQ", [self phoneNumber]];
        
        NSURL *url = [NSURL URLWithString:strUrl];
        connectionHandler = [HttpConnectionHandler connectionForURL:url];
        [connectionHandler setTarget:self];
        [connectionHandler setStartSelector:@selector(getVenuesDidStart:)];
        [connectionHandler setFailSelector:@selector(getVenuesDidFail:)];
        [connectionHandler setFinishSelector:@selector(getVenuesDidFinish:)];
        
        [connectionHandler start];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Yelp" message:@"Please provide valid latitude and longitude or Yelp Phone Number to search data for Yelp." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}

- (void) changeLocation:(CLLocation *)location {
    [self setLocation:location];
    
    connectionHandler = nil;
    
    NSString *urlStr = [NSString stringWithFormat:@"http://api.yelp.com/business_review_search?lat=%f&long=%f&limit=20&ywsid=%@",location.coordinate.latitude,location.coordinate.longitude,@"W-CrDKW7uzEUpDbTuJ0FyQ"];
    NSURL *url = [NSURL URLWithString:urlStr];
    connectionHandler = [HttpConnectionHandler connectionForURL:url];
    [connectionHandler setTarget:self];
    [connectionHandler setStartSelector:@selector(getVenuesDidStart:)];
    [connectionHandler setFailSelector:@selector(getVenuesDidFail:)];
    [connectionHandler setFinishSelector:@selector(getVenuesDidFinish:)];
    
    [connectionHandler start];
}

- (SocialStreamDetailViewController *) detailViewControllerForDataModel:(SocialStreamDataModel *)ssdm {
    
    YelpSocialStreamDetailViewController *socialStreamDetailViewController =
    [[YelpSocialStreamDetailViewController alloc] initWithNibName:@"YelpSocialStreamDetailViewController"
                                                       bundle:[NSBundle mainBundle]];
    [socialStreamDetailViewController setSocialStreamDataModel:ssdm];
    return [socialStreamDetailViewController autorelease];
}

- (UITableViewCell *) tableViewCellForSocialStreamDataModel:(SocialStreamDataModel *)ssdm {
    [[NSBundle mainBundle] loadNibNamed:@"YelpSocialStreamTableViewCellCell"
                                  owner:self
                                options:nil];
    return streamDataModelTableViewCell;
}

- (BOOL) requiresUserAuthentication {
    return NO;
}

- (BOOL) isUserAuthenticated {
    return NO;
}

- (NSString *)name {
    return @"Yelp";
}

#pragma mark - Private
- (void) getVenuesDidStart:(HttpConnectionHandler *)notification {
    
}

- (void) getVenuesDidFail:(HttpConnectionHandler *)notification {
    NSLog(@"%@",[[notification httpConnectionError] localizedDescription]);
}

- (void) getVenuesDidFinish:(HttpConnectionHandler *)notification {
    NSError *error = nil;
    NSDictionary *parsedData =  [NSJSONSerialization JSONObjectWithData:[notification httpResponseData]
                                                                options:kNilOptions
                                                                  error:&error];
    
    NSMutableArray *recordsArray = [NSMutableArray array];
    if( error == nil ){
        
        NSArray *venues = [parsedData objectForKey:@"businesses"];
        if([venues count]) {
            
            NSMutableArray *filterdVenues = [NSMutableArray array];
            
            if([self isSearchUsingLocation]) {
                if([self venueName] != nil && [[self venueName] length]) {
                    for(NSDictionary *venue in venues) {
                        if([Utility compareInputLocationName:[venue objectForKey:@"name"] withSearchLocation:[self venueName]]) {
                            [filterdVenues addObject:venue];
                        }
                    }
                } else {
                    NSDictionary *closestVenue = [self getClosestLocationFromLocations:venues withRequestedLocation:[self location]];
                    [filterdVenues addObject:closestVenue];
                }
            } else {
                [filterdVenues addObjectsFromArray:venues];
            }
               
            for(NSDictionary *venue in filterdVenues) {
                YelpSocialStreamDataModel *yelpDataModel = [[YelpSocialStreamDataModel alloc] initWithDictionary:venue];
                [yelpDataModel setModelType:kYelpSocialStreamModel];
                [recordsArray addObject:yelpDataModel];
                [yelpDataModel release];
            }
            if([recordsArray count]) {
                [delegate socialStreamModelIsFinished:(NSArray *)recordsArray];
            }
        }
    }else {
        NSLog(@"%@",[error localizedDescription]);
    }
    connectionHandler = nil;
}

- (void)cancelRequest {
    [connectionHandler cancel];
}


- (BOOL)isValidPhoneNumber {
    NSString *replacedString = [[self phoneNumber] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return (replacedString != nil && [replacedString length] != 0);
}

- (BOOL)isSearchUsingLocation {
    return ([self isValidPhoneNumber] == NO && ([[self location] coordinate].latitude != 0.0 && [[self location] coordinate].longitude != 0.0));
}

- (void)dealloc {
    
    [super dealloc];
}

- (NSDictionary*)getClosestLocationFromLocations:(NSArray *)locationsArray withRequestedLocation:(CLLocation*)location_ {
    NSArray *sortedArray = [locationsArray sortedArrayUsingComparator:^NSComparisonResult(id loc1, id loc2) {
        CLLocation *location1 = [[[CLLocation alloc] initWithLatitude:[[loc1 objectForKey:@"latitude"] doubleValue]
                                                            longitude:[[loc1 objectForKey:@"longitude"] doubleValue]] autorelease];
        
        CLLocation *location2 = [[[CLLocation alloc] initWithLatitude:[[loc2 objectForKey:@"latitude"] doubleValue]
                                                            longitude:[[loc2 objectForKey:@"longitude"] doubleValue]] autorelease];
        
        NSNumber *distace1 = [NSNumber numberWithDouble:[location1 distanceFromLocation:location_]];
        NSNumber *distace2 = [NSNumber numberWithDouble:[location2 distanceFromLocation:location_]];
        
        return [distace1 compare:distace2];
    }];
    
    return [sortedArray objectAtIndex:0];
}

@end
