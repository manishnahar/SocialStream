//
//  TwitterSocialStreamDetailViewController.m
//  SocialStreams
//
//  Created by ManishNaharMac on 07/09/12.
//
//

#import "TwitterSocialStreamDetailViewController.h"
#import "TwitterSocialStreamDataModel.h"

@interface TwitterSocialStreamDetailViewController ()

@end

@implementation TwitterSocialStreamDetailViewController
@synthesize imageScrollView;
@synthesize tweetsTableView;

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
    
    tweetsTextsArray = [[NSMutableArray alloc] init];
    imgesUrlArray = [[NSMutableArray alloc] init];
    
    for(TwitterSocialStreamDataModel *dataModel in [self tweetsDetailsArray]) {
        
        if([dataModel.mediaArray count]) {
            [imgesUrlArray addObjectsFromArray:dataModel.mediaArray];
        }
        
        if([dataModel.tweetText length]) {
            [tweetsTextsArray addObject:dataModel.tweetText];
        }
    }
    
    [self loadScrollView];
    [[self tweetsTableView] reloadData];
}

- (void)viewDidUnload
{
    [self setImageScrollView:nil];
    [self setTweetsTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [imageScrollView release];
    [tweetsTableView release];
    
    [super dealloc];
}

- (void) loadScrollView {
    CGRect frame = CGRectZero;
    frame.size = self.imageScrollView.frame.size;
    
//    TwitterSocialStreamDataModel *dataModel = (TwitterSocialStreamDataModel *)self.socialStreamDataModel;
    NSUInteger imageCount = [imgesUrlArray count];
    if(!imageCount)
    {
        AsyncImageView *imgView = [[AsyncImageView alloc] initWithFrame:self.imageScrollView.frame];
        imgView.image = [UIImage imageNamed:@"No Image.png"];
        [self.imageScrollView addSubview:imgView];
        [imgView release];
    }
    else
    {
        asynImgArray = [[NSMutableArray alloc] init];
        for ( NSInteger i = 0; i < imageCount; i++ ) {
            frame.origin.x = i * frame.size.width;
            AsyncImageView *imgView = [[AsyncImageView alloc] initWithFrame:frame];
            [self.imageScrollView addSubview:imgView];
            [asynImgArray addObject:imgView];
            [imgView release];
        }
        
        CGSize contentSize = self.imageScrollView.frame.size;
        contentSize.width *= imageCount;
        [[self pageControl] setTotalNoOfPages:imageCount];
        [[self pageControl] setCurrentPageNo:0];
        
        [self loadImageAtindex:0];
        
        [self.imageScrollView setContentSize:contentSize];
    }
}

- (void) loadImageAtindex:(NSUInteger)index {
    NSUInteger imageCount = [imgesUrlArray count];
    if( index < imageCount ){
        NSString *strurl = [[imgesUrlArray objectAtIndex:index] objectForKey:@"media_url"];
        NSURL *url = [NSURL URLWithString:strurl];
        AsyncImageView *imgView = [asynImgArray objectAtIndex:index];
        if( [imgView image] == nil ){
            [imgView loadImageFromURL:url];
        }
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [tweetsTextsArray count];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*NSString *CellIdentifier = @"FourSquareReviewCell";
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     if( cell == nil ){
     cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
     reuseIdentifier:CellIdentifier] autorelease];
     [[cell textLabel] setFont:[UIFont systemFontOfSize:[UIFont labelFontSize]]];
     [[cell textLabel] setNumberOfLines:0];
     }
     
     NSString *review = [[(FoursquareSocialStreamDataModel *)[self socialStreamDataModel] tipsArray] objectAtIndex:indexPath.row];
     CGRect textFrame = [[cell textLabel] frame];
     textFrame.size.height = [self heightForText:review];
     [[cell textLabel] setFrame:textFrame];
     [[cell textLabel] setText:review];
     */
    NSString *cellIdentifier = @"SocialStreamReviewsTableViewCell";
    
    SocialStreamReviewsTableViewCell *cell = (SocialStreamReviewsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"SocialStreamReviewsTableViewCell" owner:self options:nil];
        cell = self.reviewsCell;
        self.reviewsCell = nil;
    }
    
    NSString *tweetText = [tweetsTextsArray objectAtIndex:indexPath.row];
    
    //[cell setCellContent:[[self reviewsArray] objectAtIndex:indexPath.row]];
    [cell.reviewLabel setText:tweetText];
    [cell.dateTimeLabel setText:[(TwitterSocialStreamDataModel *)[[self tweetsDetailsArray] objectAtIndex:indexPath.row] createdTime]];
    [cell.userNameLabel setText:[(TwitterSocialStreamDataModel *)[[self tweetsDetailsArray] objectAtIndex:indexPath.row] fromUserName]];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        NSString *review = [tweetsTextsArray objectAtIndex:indexPath.row];
    return [self heightForText:review] + 20;
}

- (CGFloat) heightForText:(NSString *)text {
    CGSize maximumLabelSize = CGSizeMake( [self tweetsTableView].frame.size.width, MAXFLOAT);
    CGSize expectedLabelSize = [text sizeWithFont:[UIFont systemFontOfSize:[UIFont labelFontSize]]
                                constrainedToSize:maximumLabelSize
                                    lineBreakMode:UILineBreakModeWordWrap];
    return expectedLabelSize.height;
}

- (void) pageControlPage:(PageControl *)pageControl
    didSelectPageAtIndex:(NSUInteger)pageIndex {
    [self loadPage:pageIndex];
}


#pragma mark - UIScrollViewDelegate
- (void) scrollViewDidEndDecelerating:(UIScrollView *)inScrollView {
    CGFloat scrollViewWidth = [inScrollView frame].size.width;
    CGPoint contentOffSet = [inScrollView contentOffset];
    
    NSUInteger index = (NSUInteger)(contentOffSet.x / scrollViewWidth);
    [self loadImageAtindex:index];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView_ {
    CGFloat scrollViewWidth = [scrollView_ frame].size.width;
    CGPoint contentOffSet = [scrollView_ contentOffset];
    NSUInteger index = (NSUInteger)(((float)contentOffSet.x / (float)scrollViewWidth) + 0.5f);
    [self loadImageAtindex:index];
    
    [[self pageControl] setCurrentPageNo:index];
    
}

-(void)loadPage:(int)pageIndex
{
    CGFloat xContentOffSet = pageIndex * [self.imageScrollView frame].size.width;
    CGPoint contentOffset = [self.imageScrollView contentOffset];
    contentOffset.x = xContentOffSet;
    [self.imageScrollView setContentOffset:contentOffset
                                  animated:YES];
    
    //[self.pageControl setCurrentPageNo:pageIndex];
}


@end
