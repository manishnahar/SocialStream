//
//  YelpSocialStreamDetailViewController.m
//  SocialStreams
//
//  Created by ManishNaharMac on 31/08/12.
//
//

#import "YelpSocialStreamDetailViewController.h"
#import "YelpSocialStreamDataModel.h"

@interface YelpSocialStreamDetailViewController ()

@end

@implementation YelpSocialStreamDetailViewController

@synthesize reviewsArray;
@synthesize imageScrollView;
@synthesize reviews;
@synthesize ratingsImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(270, 10, 40, 20)] autorelease];
    imageView.image = [UIImage imageNamed:@"yelpLogo.png"];
    imageView.tag = 110;
    [self.navigationController.navigationBar addSubview:imageView];

    self.reviewsArray = [(YelpSocialStreamDataModel *)[self socialStreamDataModel] reviewsArray];

    [self.ratingsImageView loadImageFromURL:[NSURL URLWithString:[(YelpSocialStreamDataModel *)[self socialStreamDataModel] ratingImageUrl]]];
    
    [self loadScrollView];
    
    [[self reviews] reloadData];

}


- (void) loadScrollView {
    CGRect frame = CGRectZero;
    frame.size = self.imageScrollView.frame.size;
    
    AsyncImageView *imgView = [[AsyncImageView alloc] initWithFrame:frame];
    imgView.contentMode = UIViewContentModeCenter;
    NSString *strurl = [(YelpSocialStreamDataModel *)[self socialStreamDataModel] thumbnailUrl];
    if(!strurl)
    {
        imgView.image = [UIImage imageNamed:@"No Image.png"];
        [self.imageScrollView addSubview:imgView];
    }
    else
    {
       NSURL *url = [NSURL URLWithString:strurl];
       [imgView loadImageFromURL:url];
    }
    [self.imageScrollView addSubview:imgView];
    [imgView release];
    
    CGSize contentSize = self.imageScrollView.frame.size;
    contentSize.width *= 1;
    
    [self.imageScrollView setContentSize:contentSize];
    
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

- (CGFloat) heightForText:(NSString *)text {
    CGSize maximumLabelSize = CGSizeMake( [self reviews].frame.size.width, MAXFLOAT);
    CGSize expectedLabelSize = [text sizeWithFont:[UIFont systemFontOfSize:[UIFont labelFontSize]]
                                constrainedToSize:maximumLabelSize
                                    lineBreakMode:UILineBreakModeWordWrap];
    return expectedLabelSize.height;
}

#pragma mark - UITableViewDelegate
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self reviewsArray] count];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
/*    NSString *CellIdentifier = @"YelpSquareReviewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if( cell == nil ){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier:CellIdentifier] autorelease];
        [[cell textLabel] setFont:[UIFont systemFontOfSize:[UIFont labelFontSize]]];
        [[cell textLabel] setNumberOfLines:0];
    }
    
    NSDictionary *reviewDict = [[(YelpSocialStreamDataModel *)[self socialStreamDataModel] reviewsArray] objectAtIndex:indexPath.row];
    
    NSString *review = [reviewDict objectForKey:@"text_excerpt"];
    NSString *userName = [reviewDict objectForKey:@"user_name"];
    //NSString *date = [reviewDict objectForKey:@"date"];

    [[cell textLabel] setText:userName];
    
    CGRect textFrame = [[cell detailTextLabel] frame];
    textFrame.size.height = [self heightForText:review];
    [[cell detailTextLabel] setFrame:textFrame];
    [[cell detailTextLabel] setNumberOfLines:4];
    [[cell detailTextLabel] setText:review];
*/
    
    NSString *cellIdentifier = @"SocialStreamReviewsTableViewCell";
    
    SocialStreamReviewsTableViewCell *cell = (SocialStreamReviewsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"SocialStreamReviewsTableViewCell" owner:self options:nil];
        cell = self.reviewsCell;
        self.reviewsCell = nil;
    }
    
    NSDictionary *reviewDict = [[self reviewsArray] objectAtIndex:indexPath.row];

    //[cell setCellContent:[[self reviewsArray] objectAtIndex:indexPath.row]];
    [cell.reviewLabel setText:[reviewDict objectForKey:@"text_excerpt"]];
    [cell.dateTimeLabel setText:[self convertDateFormate:[reviewDict objectForKey:@"date"]]];
    [cell.userNameLabel setText:[reviewDict objectForKey:@"user_name"]];
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *review = [[[self reviewsArray] objectAtIndex:indexPath.row] objectForKey:@"text_excerpt"];
    return [self heightForText:review] + 30;
}

- (NSString*)convertDateFormate:(NSString *)inputStr
{
    NSDateFormatter *dateFormatter1 = [[[NSDateFormatter alloc] init] autorelease];
    dateFormatter1.dateFormat = @"yyyy-MM-dd";
    [dateFormatter1 setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *inputDate = [dateFormatter1 dateFromString:inputStr];
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	dateFormatter.dateFormat = @"eee, dd MMM yyyy h:mm a";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    return [dateFormatter stringFromDate:inputDate];
}

- (void) pageControlPage:(PageControl *)pageControl
    didSelectPageAtIndex:(NSUInteger)pageIndex {
    
}


@end
