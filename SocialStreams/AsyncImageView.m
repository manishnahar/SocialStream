//
//  AsynchronousImageView.m
//  Created by Jeff Musa on 11/17/11.

#import "AsyncImageView.h"

#define CACHE_MB 4

@interface AsyncImageView ()
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) NSURL *imageURL;
@property (atomic, assign) BOOL loading;

@property (nonatomic, strong) A *connection;
@property (nonatomic, strong) NSMutableData *data;

@end

@interface A : NSURLConnection

@end
/* test */
@implementation A
-(id)init
{
    self = [super init];
    if ( self )
    {
        NSLog(@"init");
    }
    return self;
}

-(void)dealloc
{
    NSLog(@"dealloc");
    [super dealloc];
}
@end
/*end test */

@interface AsyncImageView (PrivateMethods)
-(void)showErrorImage;
-(void)loadImage;
@end

@implementation AsyncImageView
@synthesize activityView, imageURL, loading, connection, data;

- (void)setup {
    [self setContentMode:UIViewContentModeScaleAspectFill];
    [self setClipsToBounds:YES];
    [self setLoading:NO];
}

- (void)awakeFromNib {
    [self setup];
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        [self setup];
    }
    return self;
}

-(void)dealloc
{
    NSLog(@"AsyncImageView->dealloc");
    [super dealloc];
}

- (void)loadImageFromURL:(NSURL *)theUrl
{
    
    [self setImageURL:theUrl];
    
    [self setImage:nil];
    
    if ( [theUrl isFileURL] )
    {
        [self hideActivityIndicator];

        [self setImage:[UIImage imageWithContentsOfFile:[theUrl path]]];
        return;
    }
    else
    {   
        [self loadImage];
    }
}

-(void)loadImage 
{
    
    if ( [self loading] )
        return;
    
    if ( [self imageURL] == nil )
        return;
    
    [self setLoading:YES];
    [self setBackgroundColor:[UIColor lightGrayColor]];
    
    [self showActivityIndicator];
    [[NSURLCache sharedURLCache] setMemoryCapacity:1024*1024*CACHE_MB];  //must set each time, otherwise cleared.
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[self imageURL]
                                             cachePolicy:NSURLRequestReturnCacheDataElseLoad 
                                         timeoutInterval:30.0];
    
    //        connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    /*
     //  debug code used to test the cache
     static long cacheHitCount = 0;
     static long cacheMissCount = 0;
     NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
     if ( cachedResponse )
     NSLog(@"cache HIT: %ld", ++cacheHitCount);
     else {
     NSLog(@"cache MISS %ld", ++cacheMissCount);
     }
     */
    
    [self setConnection:(A *)[[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO]];
    [[self connection] scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [[self connection] start];
    [self setConnection:nil];
    
    NSLog(@"requesting image: %@", [[self imageURL] path]);

}

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData 
{
    if (data == nil)
        [self setData:[[NSMutableData alloc] initWithCapacity:2048]];
        
        [[self data] appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection 
{
    [self setLoading:NO];
    [self hideActivityIndicator];
    [self setImage:[UIImage imageWithData:data]];
    [self setData:nil];
    theConnection = nil;
}

-(void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error
{
    [self setLoading:NO];
    [self hideActivityIndicator];
    [self showErrorImage];
    [self setData:nil];
    theConnection = nil;
}

#pragma mark Implementation
-(UIActivityIndicatorView *)activityView
{
    if ( activityView == nil )
    {
        [self setActivityView:[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite]];
        [[self activityView] setAutoresizingMask:UIViewContentModeCenter];
        CGRect bounds = [[self activityView] bounds];
        CGRect imageBounds = [self bounds];
        bounds.origin.x = CGRectGetMidX(imageBounds) - CGRectGetMidX(bounds);
        bounds.origin.y = (imageBounds.size.height * 0.4f) -  (CGRectGetHeight(bounds) / 2) ;  //place in top 40% of image
        [[self activityView] setFrame:bounds];
        [self addSubview:activityView];
    }
    return activityView;
}

-(void)showActivityIndicator
{
    dispatch_queue_t main_queue = dispatch_get_main_queue();
    dispatch_async(main_queue, ^{
        [[self activityView] setHidden:NO];
        [[self activityView] startAnimating];
        [self setNeedsDisplay];
        
    });
}

-(void)hideActivityIndicator
{
    dispatch_queue_t main_queue = dispatch_get_main_queue();
    dispatch_async(main_queue, ^{
        [[self activityView] setHidden:YES];
        [[self activityView] stopAnimating];
        [self setNeedsDisplay];
        
    });
    
}

-(void)showErrorImage
{
    [self setImage:[UIImage imageNamed:@"No_Image"]];
}

@end
