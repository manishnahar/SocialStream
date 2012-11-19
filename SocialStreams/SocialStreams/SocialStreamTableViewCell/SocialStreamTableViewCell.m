//
//  SocialStreamTableViewCell.m
//  SocialStreams
//
//  Created by ManishNaharMac on 21/08/12.
//
//

#import "SocialStreamTableViewCell.h"
#import "InstaGramSocialStreamDataModel.h"

@implementation SocialStreamTableViewCell

@synthesize imageView_;
@synthesize locationNameLabel;
@synthesize lastUpdateLabel;
@synthesize commentLabel;

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

- (void) dealloc {

    [imageView_ release];
    [locationNameLabel release];
    [lastUpdateLabel release];
    [commentLabel release];
    
    [super dealloc];
}

- (void)setCellContent:(InstaGramSocialStreamDataModel *)socialDataModel {
    [self.imageView_ loadImageFromURL:[NSURL URLWithString:[socialDataModel thumbnailUrl]]];
    
//    if(![[socialDataModel locationName] isKindOfClass:[NSNull class]])
//        [self.locationNameLabel setText:[socialDataModel locationName]];
    
    if(![[socialDataModel postedBy] isKindOfClass:[NSNull class]])
        [self.locationNameLabel setText:[socialDataModel postedBy]];

//    if(![[socialDataModel caption] isKindOfClass:[NSNull class]])
//        [self.captionLabel setText:[socialDataModel caption]];

    if(![[socialDataModel lastUpdate] isKindOfClass:[NSNull class]] && [socialDataModel lastUpdate] != nil)
        [self.lastUpdateLabel setText:[Utility timeString:[socialDataModel lastUpdate]]];
    
    if(![[socialDataModel commentText] isKindOfClass:[NSNull class]])
        [self.commentLabel setText:[socialDataModel commentText]];
}

@end
