//
//  SocialStreamTableViewCell.h
//  SocialStreams
//
//  Created by ManishNaharMac on 21/08/12.
//
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "SocialStreamDataModel.h"

@interface SocialStreamTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet AsyncImageView *imageView_;
@property (nonatomic, retain) IBOutlet UILabel *locationNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *lastUpdateLabel;
@property (nonatomic, retain) IBOutlet UILabel *commentLabel;

- (void)setCellContent:(SocialStreamDataModel *)socialDataModel ;
    
@end
