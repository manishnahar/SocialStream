//
//  YelpSocialStreamDataModel.m
//  SocialStreams
//
//  Created by ManishNaharMac on 31/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YelpSocialStreamDataModel.h"

@implementation YelpSocialStreamDataModel

//@property (nonatomic, retain) NSString *identifier;
//@property (nonatomic, strong) NSString* thumbnailUrl;
//@property (nonatomic, strong) NSString* standardUrl;
//@property (nonatomic, assign) NSUInteger likes;
//@property (nonatomic, strong) NSString* locationName;
//@property (nonatomic, strong) NSString* lastUpdate;
//@property (nonatomic, strong) NSString* postedBy;
//@property (nonatomic, readwrite) SocialStreamModelType modelType;
//@property (nonatomic, readwrite) BOOL areDetailsFetched;

@synthesize reviewsArray;
@synthesize ratingImageUrl;

- (id) initWithDictionary:(NSDictionary *)dict {
    self = [super initWithDictionary:dict];
    if( self != nil ){
        [self setThumbnailUrl:[dict objectForKey:@"photo_url"]];
        [self setLocationName:[dict objectForKey:@"name"]];
        [self setReviewsArray:[dict objectForKey:@"reviews"]];
        [self setRatingImageUrl:[dict objectForKey:@"rating_img_url_small"]];
    }
    return self;
}

- (NSString *)locationNameString {
    return [self locationName];
}

- (void)dealloc {
    
    [reviewsArray release];
    [ratingImageUrl release];
    
    [super dealloc];
}

@end
