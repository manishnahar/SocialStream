//
//  FourSquareSocialStreamTableViewCell.m
//  SocialStreams
//
//  Created by ManishNaharMac on 22/08/12.
//
//

#import "FourSquareSocialStreamTableViewCell.h"

@implementation FourSquareSocialStreamTableViewCell

@synthesize imageView_;
@synthesize locationNameLbl;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellContent:(FoursquareSocialStreamDataModel *)socialDataModel {
    [self.imageView_ loadImageFromURL:[NSURL URLWithString:[socialDataModel thumbnailUrl]]];
    [self.locationNameLbl setText:[socialDataModel locationName]];
}


- (void)dealloc {
    
    [imageView_ release];
    [locationNameLbl release];
    [super dealloc];
}
@end
