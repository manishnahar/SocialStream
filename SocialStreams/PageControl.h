//
//  PageControl.h
//  timeRAZOR
//
//  Created by Rakesh on 05/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DOT_DIAMETER        7.0f
#define SPACE_BETWEEN_DOTS  7.0f

@protocol PageControlDelegate;

@interface PageControl : UIView {
    NSUInteger totalNoOfPages;
    NSUInteger currentPageNo;
    
    UIColor *normalPageDotColor;
    UIColor *currentPageDotColor;
    
}
@property (nonatomic, assign) NSUInteger totalNoOfPages;
@property (nonatomic, assign) NSUInteger currentPageNo;
@property (nonatomic, retain) UIColor *normalPageDotColor;
@property (nonatomic, retain) UIColor *currentPageDotColor;
@property (nonatomic, unsafe_unretained) id<PageControlDelegate> delegate;

@end

@protocol PageControlDelegate <NSObject>

- (void) pageControlPage:(PageControl *)pageControl
    didSelectPageAtIndex:(NSUInteger)pageIndex;

@end
