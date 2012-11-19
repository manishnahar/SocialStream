//
//  FourSquareSocialStreamDetailViewController.m
//  SocialStreams
//
//  Created by ManishNaharMac on 23/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FourSquareSocialStreamDetailViewController.h"
#import "FoursquareSocialStreamDataModel.h"

@interface FourSquareSocialStreamDetailViewController ()

- (void) setUpView;
- (void) loadScrollView;
- (void) loadImageAtindex:(NSUInteger)index;
- (CGFloat) heightForText:(NSString *)text;

@end

@implementation FourSquareSocialStreamDetailViewController

@synthesize reviews = _reviews;
@synthesize imageScrollView = _imageScrollView;
@synthesize tipsArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(290, 10, 20, 20)] autorelease];
    imageView.image = [UIImage imageNamed:@"FourSquare.png"];
    imageView.tag = 110;
    [self.navigationController.navigationBar addSubview:imageView];

    if( [[self socialStreamDataModel] fetchDetails] == NO ){
        [self setUpView];
    }
}

- (void) setUpView {
    self.tipsArray = [(FoursquareSocialStreamDataModel *)[self socialStreamDataModel] tipsArray];
    [self.likes setText:[NSString stringWithFormat:@"%d of Likes",[(FoursquareSocialStreamDataModel *)[self socialStreamDataModel] likes]]];

    [self loadScrollView];
    [[self reviews] reloadData];
}

- (void)viewDidUnload
{
    [_reviews release];
    _reviews = nil;
    [_imageScrollView release];
    _imageScrollView = nil;
    [super viewDidUnload];
}

#pragma mark - Private
- (void) loadScrollView {
    CGRect frame = CGRectZero;
    frame.size = self.imageScrollView.frame.size;
    
    FoursquareSocialStreamDataModel *dataModel = (FoursquareSocialStreamDataModel *)self.socialStreamDataModel;
    NSUInteger imageCount = [[dataModel photosUrlArray] count];
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
    NSUInteger imageCount = [[(FoursquareSocialStreamDataModel *)[self socialStreamDataModel] photosUrlArray] count];
    if( index < imageCount ){
        NSString *strurl = [[(FoursquareSocialStreamDataModel *)[self socialStreamDataModel] photosUrlArray] objectAtIndex:index];
        NSURL *url = [NSURL URLWithString:strurl];
        AsyncImageView *imgView = [asynImgArray objectAtIndex:index];
        if( [imgView image] == nil ){
            [imgView loadImageFromURL:url];
        }
    }
}

- (CGFloat) heightForText:(NSString *)text {
    CGSize maximumLabelSize = CGSizeMake( [self reviews].frame.size.width, MAXFLOAT);
    CGSize expectedLabelSize = [text sizeWithFont:[UIFont systemFontOfSize:[UIFont labelFontSize]]
                                constrainedToSize:maximumLabelSize 
                                    lineBreakMode:UILineBreakModeWordWrap];
    return expectedLabelSize.height;
}

- (void) pageControlPage:(PageControl *)pageControl
    didSelectPageAtIndex:(NSUInteger)pageIndex {
    [self loadPage:pageIndex];
}

#pragma mark - UITableViewDelegate
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self tipsArray] count];
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
    
    NSDictionary *reviewDict = [[self tipsArray] objectAtIndex:indexPath.row];
    
    //[cell setCellContent:[[self reviewsArray] objectAtIndex:indexPath.row]];
    [cell.reviewLabel setText:[reviewDict objectForKey:@"text"]];
    [cell.dateTimeLabel setText:[Utility timeString:[[reviewDict objectForKey:@"createdAt"] stringValue]]];
    [cell.userNameLabel setText:[[reviewDict objectForKey:@"user"] objectForKey:@"firstName"]];

    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSString *review = [[(FoursquareSocialStreamDataModel *)[self socialStreamDataModel] tipsArray] objectAtIndex:indexPath.row];
    return 80;//[self heightForText:review];
}

#pragma mark - UITableViewDataSource
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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

#pragma mark - SocialStreamFetchDetailNotification
- (void) fetchDetailsDidFinish:(NSNotification *)notification {
    [self setUpView];
}

- (void)dealloc {
    [asynImgArray release];
    [_reviews release];
    [_imageScrollView release];
    [tipsArray release];
    [super dealloc];
}
@end
