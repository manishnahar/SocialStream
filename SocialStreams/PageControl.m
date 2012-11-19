//
//  PageControl.m
//  timeRAZOR
//
//  Created by Rakesh on 05/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PageControl.h"

@interface PageControl ()

- (void) initialize;

@end

@implementation PageControl

@synthesize totalNoOfPages;
@synthesize currentPageNo;
@synthesize normalPageDotColor;
@synthesize currentPageDotColor;
@synthesize delegate;


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if( self != nil ){
        [self initialize];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if( self != nil ){
        [self initialize];
    }
    return self;
}

- (void) initialize {
    totalNoOfPages = 0;
    currentPageDotColor = 0;
    normalPageDotColor = [UIColor lightGrayColor];
    currentPageDotColor = [UIColor blackColor];
}

- (void) setCurrentPageNo:(NSUInteger)page {
    currentPageNo = MIN( page, totalNoOfPages-1);
    [self setNeedsDisplay];
}

- (void) setTotalNoOfPages:(NSUInteger)pages {
    totalNoOfPages = pages;
    [self setCurrentPageNo:currentPageNo];
}

- (void)drawRect:(CGRect)rect  {
    CGContextRef context = UIGraphicsGetCurrentContext();   
    CGContextSetAllowsAntialiasing(context, true);
    
    CGRect currentBounds = self.bounds;
    CGFloat dotsWidth = self.totalNoOfPages * DOT_DIAMETER + MAX(0, self.totalNoOfPages-1) * SPACE_BETWEEN_DOTS;
    CGFloat x = CGRectGetMidX(currentBounds) - dotsWidth / 2;
    CGFloat y = CGRectGetMidY(currentBounds) - DOT_DIAMETER/2;
    for (int i = 0; i < totalNoOfPages; i++ ) {
        CGRect circleRect = CGRectMake(x, y, DOT_DIAMETER, DOT_DIAMETER);
        if (i == currentPageNo ) {
            CGContextSetFillColorWithColor(context, self.currentPageDotColor.CGColor);
        }
        else {
            CGContextSetFillColorWithColor(context, self.normalPageDotColor.CGColor);
        }
        CGContextFillEllipseInRect(context, circleRect);
        x += DOT_DIAMETER + SPACE_BETWEEN_DOTS;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    if (!self.delegate) return;
    
    CGPoint touchPoint = [[[event touchesForView:self] anyObject] locationInView:self];
    
    CGFloat dotSpanX = self.totalNoOfPages * (DOT_DIAMETER + SPACE_BETWEEN_DOTS);
    CGFloat dotSpanY = DOT_DIAMETER + SPACE_BETWEEN_DOTS;
    
    CGRect currentBounds = self.bounds;
    CGFloat x = touchPoint.x + dotSpanX/2 - CGRectGetMidX(currentBounds);
    CGFloat y = touchPoint.y + dotSpanY/2 - CGRectGetMidY(currentBounds);
    
    if ((x<0) || (x>dotSpanX) || (y<0) || (y>dotSpanY)) return;
    
    [self setCurrentPageNo:floor(x/(DOT_DIAMETER+SPACE_BETWEEN_DOTS))];
    if (delegate != nil) {
        [self.delegate pageControlPage:self
                  didSelectPageAtIndex:currentPageNo];
    }
}


- (void) dealloc {
    [super dealloc];
}

@end
