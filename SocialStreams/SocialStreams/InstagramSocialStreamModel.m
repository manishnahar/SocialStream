//
//  InstagramSocialStreamModel.m
//  SocialStreams
//
//  Created by ManishNaharMac on 17/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InstagramSocialStreamModel.h"
#import "InstaGramSocialStreamDataModel.h"
#import "InstagramSocialStreamDetailViewController.h"

@interface InstagramSocialStreamModel()

- (void)getLocationsNotificationDidFail:(HttpConnectionHandler *)notification;
- (void)getLocationsNotificationDidStart:(HttpConnectionHandler *)notification;
- (void)getLocationsNotificationDidFinish:(HttpConnectionHandler *)notification;
- (void)getUserMediaForLocationId:(NSString *)locationId_;
- (void)getUserMediaForLocationNotificationDidFail:(HttpConnectionHandler *)notification;
- (void)getUserMediaForLocationNotificationDidStart:(HttpConnectionHandler *)notification;
- (void)getUserMediaForLocationNotificationDidFinish:(HttpConnectionHandler *)notification;

@end

@implementation InstagramSocialStreamModel

#define kInstagramBaseURLString     @"https://api.instagram.com/v1/"
#define kLocationsEndpoint          @"locations/search"
#define kUserMediaRecentEndpoint    @"users/%@/media/recent"
#define kLocationsMediaEndpoint     @"locations/%@/media/recent"

-(id)initWithCredentials:(NSDictionary *)credentials_ {
    if(self = [super init]) {
        modelType = kInstagramSocialStreamModel;
        [self setUserId:[credentials_ objectForKey:@"User_Id"]];
        [self setIdFromAPI:[credentials_ objectForKey:@"Client_Id"]];
    }
    
    return self;
}

- (void)getSocialStreamDataWithLocation:(CLLocation *)location {
        
    if([self isSearchUsingLocation]) {
        [self changeLocation:location];
    } else if([self isValidHashTag]) {
        NSString *strUrl = [NSString stringWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent?client_id=%@", [self hashTag], [self idFromAPI]];
        
        HttpConnectionHandler* connectionHandler1 = [HttpConnectionHandler connectionForURL:[NSURL URLWithString:strUrl]];
        
        [connectionHandler1 setTarget:self];
        [connectionHandler1 setFailSelector:@selector(getUserMediaForLocationNotificationDidFail:)];
        [connectionHandler1 setStartSelector:@selector(getUserMediaForLocationNotificationDidStart:)];
        [connectionHandler1 setFinishSelector:@selector(getUserMediaForLocationNotificationDidFinish:)];
        [connectionHandler1 setRequestMethod:kGET];
        [connectionHandler1 start];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"InstaGram" message:@"Please provide valid latitude and longitude or InstaGram Hash to search data for InstaGram." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}

- (void) changeLocation:(CLLocation *)location {       
    //NSString *strUrl = [NSString stringWithFormat:@"https://api.instagram.com/v1/locations/search?distance=1000&lat=%f&lng=%f&client_id=%@",location.coordinate.latitude,location.coordinate.longitude,[self idFromAPI]];
    [self setLocation:location];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@?distance=1000&lat=%f&lng=%f&client_id=%@", kInstagramBaseURLString, kLocationsEndpoint, location.coordinate.latitude,location.coordinate.longitude, [self idFromAPI]];

    //[connectionHandler cancel];
    connectionHandler = nil;

    connectionHandler = [HttpConnectionHandler connectionForURL:[NSURL URLWithString:strUrl]];        
    [connectionHandler setTarget:self];
    [connectionHandler setFailSelector:@selector(getLocationsNotificationDidFail:)];
    [connectionHandler setStartSelector:@selector(getLocationsNotificationDidStart:)];
    [connectionHandler setFinishSelector:@selector(getLocationsNotificationDidFinish:)];
    [connectionHandler setRequestMethod:kGET];
    [connectionHandler start];
}

- (SocialStreamDetailViewController *) detailViewControllerForDataModel:(SocialStreamDataModel *)ssdm {
    InstagramSocialStreamDetailViewController *socialStreamDetailViewController =
    [[InstagramSocialStreamDetailViewController alloc] initWithNibName:@"InstagramSocialStreamDetailViewController"
                                                       bundle:[NSBundle mainBundle]];
    [socialStreamDetailViewController setSocialStreamDataModel:ssdm];
    return [socialStreamDetailViewController autorelease];
}

- (UITableViewCell *) tableViewCellForSocialStreamDataModel:(SocialStreamDataModel *)ssdm {
    [[NSBundle mainBundle] loadNibNamed:@"SocialStreamTableViewCell"
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
    return @"Instagram";
}

#pragma mark - Private
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

- (void)getLocationsNotificationDidFail:(HttpConnectionHandler *)notification {
    NSLog(@"%@",[[notification httpConnectionError] localizedDescription]);
}

- (void)getLocationsNotificationDidStart:(HttpConnectionHandler *)notification {
    
}

- (void)getLocationsNotificationDidFinish:(HttpConnectionHandler *)notification {
    NSError *error = nil;
    NSDictionary *parsedData =  [NSJSONSerialization JSONObjectWithData:[notification httpResponseData]
                                                                options:kNilOptions
                                                                  error:&error];
    
    NSArray *locationsArray = [parsedData objectForKey:@"data"];
    
    if([locationsArray count]) {
        if([self isSearchUsingLocation]) {
            if([self venueName] != nil && [[self venueName] length]) {
                for(NSDictionary *location_ in locationsArray) {
                    if([Utility compareInputLocationName:[location_ objectForKey:@"name"] withSearchLocation:[self venueName]]) {
                        [self getUserMediaForLocationId:[location_ objectForKey:@"id"]];
                    }
                }
            } else {
                NSDictionary *closestLocation = [self getClosestLocationFromLocations:locationsArray
                                                                withRequestedLocation:self.location];
                [self getUserMediaForLocationId:[closestLocation objectForKey:@"id"]];
            }
        } else {
            for(NSDictionary *location_ in locationsArray) {
                [self getUserMediaForLocationId:[location_ objectForKey:@"id"]];
            }
        }
    }
    
    if( error == nil ){
    }
    else {
        NSLog(@"%@",[error localizedDescription]);
    }
}


- (void)getUserMediaForLocationId:(NSString *)locationId_ {
    NSString *endPointPath = [NSString stringWithFormat:kLocationsMediaEndpoint, locationId_];
   NSString *strUrl = [NSString stringWithFormat:@"%@%@?client_id=%@", kInstagramBaseURLString, endPointPath, [self idFromAPI]];

//    NSString *strUrl = [NSString stringWithFormat:@"https://api.instagram.com/v1/media/257757562478411977?client_id=%@", [self idFromAPI]];

//    NSString *strUrl = [NSString stringWithFormat:@"https://api.instagram.com/v1/media/search?lat=38.900251&lng=-77.035961&client_id=%@", [self idFromAPI]];

    HttpConnectionHandler* connectionHandler1 = [HttpConnectionHandler connectionForURL:[NSURL URLWithString:strUrl]];
    
    [connectionHandler1 setTarget:self];
    [connectionHandler1 setFailSelector:@selector(getUserMediaForLocationNotificationDidFail:)];
    [connectionHandler1 setStartSelector:@selector(getUserMediaForLocationNotificationDidStart:)];
    [connectionHandler1 setFinishSelector:@selector(getUserMediaForLocationNotificationDidFinish:)];
    [connectionHandler1 setRequestMethod:kGET];
    [connectionHandler1 start];
}


- (void)getUserMediaForLocationNotificationDidFail:(HttpConnectionHandler *)notification {
    NSLog(@"%@",[[notification httpConnectionError] localizedDescription]);
}

- (void)getUserMediaForLocationNotificationDidStart:(HttpConnectionHandler *)notification {
    
}

- (void)getUserMediaForLocationNotificationDidFinish:(HttpConnectionHandler *)notification {
    NSError *error = nil;
    
    NSDictionary *parsedData =  [NSJSONSerialization JSONObjectWithData:[notification httpResponseData]
                                                                options:kNilOptions
                                                                  error:&error];
        
    if( error == nil ){
        NSMutableArray *mutableRecords = [NSMutableArray array];
        NSArray* data = [parsedData objectForKey:@"data"];
        for (NSDictionary* obj in data) {
            InstaGramSocialStreamDataModel* media = [[InstaGramSocialStreamDataModel alloc] initWithDictionary:obj];
            media.modelType = kInstagramSocialStreamModel;
            [mutableRecords addObject:media];
            [media release];
        }
        
        if([mutableRecords count]) {
            [delegate socialStreamModelIsFinished:(NSArray *)mutableRecords];
        }

    }
    else {
        NSLog(@"%@",[error localizedDescription]);
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

@end
