//
//  AsynchronousImageView.h
//  Created by Jeff Musa on 11/17/11.

#import <UIKit/UIKit.h>
@class A;

@interface AsyncImageView : UIImageView 
{
    @private
    A *connection;
    NSMutableData *data;
    UIActivityIndicatorView *activityView;
    
    NSURL *imageURL;
    BOOL loading;
    BOOL isImageLoaded;
}

- (void)loadImageFromURL:(NSURL *)theUrl;

@end
