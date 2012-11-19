//
//  UIView+Extensions.h
//
//  Created by Jeff Musa on 6/4/10.
//  Copyright 2010 One Moxie Ventures LLC.. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView (Extensions)
- (BOOL)findAndResignFirstResponder;
-(UIView *)findFirstResponder;
-(UIView *)findNextResponder;
-(UIView *)findPrevResponder;
-(UIView *)findViewWithTag:(int)_tag;
-(void)gotoNextResponder;
-(void)gotoPrevResponder;

@end;
