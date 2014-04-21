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
    [self.selectFriendsController setDelegate:self];
    
    self.messagesViewController = [[CFMMessagesViewController alloc] init];
    [self.messagesViewController setDelegate:self];
    
    self.receiveRequestViewController = [[CFMReceiveRequestViewController alloc] init];
    
    self.sentRequestViewController = [[CFMSentRequestViewController alloc] init];
    
    self.settingsViewController = [[CFMSettingsViewController alloc] init];
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
    [self.user login];
}

#pragma mark CFMUserDelegate

- (void)userDidFinishLoading:(CFMUser *)user
{
    [self setNavigationBarHidden:false];
    [self setViewControllers:@[ self.selectLocationController ] animated:false];
}

- (void)user:(CFMUser *)user DidFailLoadingWithError:(NSError *)error
{
    // TODO: implement failed state
}

- (void)userSuccessfullyLoggedIn:(CFMUser *)user
{
    [self.user loadData];
}

- (void)userFailedLogin:(CFMUser *)user
{
    // TODO: Implement failed state
}

#pragma mark CFMSelectLocationViewControllerDelegate
- (void)selectFriendsPressedFromSelectLocationViewController:(CFMSelectLocationViewController *)selectLocationViewController
{
    [[[CFMUser instance] location] save];
    [self pushViewController:self.selectFriendsController animated:false];
}

- (void)messagesPressedFromSelectLocationViewController:(CFMSelectLocationViewController *)selectLocationViewController
{
    [self pushViewController:self.messagesViewController animated:false];
}

#pragma mark CFMMessagesViewControllerDelegate
- (void)messagesViewController:(CFMMessagesViewController *)messagesViewController didSelectSentMessage:(NSDictionary *)message
{
    [self.sentRequestViewController setMessage:message];
    [self pushViewController:self.sentRequestViewController animated:false];
}

- (void)messagesViewController:(CFMMessagesViewController *)messagesViewController didSelectReceivedMessage:(NSDictionary *)message
{
    [self.receiveRequestViewController setMessage:message];
    [self pushViewController:self.receiveRequestViewController animated:false];
}

- (void)settingsButtonPressedForMessagesViewController:(CFMMessagesViewController *)messagesViewController
{
    [self pushViewController:self.settingsViewController animated:false];
}

#pragma mark CFMSelectFriendsViewControllerDelegate
- (void)selectFriendsViewController:(CFMSelectFriendsViewController *)selectFriendsViewController sendMessagesToFriends:(NSArray *)friends
{
    for (NSDictionary<FBGraphUser>* friend in friends) {
        NSString* message = [CFMMessages createJsonMessagesForSenderId:self.user.id locationId:self.user.location.id andFacebookId:friend.id];
        [[CFMRestService instance] createResource:@"messages" body:[message dataUsingEncoding:NSUTF8StringEncoding] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
        {
            if (error) {
                NSLog(@"Something went wrong - %@", error);
                return;
            }
            
            NSLog(@"Atempted to send message to user: %@", friend.id);
        }];
    }
    
    [self popToRootViewControllerAnimated:false];
    [self pushViewController:self.messagesViewController animated:false];
}


@end
