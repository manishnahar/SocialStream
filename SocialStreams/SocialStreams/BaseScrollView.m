//
//  BaseScrollView.m
//  Created by Jeff Musa on 6/16/10.
//  Copyright 2010 timeRAZOR. All rights reserved.
//

#import "BaseScrollView.h"
#import "UIView+Extensions.h"

@interface BaseScrollView (PrivateMethods)
-(void)setup;
@end

@implementation BaseScrollView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
        [self setup];
	}
    return self;
}

-(void)awakeFromNib
{
    [self setup];
}

-(void)setup
{
    [self setCanCancelContentTouches:NO];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [tapRecognizer setCancelsTouchesInView:NO];
    [self addGestureRecognizer:tapRecognizer];
}

- (void)handleTap:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) 
    {
        [self performSelector:@selector(delayFindAndResignFirstResponder:) withObject:nil afterDelay:0.01f];
    }
}

-(void)delayFindAndResignFirstResponder:(NSObject *)nil_
{
    [self findAndResignFirstResponder];
}
@end
