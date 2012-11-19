//
//  InstaGramSocialStreamDataModel.m
//  SocialStreams
//
//  Created by ManishNaharMac on 21/08/12.
//
//

#import "InstaGramSocialStreamDataModel.h"

@implementation InstaGramSocialStreamDataModel

@synthesize commentsArray;
@synthesize commentText;

- (id)initWithDictionary:(NSDictionary *)dict {
    
    if(self = [super initWithDictionary:dict]) {
        self.thumbnailUrl = [self checkForNULL:[[[dict valueForKeyPath:@"images"] valueForKeyPath:@"thumbnail"] valueForKeyPath:@"url"]];
        
        self.standardUrl = [self checkForNULL:[[[dict valueForKeyPath:@"images"] valueForKeyPath:@"standard_resolution"] valueForKeyPath:@"url"]];
        
        self.likes = [[[dict objectForKey:@"likes"] valueForKey:@"count"] integerValue];
        
        self.locationName = [self checkForNULL:[[dict valueForKeyPath:@"location"] valueForKeyPath:@"name"]];
        
        self.lastUpdate = [self checkForNULL:[[dict valueForKeyPath:@"caption"] valueForKeyPath:@"created_time"]];
        
        self.postedBy = [self checkForNULL:[[[dict valueForKeyPath:@"caption"] valueForKeyPath:@"from"] valueForKeyPath:@"full_name"]];
        
        self.commentsArray = [[dict valueForKey:@"comments"] valueForKey:@"data"];
        
        self.commentText = [self checkForNULL:[[dict valueForKeyPath:@"caption"] valueForKeyPath:@"text"]];
   }
    return self;
}

- (NSString *)locationNameString {
    return [self locationName];
}

- (void)dealloc {
    [commentsArray release];
    [commentText release];
    [super dealloc];
}

@end
