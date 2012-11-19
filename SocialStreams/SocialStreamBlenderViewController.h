//
//  SocialStreamBlenderViewController.h
//  SocialStreams
//
//  Created by ManishNaharMac on 30/08/12.
//
//

#import <UIKit/UIKit.h>
#import "MergedSocialStreamAdapter.h"
//#import "AppDelegate.h"
#import "ScrollableViewController.h"

@interface SocialStreamBlenderViewController : ScrollableViewController {
    MergedSocialStreamAdapter *mergedSocialStreamAdapter;
}

@property (retain, nonatomic) IBOutlet UITextField *longitudeTextField;
@property (retain, nonatomic) IBOutlet UITextField *latitudeTextField;
@property (retain, nonatomic) IBOutlet UITextField *venueNameTextField;
@property (retain, nonatomic) IBOutlet UITextField *twitterHashTextField;
@property (retain, nonatomic) IBOutlet UITextField *instgramHashTextField;
@property (retain, nonatomic) IBOutlet UITextField *yelpPhoneNumberTextField;

//@property (nonatomic, retain) MergedSocialStreamAdapter *mergedSocialStreamAdapter;

- (IBAction)searchButtonClicked:(id)sender;
- (IBAction)settingButtonClicked:(id)sender;

@end
