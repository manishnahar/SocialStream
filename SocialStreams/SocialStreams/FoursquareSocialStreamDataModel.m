//
//  FoursquareSocialStreamDataModel.m
//  SocialStreams
//
//  Created by ManishNaharMac on 22/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FoursquareSocialStreamDataModel.h"
#import "FoursquareSocialStreamModel.h"

#define ImageBackground         @"bg_"//gray background
#define ImageSize               @"64"

@implementation FoursquareSocialStreamDataModel 

@synthesize photosUrlArray;
@synthesize categoryImageUrl;
@synthesize tipsArray;

- (id) initWithDictionary:(NSDictionary *)dict {
    self = [super initWithDictionary:dict];
    if( self != nil ){
        [self setIdentifier:[dict objectForKey:@"id"]]; 
        
        if([[dict valueForKeyPath:@"categories"] count]) {
            self.thumbnailUrl = [self checkForNULL:[self getFormattedCategoryUrl:[[[dict valueForKeyPath:@"categories"] objectAtIndex:0] valueForKey:@"icon"]]];
        }
        
        self.likes = [[[dict valueForKey:@"likes"] valueForKey:@"count"] integerValue];
        self.locationName = [dict valueForKey:@"name"];
        
    }
    return self;
}

- (void)setVenueDetails:(NSDictionary *)detailDict {
    NSDictionary *venue = [[detailDict objectForKey:@"response"] objectForKey:@"venue"];
    NSArray *groupsArray = [[venue objectForKey:@"photos"] objectForKey:@"groups"];
    
    NSMutableArray *tempPhotosArray = [NSMutableArray array];
    for(NSDictionary *group in groupsArray) {
        NSArray *itemsArray = [group valueForKey:@"items"];        
        for(NSDictionary *item in itemsArray) {
            NSString *url = [item valueForKey:@"url"];
            if(url) {
                [tempPhotosArray addObject:url];
            }
        }
    }
    
    NSArray *tipsGroupsArray = [[venue objectForKey:@"tips"] objectForKey:@"groups"];
    NSMutableArray *tempTipsArray = [NSMutableArray array];
    for(NSDictionary *group in tipsGroupsArray) {
        NSArray *itemsArray = [group valueForKey:@"items"];

        [tempTipsArray addObjectsFromArray:itemsArray];
//        for(NSDictionary *item in itemsArray) {
//            NSString *tip = [item valueForKey:@"text"];
//            if(tip) {
//                [tempTipsArray addObject:tip];
//            }
//        }
    }
        
    self.photosUrlArray = tempPhotosArray;
    self.tipsArray = tempTipsArray;
    
}

- (NSString *)getFormattedCategoryUrl:(NSDictionary *)iconDict {
    
    NSString *formattedUrl = nil;
    
    NSString *prefix = [iconDict valueForKeyPath:@"prefix"];
    NSString *suffix = [iconDict valueForKeyPath:@"suffix"];
    
    if(prefix && suffix) {
        formattedUrl = [NSString stringWithFormat:@"%@%@%@%@", prefix, ImageBackground, ImageSize, suffix];
    }
    
    return formattedUrl;
}

- (BOOL) fetchDetails {
    if( self.areDetailsFetched == NO ){
        NSString *urlStr = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/%@?client_id=%@&client_secret=%@",self.identifier,FourSquareClientID,FourSquareClientSecretKey];
        
        NSURL *url = [NSURL URLWithString:urlStr];
        HttpConnectionHandler *connectionHandler = [HttpConnectionHandler connectionForURL:url];
        [connectionHandler setTarget:self];
        [connectionHandler setStartSelector:@selector(fetchDetailsDidStart:)];
        [connectionHandler setFailSelector:@selector(fetchDetailsDidFail:)];
        [connectionHandler setFinishSelector:@selector(fetchDetailsDidFinish:)];
        
        [connectionHandler start];
    }
    
    return !self.areDetailsFetched;
}

- (void) fetchDetailsDidStart:(HttpConnectionHandler *)connectionHandler {
    [[NSNotificationCenter defaultCenter] postNotificationName:kFetchModelDetailsDidStart
                                                        object:self];
}

- (void) fetchDetailsDidFinish:(HttpConnectionHandler *)connectionHandler{
    NSError *error = nil;
    NSDictionary *venueDetailDict = [NSJSONSerialization JSONObjectWithData:[connectionHandler httpResponseData]
                                                                    options:kNilOptions
                                                                      error:&error];
    if( error == nil ){
        [self setVenueDetails:venueDetailDict];
        self.areDetailsFetched = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:kFetchModelDetailsDidFinish
                                                            object:self];
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kFetchModelDetailsDidFail
                                                            object:self];
    }    
}

- (void) fetchDetailsDidFail:(HttpConnectionHandler *)connectionHandler {
    [[NSNotificationCenter defaultCenter] postNotificationName:kFetchModelDetailsDidFail
                                                        object:self];
}

- (NSString *)locationNameString {
    return [self locationName];
}

- (void)dealloc {
    
    [photosUrlArray release];
    [tipsArray release];
    [super dealloc];
}

@end
