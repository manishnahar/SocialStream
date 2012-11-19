//
//  TwitterSocialStreamTableViewCell.m
//  SocialStreams
//
//  Created by ManishNaharMac on 27/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TwitterSocialStreamTableViewCell.h"
#import "TwitterSocialStreamDataModel.h"

@implementation TwitterSocialStreamTableViewCell
@synthesize twitterPost;
@synthesize postedBy;
@synthesize postDate;
@synthesize imageView_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setCellContent:(TwitterSocialStreamDataModel *)socialDataModel {
    [self.twitterPost setText:[socialDataModel tweetText]];
    [self.postedBy setText:[socialDataModel fromUserName]];
    [self.postDate setText:[socialDataModel createdTime]];
    
    if([socialDataModel mediaArray] && [[socialDataModel mediaArray] count]) {
        NSString *urlStr = [[[socialDataModel mediaArray] objectAtIndex:0] objectForKey:@"media_url"];
        self.imageView_.image = nil;
        [self.imageView_ loadImageFromURL:[NSURL URLWithString:urlStr]];
    }else {
        [self.imageView_ setImage:[UIImage imageNamed:@"TwitterBig.jpg"]];
    }
}

- (void)dealloc {
    [twitterPost release];
    [postedBy release];
    [postDate release];
    [imageView_ release];
    
    [super dealloc];
}
@end
