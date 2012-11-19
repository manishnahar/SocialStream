//
//  YelpSocialStreamTableViewCellCell.h
//  SocialStreams
//
//  Created by ManishNaharMac on 31/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "YelpSocialStreamDataModel.h"
#import "SocialStreamTableViewCell.h"

@interface YelpSocialStreamTableViewCellCell : SocialStreamTableViewCell
@property (retain, nonatomic) IBOutlet AsyncImageView *thumbnailImageView;
@property (retain, nonatomic) IBOutlet UILabel *locationNameLbl;

- (void)setCellContent:(YelpSocialStreamDataModel *)socialDataModel;

@end
