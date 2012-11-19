//
//  SocialStreamDetailViewController.m
//  SocialStreams
//
//  Created by ManishNaharMac on 21/08/12.
//
//

#import "SocialStreamDetailViewController.h"

@interface SocialStreamDetailViewController ()

@end

@implementation SocialStreamDetailViewController

@synthesize imageView_;
@synthesize likes;
@synthesize postedBy;
@synthesize socialStreamDataModel;
@synthesize reviewsCell;
@synthesize pageControl;
@synthesize tweetsDetailsArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.imageView_ loadImageFromURL:[NSURL URLWithString:[socialStreamDataModel standardUrl]]];
    [self.likes setText:[NSString stringWithFormat:@"%d",[socialStreamDataModel likes]]];
    [self.postedBy setText:[socialStreamDataModel postedBy]];
    [self addObserverForDataModel:[self socialStreamDataModel]];
    [pageControl setDelegate:self];
}

- (void)viewDidUnload {
    [self removeObserverForDataModel:[self socialStreamDataModel]];
    pageControl = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) addObserverForDataModel:(SocialStreamDataModel *)dataModel {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetchDetailsDidStart:)
                                                 name:kFetchModelDetailsDidStart
                                               object:dataModel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetchDetailsDidFinish:)
                                                 name:kFetchModelDetailsDidFinish
                                               object:dataModel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetchDetailsDidFail:)
                                                 name:kFetchModelDetailsDidFail
                                               object:dataModel];
}

- (void) removeObserverForDataModel:(SocialStreamDataModel *)dataModel {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kFetchModelDetailsDidFail
                                                  object:dataModel];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kFetchModelDetailsDidFinish
                                                  object:dataModel];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kFetchModelDetailsDidStart
                                                  object:dataModel];
}

- (void) fetchDetailsDidStart:(NSNotification *)notification {
    
}

- (void) fetchDetailsDidFail:(NSNotification *)notification {
    
}

- (void) fetchDetailsDidFinish:(NSNotification *)notification {
    
}

- (void)dealloc {
    [imageView_ release];
    [likes release];
    [postedBy release];
    [tweetsDetailsArray release];
    
    [super dealloc];
}

- (void) pageControlPage:(PageControl *)pageControl
    didSelectPageAtIndex:(NSUInteger)pageIndex {
    
}

@end
