//
//  SocialStreamDataModel.m
//  SocialStreams
//
//  Created by ManishNaharMac on 21/08/12.
//
//

#import "SocialStreamDataModel.h"

NSString * const kFetchModelDetailsDidStart     = @"kFetchModelDetailsDidStart";
NSString * const kFetchModelDetailsDidFinish    = @"kFetchModelDetailsDidFinish";
NSString * const kFetchModelDetailsDidFail      = @"kFetchModelDetailsDidFail";

@implementation SocialStreamDataModel

@synthesize identifier;
@synthesize thumbnailUrl;
@synthesize standardUrl;
@synthesize likes;
@synthesize locationName;
@synthesize lastUpdate;
@synthesize postedBy;
@synthesize modelType;
@synthesize areDetailsFetched;

- (id) initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if( self != nil ){
        
    }
    return self;
}

- (void) dealloc {
    
    [thumbnailUrl release];
    [standardUrl release];
    [locationName release];
    [lastUpdate release];
    [postedBy release];

    [super dealloc];
}

- (id)checkForNULL:(id) value_ {
    
    if([value_ isKindOfClass:[NSNull class]]) {
        value_ = nil;
    }
    return value_;
}

- (BOOL) fetchDetails {
    return NO;
}

- (void) cancelFetchDetails {    
}

- (void) fetchDetailsDidStart:(HttpConnectionHandler *)connectionHandler {
}

- (void) fetchDetailsDidFinish:(HttpConnectionHandler *)connectionHandler{
}

- (void) fetchDetailsDidFail:(HttpConnectionHandler *)connectionHandler {
}

- (NSString *)locationNameString {
    return nil;
}

@end
