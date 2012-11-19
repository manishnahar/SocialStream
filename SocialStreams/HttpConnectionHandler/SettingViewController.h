//
//  SettingViewController.h
//  SocialStreams
//
//  Created by ManishNaharMac on 17/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocialStreamSettingTableViewCell.h"
#import "AppDelegate.h"

@class MergedSocialStreamAdapter;

@interface SettingViewController : UIViewController <UITableViewDataSource,UITableViewDataSource> {
    MergedSocialStreamAdapter *mergedSocialStreamAdapter;
    IBOutlet UITableView *socialStreamListTableView;
    IBOutlet SocialStreamSettingTableViewCell *socialStreamModelListTableViewCellCell;
}
@property (nonatomic, retain) MergedSocialStreamAdapter *mergedSocialStreamAdapter;


@end
