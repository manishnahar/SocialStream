//
//  SocialStreamsTableViewController.m
//  SocialStreams
//
//  Created by ManishNaharMac on 29/08/12.
//
//

#import "SocialStreamsTableViewController.h"
#import "TwitterSocialStreamTableViewCell.h"

@interface SocialStreamsTableViewController ()
- (NSMutableArray *) socialStreamDataArray;

@end

@implementation SocialStreamsTableViewController

@synthesize mergedSocialStreamAdapter;
@synthesize location;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *backButton = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClicked:)] autorelease];
    
    self.navigationItem.leftBarButtonItem = backButton;

    //CLLocation *location = [[CLLocation alloc] initWithLatitude:38.900251 longitude:-77.035961];
    
    mergedSocialStreamAdapter.delegate = self;
    [mergedSocialStreamAdapter changeLocation:location];
    //[location release]; location = nil;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIView *imageView = [self.navigationController.navigationBar viewWithTag:110];
    if(imageView) {
        [imageView removeFromSuperview];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSInteger rows = [[self socialStreamDataArray] count];
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SocialStreamDataModel *dataModel = [[self socialStreamDataArray] objectAtIndex:indexPath.row];
    SocialStreamModel *socialStreamModel = [mergedSocialStreamAdapter socialStreamModelOfType:dataModel.modelType];
    
    NSString *cellIdentifier = [socialStreamModel name];
    
    SocialStreamTableViewCell *cell = (SocialStreamTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = (SocialStreamTableViewCell*)[mergedSocialStreamAdapter tableViewCellForSocialStreamDataModel:dataModel];
    }
    
    [cell setCellContent:dataModel];

    
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SocialStreamDataModel *dataModel = [[self socialStreamDataArray] objectAtIndex:indexPath.row];
    return [mergedSocialStreamAdapter tableViewCellHeightForSocialStreamDataModel:dataModel];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    if ([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[TwitterSocialStreamTableViewCell class]]) {
        ((TwitterSocialStreamTableViewCell *)[tableView cellForRowAtIndexPath:indexPath]).twitterPost.userInteractionEnabled = YES;
    }
    SocialStreamDataModel *ssdm = [[self socialStreamDataArray] objectAtIndex:indexPath.row];
    
    SocialStreamDetailViewController *socialStreamDetailViewController = [mergedSocialStreamAdapter detailViewControllerForSocialStreamDataModel:ssdm];
    
    if(ssdm.modelType == kTwitterSocialStreamModel) {
        NSArray *tweetsDataArray = [[self socialStreamDataArray] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            
            SocialStreamDataModel *tempModel = (SocialStreamDataModel *)evaluatedObject;
            if(tempModel.modelType == kTwitterSocialStreamModel) {
                return YES;
            }else {
                return NO;
            }
        }]];
        socialStreamDetailViewController.tweetsDetailsArray = tweetsDataArray;
    }

    [[self navigationController] pushViewController:socialStreamDetailViewController animated:YES];

}

#pragma mark - MergedSocialStreamAdapterProtocol Method
- (void)socialStreamDataIsReceived:(NSArray *)socialStreamDataArray_ {
    [[self socialStreamDataArray] addObjectsFromArray:socialStreamDataArray_];
    [self.tableView reloadData];
}

- (NSMutableArray *) socialStreamDataArray {
    if( socialStreamDataArray == nil ){
        socialStreamDataArray = [[NSMutableArray alloc] init];
    }
    return socialStreamDataArray;
}

- (void)dealloc {
    mergedSocialStreamAdapter.delegate = nil;
    [mergedSocialStreamAdapter release];
    [location release];
    location = nil;
    [super dealloc];
}

- (void)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
