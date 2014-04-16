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
- (void) loginViewController:(CFMLoginViewController *)viewController loggedInUser:(id<FBGraphUser>)user
{
    [self setNavigationBarHidden:false];
    [self setViewControllers:@[ self.selectLocationController ] animated:false];
}

#pragma mark CFMSelectLocationViewControllerDelegate
- (void) selectFriendsPressedFromSelectLocationViewController:(CFMSelectLocationViewController *)selectLocationViewController
{
    [self pushViewController:self.selectFriendsController animated:false];
}

@end
