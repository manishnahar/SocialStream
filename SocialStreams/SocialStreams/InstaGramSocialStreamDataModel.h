//
//  InstaGramSocialStreamDataModel.h
//  SocialStreams
//
//  Created by ManishNaharMac on 21/08/12.
//
//

#import <Foundation/Foundation.h>
#import "SocialStreamDataModel.h"

@interface InstaGramSocialStreamDataModel : SocialStreamDataModel

@property(nonatomic, retain) NSArray *commentsArray;
@property(nonatomic, retain) NSString *commentText;

@end
