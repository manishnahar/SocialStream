//
//  SocialStreamsTableViewController.h
//  SocialStreams
//
//  Created by ManishNaharMac on 29/08/12.
//
//

#import <UIKit/UIKit.h>
#import "SocialStreamTableViewCell.h"
#import "MergedSocialStreamAdapter.h"

@interface SocialStreamsTableViewController : UITableViewController <MergedSocialStreamAdapterProtocol> {
    MergedSocialStreamAdapter *mergedSocialStreamAdapter;
    NSMutableArray *socialStreamDataArray;
}

@property (nonatomic, retain) MergedSocialStreamAdapter *mergedSocialStreamAdapter;
@property (nonatomic, retain) CLLocation *location;


@end
