//
//  SocialStreamReviewsTableViewCell.h
//  SocialStreams
//
//  Created by ManishNaharMac on 03/09/12.
//
//

#import <UIKit/UIKit.h>

@interface SocialStreamReviewsTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *userNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *dateTimeLabel;
@property (nonatomic, retain) IBOutlet UILabel *reviewLabel;

- (void)setCellContent:(NSDictionary *)dict;

@end
