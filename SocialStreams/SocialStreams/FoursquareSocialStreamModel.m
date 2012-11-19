//
//  FoursquareSocialStreamModel.m
//  SocialStreams
//
//  Created by ManishNaharMac on 17/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FoursquareSocialStreamModel.h"
#import "FoursquareSocialStreamDataModel.h"
#import "FourSquareSocialStreamDetailViewController.h"

@interface FoursquareSocialStreamModel() {
    
}

- (NSURL *) baseURL;
- (void) getVenuesAroundLocation:(CLLocation *)location;
- (void) getVenuesDidStart:(HttpConnectionHandler *)ch;
- (void) getVenuesDidFail:(HttpConnectionHandler *)ch;
- (void) getVenuesDidFinish:(HttpConnectionHandler *)ch;

@end



@implementation FoursquareSocialStreamModel

NSString * const FourSquareClientID           = @"AD0GJCERTBRAPK5GAX3UXB5QVCPXUTMR4FLRSMFSRWBM0BJK";
NSString * const FourSquareClientSecretKey    = @"DZMAWJ10TX3VVUDA5QVSN5ORG30YXXBY0NMCLIQAQJPFPKWX";

-(id)initWithCredentials:(NSDictionary *)credentials_ {
    if(self = [super init]) {
        modelType = kFourSquareSocialStreamModel;
        [self setUserId:[credentials_ objectForKey:@"User_Id"]];
        [self setIdFromAPI:[credentials_ objectForKey:@"Client_Id"]];
        [self setSecretKeyFromAPI:[credentials_ objectForKey:@"Client_Secret"]];
    }
    
    return self;
}

- (void)getSocialStreamDataWithLocation:(CLLocation *)location {
    if([self isSearchUsingLocation]) {
        [self changeLocation:location];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"FourSquare" message:@"Please provide valid latitude and longitude to search data for FourSquare." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}

- (void) changeLocation:(CLLocation *)location {
    [self setLocation:location];
    [self getVenuesAroundLocation:location];
}

- (SocialStreamDetailViewController *) detailViewControllerForDataModel:(SocialStreamDataModel *)ssdm {
    FourSquareSocialStreamDetailViewController *fssdvc = [[FourSquareSocialStreamDetailViewController alloc]
                                                          initWithNibName:@"FourSquareSocialStreamDetailViewController"
                                                          bundle:[NSBundle mainBundle]];
    [fssdvc setSocialStreamDataModel:ssdm];
    return [fssdvc autorelease];
}

- (UITableViewCell *) tableViewCellForSocialStreamDataModel:(SocialStreamDataModel *)ssdm {
    [[NSBundle mainBundle] loadNibNamed:@"FourSquareSocialStreamTableViewCell"
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
    return @"FourSquare";
}

#pragma mark - Private
- (NSURL *) baseURL {
    if( baseURL == nil ){
        baseURL = [[NSURL URLWithString:@"https://api.foursquare.com/v2"] retain];
    }
    return baseURL;
}

- (void) getVenuesAroundLocation:(CLLocation *)location {
    //[connectionHandler cancel];
    connectionHandler = nil;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    
    NSString *strdate = [dateFormatter stringFromDate:[NSDate date]];
    
    NSString *urlStr = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=%f,%f&&client_id=%@&client_secret=%@&v=%@",location.coordinate.latitude,location.coordinate.longitude,FourSquareClientID,FourSquareClientSecretKey,strdate];
    NSURL *url = [NSURL URLWithString:urlStr];
    connectionHandler = [HttpConnectionHandler connectionForURL:url];
    [connectionHandler setTarget:self];
    [connectionHandler setStartSelector:@selector(getVenuesDidStart:)];
    [connectionHandler setFailSelector:@selector(getVenuesDidFail:)];
    [connectionHandler setFinishSelector:@selector(getVenuesDidFinish:)];
    
    [connectionHandler start];

    [dateFormatter release];
}

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
        
        NSArray *venues = [[parsedData objectForKey:@"response"] objectForKey:@"venues"];
/*        if( [venues count] != 0 ) {
            NSArray *sortedVenues = [venues sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
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
                      
            if( [sortedVenues count] > 0 ){
                NSDictionary *venue = [sortedVenues objectAtIndex:0];
                FoursquareSocialStreamDataModel *fourSquareModel = [[FoursquareSocialStreamDataModel alloc] initWithDictionary:venue];
                [fourSquareModel setModelType:kFourSquareSocialStreamModel];
                [recordsArray addObject:fourSquareModel];
                [fourSquareModel release];
            }
            
            if([recordsArray count]) {
                [delegate socialStreamModelIsFinished:(NSArray *)recordsArray];
            }
        }
*/
        
        if( [venues count] != 0 ) {
            __block NSMutableArray *filterdVenues = [NSMutableArray array];
            
            if([self isSearchUsingLocation]) {
                if([self venueName] != nil && [[self venueName] length]) {
                    for(NSDictionary *venue in venues) {
                        if([Utility compareInputLocationName:[venue objectForKey:@"name"] withSearchLocation:[self venueName]]) {
                            [filterdVenues addObject:venue];
                        }
                    }
                } else {
                    NSDictionary *cloesetVenue = [self getClosestLocationFromLocations:venues withRequestedLocation:[self location]];
                    [filterdVenues addObject:cloesetVenue];
                }
            } else {
                [filterdVenues addObjectsFromArray:venues];
            }
            
            if([filterdVenues count]) {
                for(NSDictionary *venue in filterdVenues) {
                    FoursquareSocialStreamDataModel *fourSquareModel = [[FoursquareSocialStreamDataModel alloc] initWithDictionary:venue];
                    [fourSquareModel setModelType:kFourSquareSocialStreamModel];
                    [recordsArray addObject:fourSquareModel];
                    [fourSquareModel release];
                }
                if([recordsArray count]) {
                    [delegate socialStreamModelIsFinished:(NSArray *)recordsArray];
                }
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

- (BOOL)isSearchUsingLocation {
    return ([[self location] coordinate].latitude != 0.0 && [[self location] coordinate].longitude != 0.0);
}

- (void)dealloc {
    
    [super dealloc];
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

    //-(void)getVenueDetails:(NSString *)venueId_ {
    //    NSString *urlStr = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/%@?client_id=%@&client_secret=%@",venueId_, FourSquareClientID,FourSquareClientSecretKey];
    //    
    //    NSURL *url = [NSURL URLWithString:urlStr];
    //    connectionHandler = [HttpConnectionHandler connectionForURL:url];
    //    [connectionHandler setTarget:self];
    //    [connectionHandler setStartSelector:@selector(getVenueDetailsDidStart:)];
    //    [connectionHandler setFailSelector:@selector(getVenueDetailsDidFail:)];
    //    [connectionHandler setFinishSelector:@selector(getVenueDetailsDidFinish:)];
    //    
    //    [connectionHandler start];
    //}
    //
    //- (void) getVenueDetailsDidStart:(HttpConnectionHandler *)notification {
    //    
    //}
    //
    //- (void) getVenueDetailsDidFail:(HttpConnectionHandler *)notification {
    //    NSLog(@"%@",[[notification httpConnectionError] localizedDescription]);
    //}
    //
    //- (void) getVenueDetailsDidFinish:(HttpConnectionHandler *)notification {
    //    NSError *error = nil;
    //    NSDictionary *parsedData =  [NSJSONSerialization JSONObjectWithData:[notification httpResponseData]
    //                                                                options:kNilOptions
    //                                                                  error:&error];
    //    
    ////    NSMutableArray *recordsArray = [NSMutableArray array];
    //    if( error == nil ){
    //
    //        ///tips-------------------
    //        NSArray *tipsGroupsArray = [[[[parsedData objectForKey:@"response"] objectForKey:@"venue"] objectForKey:@"tips"] objectForKey:@"groups"];
    //
    //        NSMutableArray *tipsArray = [[NSMutableArray alloc] init];
    //
    //        for(NSDictionary *group in tipsGroupsArray) {
    //            
    //            NSArray *itemsArray = [group valueForKey:@"items"];
    //            
    //            for(NSDictionary *item in itemsArray) {
    //                NSString *tip = [item valueForKey:@"text"];
    //                if(tip) {
    //                    [tipsArray addObject:tip];
    //                }
    //            }
    //        }
    //
    //        
    //        
    //        
    //        ///Photos-----------------
    //        NSArray *groupsArray = [[[[parsedData objectForKey:@"response"] objectForKey:@"venue"] objectForKey:@"photos"] objectForKey:@"groups"];
    //        
    //        NSMutableArray *photosArray = [[NSMutableArray alloc] init];
    //        
    //        for(NSDictionary *group in groupsArray) {
    //
    //            NSArray *itemsArray = [group valueForKey:@"items"];
    //
    //            for(NSDictionary *item in itemsArray) {
    //                NSString *url = [item valueForKey:@"url"];
    //                if(url) {
    //                    [photosArray addObject:url];
    //                }
    //            }
    //        }
    //        
    //    }else {
    //        NSLog(@"%@",[error localizedDescription]);
    //    }
    //}

