//
//  ScrollableViewController.m
//  timeRAZOR
//
//  Created by Jeff Musa on 12-01-26.
//  Copyright (c) 2012 timeRAZOR. All rights reserved.
//

#import "ScrollableViewController.h"
#import "BaseScrollView.h"

@interface ScrollableViewController (PrivateMethods)
-(void)unregisterKeyboardNotifications;
-(void)registerForKeyboardNotifications;
@end

@implementation ScrollableViewController
@synthesize scrollView=scrollView_, focusField=focusField_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad )
        return YES;
    else
        return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CGSize size = [[self view] bounds].size;
    CGPoint scrollViewOrigin = [[self scrollView] frame].origin;
    size.width -= scrollViewOrigin.x;
    size.height -= scrollViewOrigin.y;
    [[self scrollView] setBounds:CGRectMake(0, 0, size.width, size.height)];
	[[self scrollView] setContentSize:size];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self registerForKeyboardNotifications];
    [super viewDidAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self unregisterKeyboardNotifications];
    [super viewWillDisappear:animated];
}

#pragma mark Keyboard management
-(void)unregisterKeyboardNotifications
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];

}

- (void)registerForKeyboardNotifications  {
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardDidShow:)
												 name:UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillHide:)
												 name:UIKeyboardWillHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardDidHide:)
												 name:UIKeyboardDidHideNotification object:nil];
}

-(void)scrollIntoView
{
    /*
     UIEdgeInsets e = [[self scrollView] contentInset];
     CGRect aRect = [[self scrollView] bounds];
     
     aRect = CGRectMake(aRect.origin.x - e.left, aRect.origin.y - e.top, aRect.size.width - e.right, aRect.size.height - e.bottom);
     CGPoint aPoint = [self focusField].frame.origin;
     aPoint.y += [self focusField].frame.size.height;
     if (!CGRectContainsPoint(aRect, aPoint) ) {
     CGPoint scrollPoint = CGPointMake(0.0, aPoint.y-aRect.size.height);
     DPLog(@"set offset x: %f y: %f]", scrollPoint.x, scrollPoint.y);
     [[self scrollView] setContentOffset:scrollPoint animated:YES];
     }
     */
    [[self scrollView] scrollRectToVisible:[[self focusField] frame] animated:YES];
}
- (void)keyboardDidShow:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
	CGRect kbRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	kbRect = [[self view] convertRect:kbRect fromView:nil];
    CGSize kbSize = kbRect.size;
	CGRect myViewRect = [[self view] frame];
    //	myViewRect = [[self view] convertRect:myViewRect toView:nil];
	kbRect = CGRectIntersection(myViewRect, kbRect);
	kbSize = kbRect.size;
	
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    [[self scrollView] setContentInset:contentInsets];
    [[self scrollView] setScrollIndicatorInsets:contentInsets];
	
    // If active text field is hidden by keyboard, scroll it so it's visible
    CGRect aRect = [[self scrollView] bounds];
    aRect.size.height -= kbSize.height;
	
    [self scrollIntoView];
    /*
     CGPoint aPoint = [self focusField].frame.origin;
     aPoint.y += [self focusField].frame.size.height;
     if (!CGRectContainsPoint(aRect, aPoint) ) {
     CGPoint scrollPoint = CGPointMake(0.0, aPoint.y-aRect.size.height);
     [[self scrollView] setContentOffset:scrollPoint animated:YES];
     }
     */
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillHide:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
	NSDictionary* uInfo = [aNotification userInfo];
    
	NSValue *animationDurationValue = [uInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:animationDuration];
	
	
    [[self scrollView] setContentInset:contentInsets];
    [[self scrollView] setScrollIndicatorInsets:contentInsets];
	
	[UIView commitAnimations];
}

- (void)keyboardDidHide:(NSNotification*)aNotification
{
    
}

#pragma mark TextField Delegate methods

-(void)nextResponder:(NSObject *)nil_
{
    [[self scrollView] gotoNextResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ( [textField returnKeyType] == UIReturnKeyNext)
    {
        [self performSelector:@selector(nextResponder:) withObject:nil afterDelay:0.01f];
    }
    else
        [textField resignFirstResponder];
    return YES;
}

- (void)registerForEditingEvents:(UIControl*)aControl{
	[aControl addTarget:self action:@selector(textFieldDidBeginEditing:) 
	   forControlEvents:UIControlEventEditingDidBegin];
	[aControl addTarget:self action:@selector(textFieldDidEndEditing:)
	   forControlEvents:UIControlEventEditingDidEnd];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self setFocusField:nil];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self setFocusField:textField];
    [self scrollIntoView];
}

@end
