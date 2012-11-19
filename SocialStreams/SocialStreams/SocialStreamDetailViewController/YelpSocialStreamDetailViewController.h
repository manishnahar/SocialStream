//
//  YelpSocialStreamDetailViewController.h
//  SocialStreams
//
//  Created by ManishNaharMac on 31/08/12.
//
//

#import <UIKit/UIKit.h>
#import "SocialStreamDetailViewController.h"

@interface YelpSocialStreamDetailViewController : SocialStreamDetailViewController <UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate> {
    
}
@property (nonatomic, retain) IBOutlet UIScrollView *imageScrollView;
@property (nonatomic, retain) IBOutlet UITableView *reviews;
@property (nonatomic, retain) NSArray *reviewsArray;
@property (nonatomic, retain) IBOutlet AsyncImageView *ratingsImageView;

@end
