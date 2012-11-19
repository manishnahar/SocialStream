//
//  YelpSocialStreamTableViewCellCell.m
//  SocialStreams
//
//  Created by ManishNaharMac on 31/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YelpSocialStreamTableViewCellCell.h"

@implementation YelpSocialStreamTableViewCellCell
@synthesize thumbnailImageView;
@synthesize locationNameLbl;

- (void)setCellContent:(YelpSocialStreamDataModel *)socialDataModel {
    [self.thumbnailImageView loadImageFromURL:[NSURL URLWithString:[socialDataModel thumbnailUrl]]];
    [locationNameLbl setText:[socialDataModel locationName]];
}

- (void)dealloc {
    [thumbnailImageView release];
    [locationNameLbl release];
    [super dealloc];
}

@end
