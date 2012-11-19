//
//  ScrollableViewController.h
//  timeRAZOR
//
//  Created by Jeff Musa on 12-01-26.
//  Copyright (c) 2012 timeRAZOR. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseScrollView;
@interface ScrollableViewController : UIViewController <UITextFieldDelegate>
{
}
@property (nonatomic, assign) IBOutlet BaseScrollView *scrollView;
@property (nonatomic, assign) UITextField *focusField;

-(void)registerForEditingEvents:(UIControl*)aControl;
-(void)scrollIntoView;
-(BOOL)textFieldShouldReturn:(UITextField *)textField;
-(void)textFieldDidEndEditing:(UITextField *)textField;
-(void)textFieldDidBeginEditing:(UITextField *)textField;

-(void)keyboardDidHide:(NSNotification*)aNotification;
-(void)keyboardWillHide:(NSNotification*)aNotification;
-(void)keyboardDidShow:(NSNotification*)aNotification;

@end
