//
//  FoursquareSocialStreamDataModel.h
//  SocialStreams
//
//  Created by ManishNaharMac on 22/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocialStreamDataModel.h"

@interface FoursquareSocialStreamDataModel : SocialStreamDataModel

@property(nonatomic, retain) NSArray *photosUrlArray;
@property(nonatomic, retain) NSString *categoryImageUrl;
@property(nonatomic, retain) NSArray *tipsArray;

@end
