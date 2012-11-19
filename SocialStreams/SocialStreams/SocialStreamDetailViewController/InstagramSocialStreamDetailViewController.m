//
//  InstagramSocialStreamDetailViewController.m
//  SocialStreams
//
//  Created by ManishNaharMac on 22/08/12.
//
//

#import "InstagramSocialStreamDetailViewController.h"
#import "InstaGramSocialStreamDataModel.h"

@implementation InstagramSocialStreamDetailViewController

@synthesize imageScrollView;
@synthesize commentsTableView;
@synthesize commentsArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [commentsTableView release];
    [imageScrollView release];
    
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(290, 10, 20, 20)] autorelease];
    imageView.image = [UIImage imageNamed:@"instagram.png"];
    imageView.tag = 110;
    [self.navigationController.navigationBar addSubview:imageView];
    
    self.commentsArray = [(InstaGramSocialStreamDataModel *)[self socialStreamDataModel] commentsArray];
    [self.likes setText:[NSString stringWithFormat:@"%d of Likes",[(InstaGramSocialStreamDataModel *)[self socialStreamDataModel] likes]]];

    [self loadScrollView];
    [[self commentsTableView] reloadData];
    
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
    NSInteger rows = [[self commentsArray] count];
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    NSString *cellIdentifier = @"SocialStreamReviewsTableViewCell";
    
    SocialStreamReviewsTableViewCell *cell = (SocialStreamReviewsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"SocialStreamReviewsTableViewCell" owner:self options:nil];
        cell = self.reviewsCell;
        self.reviewsCell = nil;
    }
    
//    [cell setCellContent:[[self commentsArray] objectAtIndex:indexPath.row]];
    
    NSDictionary *dict = [[self commentsArray] objectAtIndex:indexPath.row];
    [[cell userNameLabel] setText:[[dict objectForKey:@"from"] objectForKey:@"full_name"]];
    [[cell dateTimeLabel] setText:[Utility timeString:[dict objectForKey:@"created_time"]]];
    [[cell reviewLabel] setText:[dict objectForKey:@"text"]];

    // Configure the cell...
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSString *review = [[[(InstaGramSocialStreamDataModel *)[self socialStreamDataModel] commentsArray] objectAtIndex:indexPath.row] objectForKey:@"text"];
    return 80;//[self heightForText:review] + 30;
}

- (CGFloat) heightForText:(NSString *)text {
    CGSize maximumLabelSize = CGSizeMake( [self commentsTableView].frame.size.width, MAXFLOAT);
    CGSize expectedLabelSize = [text sizeWithFont:[UIFont systemFontOfSize:[UIFont labelFontSize]]
                                constrainedToSize:maximumLabelSize
                                    lineBreakMode:UILineBreakModeWordWrap];
    return expectedLabelSize.height ;
}

- (void) loadScrollView {
    CGRect frame = CGRectZero;
    frame.size = self.imageScrollView.frame.size;

    AsyncImageView *imgView = [[AsyncImageView alloc] initWithFrame:frame];
    NSString *strurl = [(InstaGramSocialStreamDataModel *)[self socialStreamDataModel] standardUrl];
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
    //[asynImgArray addObject:imgView];
    [imgView release];

    CGSize contentSize = self.imageScrollView.frame.size;
    contentSize.width *= 1;
        
    [self.imageScrollView setContentSize:contentSize];
}

- (void) pageControlPage:(PageControl *)pageControl
    didSelectPageAtIndex:(NSUInteger)pageIndex {
    
}

@end
