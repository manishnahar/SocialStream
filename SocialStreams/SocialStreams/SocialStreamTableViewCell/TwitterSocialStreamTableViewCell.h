//
//  TwitterSocialStreamTableViewCell.h
//  SocialStreams
//
//  Created by ManishNaharMac on 27/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SocialStreamTableViewCell.h"

@interface TwitterSocialStreamTableViewCell : SocialStreamTableViewCell {
    
}
@property (nonatomic, retain) IBOutlet AsyncImageView *imageView_;
@property (retain, nonatomic) IBOutlet UILabel *twitterPost;
@property (retain, nonatomic) IBOutlet UILabel *postedBy;
@property (retain, nonatomic) IBOutlet UILabel *postDate;


@end
