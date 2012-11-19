//
//  HttpConnectionHandler.h
//
/* "The contents of this file are copyrighted by timeRAZOR, Inc.
 The contents of this file represents the real and intellectual property of timeRAZOR, Inc. 
 Any source code, configuration parameters, documentation, data or database schema may not be copied,
 modified, reused or distributed without the written consent of timeRAZOR, Inc. "
 */
//
#import "HttpConnectionHandler.h"


#define ERROR_DIALOG_ON YES
@interface HttpConnectionHandler()

- (void) clearRequestData;
- (void) clearResponseData;
- (void) sendASyncronousPostRequestWithService:(NSString *)service
                                      withData:(NSData *)data;
- (void) sendASyncronousPostRequestWithUrl:(NSURL*)url
                                  withData:(NSData*)data;
- (void) sendASyncronousPostRequestWithUrl:(NSURL *)url;

@end

@interface HttpConnectionHandler(Reachability)

+ (ReachabilityTR *) reachability;
+ (void) reachabilityChanged:(NSNotification *)notification;
+ (void) showNoNetworkAvailabiltyAlert;

@end


@implementation HttpConnectionHandler

#define CONTENT_TYPE						@"Content-Type"
#define CONTENT_TYPE_VALUE					@"application/json"
#define ACCEPT_CHARSET						@"Accept"
#define ACCEPT_CHARSET_VALUE				@"application/json"

#define TIMEOUT_INTERVAL					60.0f

@synthesize finishSelector;
@synthesize startSelector;
@synthesize failSelector;
@synthesize target; 

@synthesize requestMethod;
@synthesize httpResponseData;
@synthesize httpConnectionError;

static NSMutableArray * httpConnectionRequests = nil;
static NSArray * methodStrings = nil;
static ReachabilityTR * reachability = nil;

+ (void) startReachability {
    if ( reachability == nil )
    {
        NSLog(@"*** starting reachability ***");
        [[self reachability] startNotifier];
    }
}

+ (NSMutableArray *) httpConnectionRequests {
    if( httpConnectionRequests == nil ){
        httpConnectionRequests = [[NSMutableArray alloc] init];
    }
    return httpConnectionRequests;
}

+ (void) cancelAllRequestWithTarget:(id)target {
    NSPredicate * predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [target isEqual:[(HttpConnectionHandler *)evaluatedObject target]];
    }];
    NSArray * targets = [[[self class] httpConnectionRequests] filteredArrayUsingPredicate:predicate];
    for( id tg in targets ){
        [tg cancel];
    }
}


+ (NSString *) methodStringForMethodType:(RequestMethod)method {
    if( methodStrings == nil ){
        methodStrings = [[NSArray alloc] initWithObjects:@"GET",@"POST",@"PUT", nil];
    }
    return [methodStrings objectAtIndex:method];
}

+ (void) addRequest:(HttpConnectionHandler *)request {
    [[[self class] httpConnectionRequests] addObject:request];
    if( [[[self class] httpConnectionRequests] count] > 0 ){
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
}

+ (void) removeRequest:(HttpConnectionHandler *)request {
    [[[self class] httpConnectionRequests] removeObject:request];
    if( [[[self class] httpConnectionRequests] count] == 0 ){
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}

- (id) initConnectionForService:(NSString *)service
                       withData:(NSData *)data {
    self = [super init];
    if( self != nil ){
        requestService = [service retain];
        httpRequestData = [data retain];
        requestMethod = kPOST;
    }
    return self;
}

- (id) initConnectionForURL:(NSURL *)url
                   withData:(NSData *)data {
    self = [super init];
    if( self != nil ){
        requestURL = [url retain];
        httpRequestData = [data retain];
        requestMethod = kPOST;
    }
    return self;
}

- (id) initConnectionForURL:(NSURL *)url {
    self = [super init];
    if( self != nil ){
        requestURL = [url retain];
        requestMethod = kGET;
    }
    return self;
}

+ (HttpConnectionHandler *) connectionForService:(NSString *)service
                                 withData:(NSData *)data {
    return [[[[self class] alloc] initConnectionForService:service 
                                                  withData:data] autorelease];
}

+ (HttpConnectionHandler *) connectionForURL:(NSURL *)url {
    return [[[[self class] alloc] initConnectionForURL:url] autorelease];
}

+ (HttpConnectionHandler *) connectionForURL:(NSURL *)url 
                                    withData:(NSData *)data {
    return [[[[self class] alloc] initConnectionForURL:url
                                              withData:data] autorelease];
}

+ (NetworkStatus) reachabilityStatus {
    return [[[self class] reachability] currentReachabilityStatus];
}

- (void) start {
    if( [[[self class] reachability] currentReachabilityStatus] != NotReachable ){
        if( isActive != YES ){
            [self clearRequestData];
            [self clearResponseData];
            if( requestURL != nil ){
                [self sendASyncronousPostRequestWithUrl:requestURL];
            }
            else {
                [self sendASyncronousPostRequestWithService:requestService
                                                   withData:httpRequestData];
            }
        }
    }
    else {
        httpConnectionError = [NSError errorWithDomain:@"No Network Connection Available"
                                                  code:0
                                              userInfo:nil];
        [httpConnectionError retain];
        [target performSelector:failSelector
                     withObject:self];
    }
}

- (void) sendASyncronousPostRequestWithService:(NSString *)service
                                      withData:(NSData *)data {
//    NSString * urlString = [NSString stringWithFormat:@"%@/%@",[Utility getServerURL],service];
//    NSURL * url = [NSURL URLWithString:urlString];
//    [self sendASyncronousPostRequestWithUrl:url
//                                   withData:data];
}

-(void)sendASyncronousPostRequestWithUrl:(NSURL *)url
                                withData:(NSData*)data {	    
	httpRequest=[[NSMutableURLRequest alloc] initWithURL:url];
	[httpRequest setTimeoutInterval:TIMEOUT_INTERVAL];
	[httpRequest setValue:CONTENT_TYPE_VALUE forHTTPHeaderField:CONTENT_TYPE];
	[httpRequest setValue:ACCEPT_CHARSET_VALUE forHTTPHeaderField:ACCEPT_CHARSET];
	[httpRequest setHTTPMethod:[[self class] methodStringForMethodType:requestMethod]];
    if( data != nil ){
        [httpRequest setValue:[NSString stringWithFormat:@"%d",[data length]] forHTTPHeaderField:@"Content-Length"];
        [httpRequest setHTTPBody:data];
    }
	
	
	httpConnection = [[NSURLConnection alloc] initWithRequest:httpRequest
                                                     delegate:self];
    isActive = YES;
    [[self class] addRequest:self];
}

- (void) sendASyncronousPostRequestWithUrl:(NSURL *)url {
    [self sendASyncronousPostRequestWithUrl:url
                                   withData:httpRequestData];
}

-(void)cancel { 
	if ( httpConnection)  {
		[httpConnection cancel];
	}
    
    [self clearRequestData];
    [self clearResponseData];
}

- (void) clearRequestData {
    FREE_NSOBJ(httpConnection);
    FREE_NSOBJ(httpRequest);
    isActive = NO;
    [[self class] removeRequest:self];
}

- (void) clearResponseData {
    FREE_NSOBJ(httpResponseData);
    FREE_NSOBJ(httpConnectionError);
}

#pragma mark -
#pragma mark Connection Delegate 
-(void)connection:(NSURLConnection *)connection 
didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
}

-(void) connection:(NSURLConnection *) connection
didReceiveResponse:(NSURLResponse *) response {    
    httpResponseData = [[NSMutableData alloc] init];
        
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
    assert( [httpResponse isKindOfClass:[NSHTTPURLResponse class]] );
    int statusCode = [httpResponse statusCode];
    if (  statusCode / 100 == 5 )
    {
        httpConnectionError = [[NSError alloc] initWithDomain:@"connection" code:-1 * statusCode userInfo:nil];

        if ( statusCode == 525 )
        {
            [target performSelector:failSelector
                         withObject:self];
            [self cancel];
            [[NSNotificationCenter defaultCenter] postNotificationName:kError525 object:nil];
            return;
        }
        DPLog(@"\n\n_+_+_+_+_+_+ httpResponse = %i +_+_+_+_+_+_+_+_\n\n", statusCode);
        if ( ERROR_DIALOG_ON )
        {
            dispatch_async(dispatch_get_main_queue(), ^{
//                [Utility alertWithTitle:@"This is wrong" 
//                                    msg:[NSString stringWithFormat:@"That wasn't supposed to happen.  We're going to take a look under the hood.\n\nMind trying again?\n\nStatus Code: %i", statusCode]];                
            });
            NSLog(@"\nconnection:didReceiveResponse:httpResponse = %i\n",  statusCode);

        }
    }
    else if ( statusCode / 100 != 2 )
    {
        DPLog(@"\nhttpResponse = %i\n",  statusCode);
    }
    [target performSelector:startSelector
                 withObject:self];
}

-(void) connection:(NSURLConnection *) connection 
    didReceiveData:(NSData *) data {
	[httpResponseData appendData:data];
}

-(void) connection:(NSURLConnection *) connection 
  didFailWithError:(NSError *) error {	
    DPLog(@"***** connection didFailWithError: %@", [error description] );
    /*
    if ( ERROR_DIALOG_ON )
    {
        dispatch_async(dispatch_get_main_queue(), ^{
                           [Utility alertWithTitle:@"This is wrong" msg:[NSString stringWithFormat:@"That wasn't supposed to happen.  We're going to take a look under the hood.\n\nMind trying again?\n\n%@", [error description]]];                           
        });
    }
    */
    NSLog(@"\nconnection:didFailWithError:%@\n", [error description]);
    httpConnectionError = [error retain];
    [target performSelector:failSelector
                 withObject:self];
    [self clearRequestData];
}

-(void) connectionDidFinishLoading:(NSURLConnection *) connection  {    
    httpConnectionError = nil;
    [target performSelector:finishSelector
                 withObject:self];
    [self clearRequestData];
}

-(void)dealloc {    
    [self clearRequestData];
    [self clearResponseData];
    
    FREE_NSOBJ(requestService);
    FREE_NSOBJ(httpRequestData);
    FREE_NSOBJ(requestURL);
    FREE_NSOBJ(target);
    
    finishSelector = nil;
    failSelector = nil;
    startSelector = nil;
	[super dealloc];
}

-(BOOL)isValid
{
    return ([self httpConnectionError] == nil);
}

@end

@implementation HttpConnectionHandler(Reachability)

+ (ReachabilityTR *) reachability {
    if( reachability == nil ){
        reachability = [[ReachabilityTR reachabilityForInternetConnection] retain];
    }
    return reachability;
}

+ (void) reachabilityChanged:(NSNotification *)notification {
// [[NSNotificationCenter defaultCenter] postNotificationName:kNetworkStatusNotification
//                                                        object:nil];
}

+ (void) showNoNetworkAvailabiltyAlert {
     //[Utility showPopUpForNoNetwork];
}

@end