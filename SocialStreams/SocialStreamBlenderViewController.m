//
//  SocialStreamBlenderViewController.m
//  SocialStreams
//
//  Created by ManishNaharMac on 30/08/12.
//
//

#import "SocialStreamBlenderViewController.h"
#import "SocialStreamsTableViewController.h"

#import "InstagramSocialStreamModel.h"
#import "FoursquareSocialStreamModel.h"
#import "TwitterSocialStreamModel.h"
#import "SettingViewController.h"
//#import "AppDelegate.h"

NSString * const instaGramClientID           = @"35b29f23b8064448a865a764126ff938";
NSString * const instaGramClientSecretKey    = @"6b7eebc8d6db45e8b8847762d63c509a";

@interface SocialStreamBlenderViewController ()

@end

@implementation SocialStreamBlenderViewController
@synthesize longitudeTextField;
@synthesize latitudeTextField;
@synthesize venueNameTextField;
@synthesize twitterHashTextField;
@synthesize instgramHashTextField;
@synthesize yelpPhoneNumberTextField;

//@synthesize mergedSocialStreamAdapter;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"preferenceAllowYelpAPI"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"preferenceAllowTwitterAPI"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"preferenceAllowFoursquareAPI"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"preferenceAllowInstgramAPI"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Social Stream Blender";
}

- (void)viewDidUnload
{
    [self setLongitudeTextField:nil];
    [self setLatitudeTextField:nil];
    [self setVenueNameTextField:nil];
    [self setTwitterHashTextField:nil];
    [self setInstgramHashTextField:nil];
    [self setYelpPhoneNumberTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
   
    [longitudeTextField release];
    [latitudeTextField release];
    [venueNameTextField release];
    [twitterHashTextField release];
    [instgramHashTextField release];
    [yelpPhoneNumberTextField release];
    [mergedSocialStreamAdapter release];
    
    [super dealloc];
}

-(IBAction)settingButtonClicked:(id)sender {
    SettingViewController *settingViewController = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    [self.navigationController pushViewController:settingViewController animated:YES];
    [settingViewController release];
}

- (IBAction)searchButtonClicked:(id)sender {

    [self setUpMeargedAdapter];
    
    SocialStreamsTableViewController *viewController1 = [[[SocialStreamsTableViewController alloc] initWithNibName:@"SocialStreamsTableViewController" bundle:nil] autorelease];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[latitudeTextField.text doubleValue] longitude:[longitudeTextField.text doubleValue]];
    [viewController1 setLocation:location];
    [location release];
    
    [viewController1 setMergedSocialStreamAdapter:mergedSocialStreamAdapter];
    [self.navigationController pushViewController:viewController1 animated:YES];
}

- (void)setUpMeargedAdapter {
    
    
    NSDictionary *_instagramCredentials = [NSDictionary dictionaryWithObjectsAndKeys:@"self", @"User_Id", instaGramClientID, @"Client_Id", nil];
    
    if(mergedSocialStreamAdapter) {
        [mergedSocialStreamAdapter release];
        mergedSocialStreamAdapter = nil;
    }
    
    mergedSocialStreamAdapter = [[MergedSocialStreamAdapter alloc] init];
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"preferenceAllowFoursquareAPI"])
    {
        SocialStreamModel *fourSquareSocialModel = [SocialStreamModel fourSquareSocialModelWithCredentials:nil];
        fourSquareSocialModel.venueName = venueNameTextField.text;
        [mergedSocialStreamAdapter addSocialStreamModel:fourSquareSocialModel];
    }
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"preferenceAllowInstgramAPI"])
    {
        SocialStreamModel * instgramSocialModel = [SocialStreamModel instagramSocialStreamModelWithCredentials:_instagramCredentials];
        instgramSocialModel.hashTag = instgramHashTextField.text;
        instgramSocialModel.venueName = venueNameTextField.text;
        [mergedSocialStreamAdapter addSocialStreamModel:instgramSocialModel];
    }
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"preferenceAllowTwitterAPI"])
    {
        SocialStreamModel * twitterSocialModel = [SocialStreamModel twitterSocialModelWithCredentials:nil];
        twitterSocialModel.hashTag = twitterHashTextField.text;
        twitterSocialModel.venueName = venueNameTextField.text;
        [mergedSocialStreamAdapter addSocialStreamModel:twitterSocialModel];
    }
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"preferenceAllowYelpAPI"])
    {
        SocialStreamModel * yelpSocialModel = [SocialStreamModel yelpSocialModelWithCredentials:nil];
        yelpSocialModel.phoneNumber = yelpPhoneNumberTextField.text;
        yelpSocialModel.venueName = venueNameTextField.text;
        [mergedSocialStreamAdapter addSocialStreamModel:yelpSocialModel];
    }
}

#pragma mark TextField Delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ( [textField returnKeyType] == UIReturnKeyGo )
        [self performSelector:@selector(searchButtonClicked:) withObject:nil afterDelay:0.01f];
    else
        return [super textFieldShouldReturn:textField];
    
    return YES;
}
@end
