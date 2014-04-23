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
    NSMutableArray* _initialViewControllers;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initNavbar];
        
        self.user = [CFMUser currentUser];
        [self.user setDelegate:self];
        
        self.loginViewController = [[CFMLoginViewController alloc] init];
        [self.loginViewController setDelegate:self];
        
        [self pushViewController:self.loginViewController animated:false];
    }
    return self;
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
    [self.user fromFacebookJson:user];
    [self.user login];
    [self.user loadFriends];
    [self.user loadMessages];
}

#pragma mark CFMUserDelegate
- (void)userSuccessfullyLoggedIn:(CFMUser *)user
{
    self.selectLocationController = [[CFMSelectLocationViewController alloc] init];
    [self.selectLocationController setDelegate:self];

    [self setViewControllers:
     @[ self.selectLocationController ] animated:false];
    
    [self setNavigationBarHidden:false];
}

- (void)userFailedLogin:(CFMUser *)user
{
    // TODO: Implement failed state
}

#pragma mark CFMSelectLocationViewControllerDelegate
- (void)selectFriendsPressedFromSelectLocationViewController:(CFMSelectLocationViewController *)selectLocationViewController
{
    self.selectFriendsController = [[CFMSelectFriendsViewController alloc] init];
    [self.selectFriendsController setDelegate:self];
    [[[CFMUser currentUser] location] setUserId:self.user.id];
    [[[CFMUser currentUser] location] save];
    
    [self pushViewController:self.selectFriendsController animated:false];
}

- (void)messagesPressedFromSelectLocationViewController:(CFMSelectLocationViewController *)selectLocationViewController
{
    
    self.messagesViewController = [[CFMMessagesViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.messagesViewController setDelegate:self];
    [[CFMUser currentUser] setMessagesDelegate:self.messagesViewController];
    
    [self pushViewController:self.messagesViewController animated:false];
}

#pragma mark CFMMessagesViewControllerDelegate
- (void)messagesViewController:(CFMMessagesViewController*)messagesViewController didSelectSentMessage:(CFMMessage*)message
{
    self.sentRequestViewController = [[CFMSentRequestViewController alloc] init];
    [self.sentRequestViewController setMessage:message];
    [self pushViewController:self.sentRequestViewController animated:false];
}

- (void)messagesViewController:(CFMMessagesViewController*)messagesViewController didSelectReceivedMessage:(CFMMessage*)message
{
    self.receiveRequestViewController = [[CFMReceiveRequestViewController alloc] init];
    [self.receiveRequestViewController setMessage:message];
    [self pushViewController:self.receiveRequestViewController animated:false];
}

- (void)settingsButtonPressedForMessagesViewController:(CFMMessagesViewController *)messagesViewController
{
    self.settingsViewController = [[CFMSettingsViewController alloc] init];
    [self.settingsViewController setDelegate:self];
    
    [self pushViewController:self.settingsViewController animated:false];
}

#pragma mark CFMSelectFriendsViewControllerDelegate
- (void)selectFriendsViewController:(CFMSelectFriendsViewController *)selectFriendsViewController sendMessagesToFriends:(NSArray *)friends
{
    for (CFMUser* friend in friends)
    {
        CFMMessage* message = [[CFMMessage alloc] init];
        [message setSenderId:self.user.id];
        [message setUserId:friend.id];
        [message setFacebookId:friend.facebookId];
        [message setLocationId:self.user.location.id];
        [message save];
    }

    self.messagesViewController = [[CFMMessagesViewController alloc] init];
    [self.messagesViewController setDelegate:self];
    [[CFMUser currentUser] setMessagesDelegate:self.messagesViewController];
    [self popToRootViewControllerAnimated:false];
    [self pushViewController:self.messagesViewController animated:false];
    [self.user loadMessages];
}

#pragma mark CFMSettingsViewControllerDelegate
- (void)loggedOutUserFromSettingsViewController:(CFMSettingsViewController *)settingsViewController
{
    // TODO: fix this
    [self initNavbar];
    
    self.user = [CFMUser currentUser];
    [self.user setDelegate:self];
    
}


@end
