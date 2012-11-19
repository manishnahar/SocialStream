//
//  FourSquareSocialStreamTableViewCell.h
//  SocialStreams
//
//  Created by ManishNaharMac on 22/08/12.
//
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "FoursquareSocialStreamDataModel.h"
#import "SocialStreamTableViewCell.h"

@interface FourSquareSocialStreamTableViewCell : SocialStreamTableViewCell {
    
}
@property (nonatomic, retain) IBOutlet AsyncImageView *imageView_;
@property (retain, nonatomic) IBOutlet UILabel *locationNameLbl;

- (void)setCellContent:(FoursquareSocialStreamDataModel *)socialDataModel ;

@end
