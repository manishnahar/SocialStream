//
//  TwitterSocialStreamDetailViewController.h
//  SocialStreams
//
//  Created by ManishNaharMac on 07/09/12.
//
//

#import <UIKit/UIKit.h>
#import "SocialStreamDetailViewController.h"

@interface TwitterSocialStreamDetailViewController : SocialStreamDetailViewController <UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate> {
    NSMutableArray *asynImgArray;
    NSMutableArray *imgesUrlArray;
    NSMutableArray *tweetsTextsArray;
}

@property (retain, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (retain, nonatomic) IBOutlet UITableView *tweetsTableView;

@end
