//
//  CFMNavigationViewController.m
//  ComeFindMe
//
//  Created by travis elnicky on 4/12/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import "CFMNavigationViewController.h"


// TODO: use this to define the colors we want
#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]



@implementation CFMNavigationViewController
{

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initNavbar];
        [self initControllers];
        
        self.user = [CFMUser instance];
        [self.user setDelegate:self];

        [self pushViewController:self.loginViewController animated:false];
    }
    return self;
}

- (void)initControllers
{
    
    self.loginViewController = [[CFMLoginViewController alloc] init];
    [self.loginViewController setDelegate:self];
    
    self.selectLocationController = [[CFMSelectLocationViewController alloc] init];
    [self.selectLocationController setDelegate:self];
    
    self.selectFriendsController = [[CFMSelectFriendsViewController alloc] init];
    
    self.messagesViewController = [[CFMMessagesViewController alloc] init];
}

- (void)initNavbar
{
    [[UINavigationBar appearance] setBarTintColor:[UIColor yellowColor]];
    [self.navigationBar setTranslucent:false];
    [self setNavigationBarHidden:true];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark CFMLoginViewControllerDelegate
- (void)loginViewController:(CFMLoginViewController *)viewController loggedInUser:(NSDictionary<FBGraphUser>*)user
{
    [self.loginViewController.loginView hideLoginView];
    [[self.loginViewController.loginView spinner] startAnimating];
    [self.user setFacebookUser:user];
    [self.user loadData];
}

#pragma mark CFMUserDelegate

- (void)userDidFinishLoading:(CFMUser *)user
{
    [self.user login];
}

- (void)user:(CFMUser *)user DidFailLoadingWithError:(NSError *)error
{
    // TODO: implement failed state
}

- (void)userSuccessfullyLoggedIn:(CFMUser *)user
{
//    [self initControllers];
    [self setNavigationBarHidden:false];
    [self setViewControllers:@[ self.selectLocationController ] animated:false];
}

- (void)userFailedLogin:(CFMUser *)user
{
    // TODO: Implement failed state
}

#pragma mark CFMSelectLocationViewControllerDelegate
- (void)selectFriendsPressedFromSelectLocationViewController:(CFMSelectLocationViewController *)selectLocationViewController
{
    [self pushViewController:self.selectFriendsController animated:false];
}

- (void)messagesPressedFromSelectLocationViewController:(CFMSelectLocationViewController *)selectLocationViewController
{
    [self pushViewController:self.messagesViewController animated:false];
}

#pragma mark CFMMessagesViewControllerDelegate
- (void)messagesViewController:(CFMMessagesViewController *)messagesViewController didSelectSentMessage:(NSDictionary *)message
{
    // TODO: push on sent message view controller
}

- (void)messagesViewController:(CFMMessagesViewController *)messagesViewController didSelectReceivedMessage:(NSDictionary *)message
{
    // TODO: push on received message view controller
}

@end
