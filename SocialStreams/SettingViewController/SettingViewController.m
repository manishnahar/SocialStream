//
//  SecondViewController.m
//  SocialStreams
//
//  Created by ManishNaharMac on 17/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SecondViewController.h"
#import "MergedSocialStreamAdapter.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

@synthesize mergedSocialStreamAdapter;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Second", @"Second");
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [socialStreamListTableView release];
    socialStreamListTableView = nil;
    [socialStreamModelListTableViewCellCell release];
    socialStreamModelListTableViewCellCell = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [mergedSocialStreamAdapter socialStreamModelsCount];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"SocialStreamModelListTableViewCellCell";
    
    SocialStreamModelListTableViewCellCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if( cell == nil ){
        [[NSBundle mainBundle] loadNibNamed:@"SocialStreamModelListTableViewCellCell"
                                      owner:self
                                    options:nil];
        cell = socialStreamModelListTableViewCellCell;
    }
    
    SocialStreamModel *model = [mergedSocialStreamAdapter socialStreamModelAtIndex:[indexPath row]];
    [[cell socialStreamName] setText:[model name]];
    [[cell isSocialStreamUsed] setOn:[model hasUserAllowedToUseSocialServiceModel]]; 
    [[cell isSocialStreamUsed] setTag:[indexPath row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UIButton
- (IBAction)socialStreamSelectionValueChanged:(id)sender {
    SocialStreamModel *model = [mergedSocialStreamAdapter socialStreamModelAtIndex:[sender tag]];
    UISwitch *_switch = (UISwitch *)sender;
    if( [_switch isOn] == YES &&  [model requiresUserAuthentication] == YES ){
        if( [model isUserAuthenticated] == NO ){
            [model authenticate];
        }
    }
}


- (void)dealloc {
    [socialStreamListTableView release];
    [mergedSocialStreamAdapter release];
    [socialStreamModelListTableViewCellCell release];
    [super dealloc];
}

@end
