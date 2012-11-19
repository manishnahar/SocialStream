//
//  SocialStreamDetailViewController.h
//  SocialStreams
//
//  Created by ManishNaharMac on 21/08/12.
//
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "SocialStreamDataModel.h"
#import "SocialStreamReviewsTableViewCell.h"
#import "PageControl.h"

@protocol SocialStreamFetchDetailNotification <NSObject>

- (void) addObserverForDataModel:(SocialStreamDataModel *)dataModel;
- (void) removeObserverForDataModel:(SocialStreamDataModel *)dataModel;
- (void) fetchDetailsDidStart:(NSNotification *)notification;
- (void) fetchDetailsDidFail:(NSNotification *)notification;
- (void) fetchDetailsDidFinish:(NSNotification *)notification;

@end

@interface SocialStreamDetailViewController : UIViewController <SocialStreamFetchDetailNotification, PageControlDelegate>

@property (nonatomic, retain) IBOutlet AsyncImageView *imageView_;
@property (nonatomic, retain) IBOutlet UILabel *likes;
@property (nonatomic, retain) IBOutlet UILabel *postedBy;

@property (nonatomic, retain) SocialStreamDataModel *socialStreamDataModel;

@property (nonatomic, assign) IBOutlet SocialStreamReviewsTableViewCell *reviewsCell;
@property (nonatomic, retain) IBOutlet PageControl *pageControl;
@property (nonatomic, retain) NSArray *tweetsDetailsArray;

@end
