//
//  HttpConnectionHandler.h
//
/* "The contents of this file are copyrighted by timeRAZOR, Inc.
 The contents of this file represents the real and intellectual property of timeRAZOR, Inc. 
 Any source code, configuration parameters, documentation, data or database schema may not be copied,
 modified, reused or distributed without the written consent of timeRAZOR, Inc. "
 */
//
#import <Foundation/Foundation.h>
#import "ReachabilityTR.h"

#define kNetworkStatusNotification @"kNetworkStatusNotification"
#define kError525 @"Error525"

typedef enum {
    kGET = 0,
    kPOST = 1,
    kPUT = 2
} RequestMethod;

/**
 *
 */
@interface HttpConnectionHandler :NSObject 
{
    NSURL                       *requestURL;
    NSString                    *requestService;
	NSMutableURLRequest			*httpRequest;
	NSURLConnection				*httpConnection;
    NSData                      *httpRequestData;
	NSMutableData				*httpResponseData;
    NSError                     *httpConnectionError;
    RequestMethod                requestMethod;
    
    SEL finishSelector;
    SEL startSelector;
    SEL failSelector;
    id target;
    
    @private
    BOOL isActive;
}
@property (nonatomic, assign) SEL finishSelector;
@property (nonatomic, assign) SEL startSelector;
@property (nonatomic, assign) SEL failSelector;
@property (nonatomic, readwrite) RequestMethod requestMethod;
@property (nonatomic, retain) id target;

@property (nonatomic, readonly) NSMutableData * httpResponseData;
@property (nonatomic, readonly) NSError * httpConnectionError;

+ (void) startReachability;
+ (NetworkStatus) reachabilityStatus;
+ (HttpConnectionHandler *) connectionForService:(NSString *)service 
                                 withData:(NSData *)data;
+ (HttpConnectionHandler *) connectionForURL:(NSURL *)url;
+ (HttpConnectionHandler *) connectionForURL:(NSURL *)url 
                                    withData:(NSData *)data;
+ (void) cancelAllRequestWithTarget:(id)target;
- (BOOL)isValid;

- (void) start;
- (void) cancel;


@end



