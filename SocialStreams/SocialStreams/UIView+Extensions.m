//
//  UIView+Extensions.m
//
//  Created by Jeff Musa on 6/4/10.
//  Copyright 2010 One Moxie Ventures, Inc.. All rights reserved.
//

#import "UIView+Extensions.h"

@implementation UIView (Extensions)
- (BOOL)findAndResignFirstResponder
{
    if (self.isFirstResponder) {
        [self resignFirstResponder];
        return YES;     
    }
    for (UIView *subView in [self subviews]) {
		if (([subView isEqual:self] == NO ) && ([subView findAndResignFirstResponder]))
			return YES;
    }
    return NO;
}

-(UIView *)findFirstResponder
{
	if ( [self isFirstResponder] ) return self;

    for (UIView *subView in [self subviews]) {
		if (([subView isEqual:self] == NO ) && ([subView findFirstResponder]))
			return subView;
    }
	return nil;
}

-(UIView *)findViewWithTag:(int)_findTag
{
    for (UIView *subView in [self subviews]) {
		if ( [subView tag] == _findTag )
			return subView;
    }
	return nil;
}

-(UIView *)findNextResponder
{

	UIView *first = [self findFirstResponder];
	int tag = [first tag];
	int topTag = 0;
	
    for (UIView *subView in [self subviews])
	{
		if ([subView isHidden] == NO )
			topTag = MAX(topTag, [subView tag]);
	}
	if ( topTag < 1 ) return nil;
	
	tag = MIN(topTag, tag + 1);
	
	return [self findViewWithTag:tag];
}
						 
-(UIView *)findPrevResponder
{
	UIView *first = [self findFirstResponder];
	int tag = [first tag];
	int minTag = 1;
	
    for (UIView *subView in [self subviews])
	{
		if ( [subView isHidden] == NO)
		{
			if ( [subView tag] > 0 )
				minTag = MIN(minTag, [subView tag]);
		}
	}
	if ( minTag < 1 ) return nil;
	
	tag = MAX(minTag, tag - 1);

	return [self findViewWithTag:tag];
}

-(void)gotoNextResponder
{
	UIView *v = [self findNextResponder];
	if ( [v respondsToSelector:@selector(becomeFirstResponder)] )
		[v becomeFirstResponder];
}

-(void)gotoPrevResponder
{
	UIView *v = [self findPrevResponder];
	if ( [v respondsToSelector:@selector(becomeFirstResponder)] )
		[v becomeFirstResponder];
}
@end