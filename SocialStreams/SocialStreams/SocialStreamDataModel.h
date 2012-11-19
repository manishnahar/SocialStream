//
//  SocialStreamDataModel.h
//  SocialStreams
//
//  Created by ManishNaharMac on 21/08/12.
//
//ManishNaharMac

#import <Foundation/Foundation.h>
#import "HttpConnectionHandler.h"

NSString * const kFetchModelDetailsDidStart;
NSString * const kFetchModelDetailsDidFinish;
NSString * const kFetchModelDetailsDidFail;

@protocol SocialStreamDataModelFetchRequestHandlers <NSObject>

- (void) fetchDetailsDidStart:(HttpConnectionHandler *)connectionHandler;
- (void) fetchDetailsDidFail:(HttpConnectionHandler *)connectionHandler;
- (void) fetchDetailsDidFinish:(HttpConnectionHandler *)connectionHandler;

@end

@interface SocialStreamDataModel : NSObject <SocialStreamDataModelFetchRequestHandlers>{
}
@property (nonatomic, retain) NSString *identifier;
@property (nonatomic, strong) NSString* thumbnailUrl;
@property (nonatomic, strong) NSString* standardUrl;
@property (nonatomic, assign) NSUInteger likes;
@property (nonatomic, strong) NSString* locationName;
@property (nonatomic, strong) NSString* lastUpdate;
@property (nonatomic, strong) NSString* postedBy;
@property (nonatomic, readwrite) SocialStreamModelType modelType;
@property (nonatomic, readwrite) BOOL areDetailsFetched;

- (id)initWithDictionary:(NSDictionary *)dict;
- (id)checkForNULL:(id) value_;
- (BOOL) fetchDetails;
- (void) cancelFetchDetails;
- (NSString *)locationNameString;

@end
