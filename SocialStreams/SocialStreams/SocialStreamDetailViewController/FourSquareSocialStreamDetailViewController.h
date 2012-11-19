//
//  FourSquareSocialStreamDetailViewController.h
//  SocialStreams
//
//  Created by ManishNaharMac on 23/08/12.
//
//

#import <UIKit/UIKit.h>
#import "SocialStreamDetailViewController.h"
#import "PageControl.h"

@interface FourSquareSocialStreamDetailViewController : SocialStreamDetailViewController
<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate> {
    NSMutableArray *asynImgArray;
}
@property (nonatomic, retain) IBOutlet UIScrollView *imageScrollView;
@property (nonatomic, retain) IBOutlet UITableView *reviews;
@property (nonatomic, retain) NSArray *tipsArray;
@property (nonatomic, retain) IBOutlet PageControl *pageControl;

@end
