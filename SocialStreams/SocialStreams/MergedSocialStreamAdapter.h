//
//  MergedSocialStreamAdapter.h
//  SocialStreams
//
//  Created by ManishNaharMac on 21/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocialStreamModel.h"

@protocol MergedSocialStreamAdapterProtocol;

@interface MergedSocialStreamAdapter : NSObject <SocialStreamModelProtocol> {
    NSMutableArray *socialStreamModelsArray;
    NSMutableArray *mergedSocialStreamData;
    NSMutableArray *socialStreamItemsArray;
    id <MergedSocialStreamAdapterProtocol> delegate;
}

@property (nonatomic, assign)     id <MergedSocialStreamAdapterProtocol> delegate;

- (NSUInteger) socialStreamModelsCount;

- (void) addSocialStreamModel:(SocialStreamModel *)socialStreamModel;
//- (void) removeSocialStreamModel:(SocialStreamModel *)socialStreamModel;

- (SocialStreamModel *) socialStreamModelAtIndex:(NSUInteger)index;
- (SocialStreamModel *) socialStreamModelOfType:(SocialStreamModelType)modelType;



- (void) changeLocation:(CLLocation *)location;
- (SocialStreamDetailViewController *) detailViewControllerForSocialStreamDataModel:(SocialStreamDataModel *)ssdm;
- (UITableViewCell *) tableViewCellForSocialStreamDataModel:(SocialStreamDataModel *)ssdm;
- (CGFloat) tableViewCellHeightForSocialStreamDataModel:(SocialStreamDataModel *)ssdm;



@end

@protocol MergedSocialStreamAdapterProtocol

- (void)socialStreamDataIsReceived:(NSArray *)socialStreamDataArray_;

@end