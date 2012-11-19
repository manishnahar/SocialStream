//
//  SettingViewController.m
//  SocialStreams
//
//  Created by ManishNaharMac on 17/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingViewController.h"
#import "MergedSocialStreamAdapter.h"
#import "AppDelegate.h"
@interface SettingViewController ()

@end

@implementation SettingViewController

@synthesize mergedSocialStreamAdapter;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Setting", @"SettingViewController");
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    UIBarButtonItem *backButton = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClicked:)] autorelease];
    
    self.navigationItem.leftBarButtonItem = backButton;

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
    return 4;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"SocialStreamSettingTableViewCell";
    
    SocialStreamSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if( cell == nil ){
        [[NSBundle mainBundle] loadNibNamed:@"SocialStreamSettingTableViewCell"
                                      owner:self
                                    options:nil];
        cell = socialStreamModelListTableViewCellCell;
    }
    if(indexPath.row == 0)
    {
        cell.socialStreamName.text= @"Yelp";
        cell.isSocialStreamUsed.tag = indexPath.row;
        [cell.isSocialStreamUsed setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"preferenceAllowYelpAPI"] animated:NO];
    }
    else if(indexPath.row == 1)
    {
        cell.socialStreamName.text= @"Twitter";
        cell.isSocialStreamUsed.tag = indexPath.row;
        [cell.isSocialStreamUsed setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"preferenceAllowTwitterAPI"] animated:NO];
    }
    else if(indexPath.row == 2)
    {
        cell.socialStreamName.text= @"Foursquare";
        cell.isSocialStreamUsed.tag = indexPath.row;
        [cell.isSocialStreamUsed setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"preferenceAllowFoursquareAPI"] animated:NO];
    }
    else if(indexPath.row == 3)
    {
        cell.socialStreamName.text= @"Instagram";
        cell.isSocialStreamUsed.tag = indexPath.row;
        [cell.isSocialStreamUsed setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"preferenceAllowInstgramAPI"] animated:NO];
    }
    
    [cell.isSocialStreamUsed addTarget:self action:@selector(settingViewSwitch:) forControlEvents:UIControlEventValueChanged];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UIButton
- (void)settingViewSwitch:(id)sender {
    UISwitch *_switch = (UISwitch *)sender;

    if(_switch.tag == 0)
    {
        [[NSUserDefaults standardUserDefaults] setBool:[_switch isOn] forKey:@"preferenceAllowYelpAPI"];
    }
    else if(_switch.tag == 1)
    {
        [[NSUserDefaults standardUserDefaults] setBool:[_switch isOn] forKey:@"preferenceAllowTwitterAPI"];
    }
    else if(_switch.tag == 2)
    {
        [[NSUserDefaults standardUserDefaults] setBool:[_switch isOn] forKey:@"preferenceAllowFoursquareAPI"];
    }
    else if(_switch.tag == 3)
    {
        [[NSUserDefaults standardUserDefaults] setBool:[_switch isOn] forKey:@"preferenceAllowInstgramAPI"];
    }
}

- (void)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    [socialStreamListTableView release];
    [mergedSocialStreamAdapter release];
    [socialStreamModelListTableViewCellCell release];
    [super dealloc];
}

@end
