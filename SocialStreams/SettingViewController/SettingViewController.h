//
//  SecondViewController.h
//  SocialStreams
//
//  Created by ManishNaharMac on 17/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocialStreamModelListTableViewCellCell.h"

@class MergedSocialStreamAdapter;

@interface SecondViewController : UIViewController <UITableViewDataSource,UITableViewDataSource> {
    MergedSocialStreamAdapter *mergedSocialStreamAdapter;
    IBOutlet UITableView *socialStreamListTableView;
    IBOutlet SocialStreamModelListTableViewCellCell *socialStreamModelListTableViewCellCell;
}
@property (nonatomic, retain) MergedSocialStreamAdapter *mergedSocialStreamAdapter;

- (IBAction)socialStreamSelectionValueChanged:(id)sender;

@end
