//
//  CFMNavigationViewController.m
//  ComeFindMe
//
//  Created by travis elnicky on 4/12/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import "CFMNavigationViewController.h"

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
        // Custom initialization
        [self initNavbar];
        [self initControllers];
        [[CFMRestService instance] setDelegate:self];

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
    [[CFMRestService instance] loginUser:user];
}

#pragma mark CFMRestServiceDelegate
- (void)restService:(CFMRestService *)service successfullyLoggedInUser:(NSDictionary<FBGraphUser> *)user
{
    [self setNavigationBarHidden:false];
    [self setViewControllers:@[ self.selectLocationController ] animated:false];
}

- (void)restService:(CFMRestService*)service failedLoginWithError:(NSError*)error
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

@end
