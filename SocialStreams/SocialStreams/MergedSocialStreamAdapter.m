//
//  MergedSocialStreamAdapter.m
//  SocialStreams
//
//  Created by ManishNaharMac on 21/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MergedSocialStreamAdapter.h"

@interface MergedSocialStreamAdapter()

- (NSMutableArray *) socialStreamModelsArray;
- (NSMutableArray *) socialStreamItemsArray;

@end

@implementation MergedSocialStreamAdapter

@synthesize delegate;

- (NSUInteger) socialStreamModelsCount {
    return [[self socialStreamModelsArray] count];
}

- (SocialStreamModel *)socialStreamModelAtIndex:(NSUInteger)index {
    SocialStreamModel *returnModel = nil;
    
    if( index < [self socialStreamModelsCount] ){
        returnModel = [[self socialStreamModelsArray] objectAtIndex:index];
    }
    
    return returnModel;
}

- (SocialStreamModel *) socialStreamModelOfType:(SocialStreamModelType)modelType {
    SocialStreamModel *returnModel = nil;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.modelType == %d",modelType];
    NSArray *fileterdeArray = [[self socialStreamModelsArray] filteredArrayUsingPredicate:predicate];
    if( [fileterdeArray count] >= 1 ){
        returnModel = [fileterdeArray objectAtIndex:0];
    }
    
    return returnModel;
}

- (void) addSocialStreamModel:(SocialStreamModel *)socialStreamModel {
    socialStreamModel.delegate = self;
        //Check for multiple entries for same type of model -- missing
    [[self socialStreamModelsArray] addObject:socialStreamModel];
}

//- (void) removeSocialStreamModel:(SocialStreamModel *)socialStreamModel {
//    [[self socialStreamModelsArray] removeObject:socialStreamModel];
//}

- (void) changeLocation:(CLLocation *)location {
    for ( SocialStreamModel *socialStream in [self socialStreamModelsArray] ){
        //[socialStream changeLocation:location];
        [socialStream setLocation:location];
        [socialStream getSocialStreamDataWithLocation:location];
    }
}


- (SocialStreamDetailViewController *) detailViewControllerForSocialStreamDataModel:(SocialStreamDataModel *)ssdm {
    SocialStreamModel *model = [self socialStreamModelOfType:ssdm.modelType];
    SocialStreamDetailViewController *detailViewController = nil;
    
    if( model != nil ) {
        detailViewController = [model detailViewControllerForDataModel:ssdm];
    }
    
    return detailViewController;
}

- (UITableViewCell *) tableViewCellForSocialStreamDataModel:(SocialStreamDataModel *)ssdm {
    SocialStreamModel *model = [self socialStreamModelOfType:ssdm.modelType];
    UITableViewCell *socialStreamModelTableviewCell = nil;
    
    if( model != nil ) {
        socialStreamModelTableviewCell = [model tableViewCellForSocialStreamDataModel:ssdm];
    }
    
    return socialStreamModelTableviewCell;
}

- (CGFloat) tableViewCellHeightForSocialStreamDataModel:(SocialStreamDataModel *)ssdm {
    SocialStreamModel *model = [self socialStreamModelOfType:ssdm.modelType];
    CGFloat socialStreamModelTableviewCellHeight = 0.0f;
    
    if( model != nil ) {
        socialStreamModelTableviewCellHeight = [model tableViewCellHeightForSocialStreamDataModel:ssdm];
    }
    
    return (socialStreamModelTableviewCellHeight > 80 ? socialStreamModelTableviewCellHeight : 80);
}

#pragma mark - Private
- (NSMutableArray *) socialStreamModelsArray {
    if( socialStreamModelsArray == nil ){
        socialStreamModelsArray = [[NSMutableArray alloc] init];
    }
    return socialStreamModelsArray;
}

- (void) dealloc {
    [socialStreamModelsArray release];
    socialStreamModelsArray = nil;
    [super dealloc];
}

- (NSMutableArray *) socialStreamItemsArray {
    if( socialStreamItemsArray == nil ){
        socialStreamItemsArray = [[NSMutableArray alloc] init];
    }
    return socialStreamItemsArray;
}

#pragma mark - SocialStreamModelProtocol

- (void)socialStreamModelIsFinished:(NSArray *)itemsArray_ {
    [[self socialStreamItemsArray] addObjectsFromArray:itemsArray_];
    
    [delegate socialStreamDataIsReceived:itemsArray_];
}

@end
