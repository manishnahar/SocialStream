//
//  SocialStreamModelListTableViewCellCell.m
//  SocialStreams
//
//  Created by ManishNaharMac on 21/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SocialStreamSettingTableViewCell.h"

@implementation SocialStreamSettingTableViewCell
@synthesize socialStreamName;
@synthesize isSocialStreamUsed;


- (void)dealloc {
    [socialStreamName release];
    [isSocialStreamUsed release];
    [super dealloc];
}
@end
