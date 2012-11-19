//
//  SocialStreamReviewsTableViewCell.m
//  SocialStreams
//
//  Created by ManishNaharMac on 03/09/12.
//
//

#import "SocialStreamReviewsTableViewCell.h"

@implementation SocialStreamReviewsTableViewCell

@synthesize userNameLabel;
@synthesize dateTimeLabel;
@synthesize reviewLabel;

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

- (void)setCellContent:(NSDictionary *)dict {
    [[self userNameLabel] setText:[[dict objectForKey:@"from"] objectForKey:@"full_name"]];
    [[self dateTimeLabel] setText:[Utility timeString:[dict objectForKey:@"created_time"]]];
    [[self reviewLabel] setText:[dict objectForKey:@"text"]];
}

- (void) dealloc {
    
    [userNameLabel release];
    [dateTimeLabel release];
    [reviewLabel release];
    [super dealloc];
}

@end
