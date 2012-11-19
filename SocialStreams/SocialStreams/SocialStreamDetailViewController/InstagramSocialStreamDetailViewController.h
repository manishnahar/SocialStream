//
//  InstagramSocialStreamDetailViewController.h
//  SocialStreams
//
//  Created by ManishNaharMac on 22/08/12.
//
//

#import <Foundation/Foundation.h>
#import "SocialStreamDetailViewController.h"

@interface InstagramSocialStreamDetailViewController : SocialStreamDetailViewController <UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate> {
    NSMutableArray *asynImgArray;
    NSArray *commentsArray;
}

@property (nonatomic, retain) IBOutlet UIScrollView *imageScrollView;
@property (nonatomic, retain) IBOutlet UITableView *commentsTableView;
@property (nonatomic, retain) NSArray *commentsArray;

@end
