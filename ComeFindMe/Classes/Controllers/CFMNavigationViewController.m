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

// TODO: change accuracy of location based on distance from target


@implementation CFMNavigationViewController
{
    CFMLocation* _currentLocation;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initNavbar];
        [self initLocationManager];
        
        self.isBroadcasting = false;
        self.user = [CFMUser currentUser];
        [self.user setDelegate:self];
        [self.user setBroadcastsDelegate:self];
        
        
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


- (void)initLocationManager
{
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    [self.locationManager setDistanceFilter:100.0f];
}

- (void)startBroadcasting
{
    if([CLLocationManager locationServicesEnabled]) {
        [self.locationManager startUpdatingLocation];
        [self.locationManager setDelegate:self];
    }
}

- (void)stopBroadcasting
{
    [self.locationManager setDelegate:nil];
    [self.locationManager stopUpdatingLocation];
}

- (void)setIsBroadcasting:(bool)isBroadcasting
{
    _isBroadcasting = isBroadcasting;
    if (isBroadcasting) {
        [self startBroadcasting];
    }
    else {
        [self stopBroadcasting];
    }
    
}


#pragma mark CFMLoginViewControllerDelegate
- (void)loginViewController:(CFMLoginViewController *)viewController loggedInUser:(NSDictionary<FBGraphUser>*)user
{
    [self.loginViewController.loginView hideLoginView];
    [[self.loginViewController.loginView spinner] startAnimating];
    [self.user fromFacebookJson:user];
    [self.user login];
}

#pragma mark CFMUserDelegate
- (void)successfulLoginForUser:(CFMUser *)user
{
    [self.user loadFriends];
    [self.user loadMessages];
    [self.user loadBroadcasts];
    [self.locationManager startUpdatingLocation];
    
    self.selectLocationController = [[CFMSelectLocationViewController alloc] init];
    [self.selectLocationController setDelegate:self];

    [self setViewControllers:
     @[ self.selectLocationController ] animated:false];
    
    [self setNavigationBarHidden:false];
}

- (void)failedLoginForUser:(CFMUser *)user
{
    // TODO: Implement failed state
}

- (void)successfulSyncForUser:(CFMUser*)user
{
    [self.selectLocationController updateMessagesBadgeCount];
}

- (void)failedSyncForUser:(CFMUser*)user
{
    // TODO:
}

- (void)successfulSaveForUser:(CFMUser *)user
{
    // TODO:
}

- (void)failedSaveForUser:(CFMUser *)user
{
    // TODO:
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
    
    if (![message read]) {
        [message setRead:true];
        [message save];
    }
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
    [self.navigationDelegate logoutFromCFMNavigationController:self];
}

#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"%@ - %@", newLocation, oldLocation);
    [self stopBroadcasting];
    
    // Accuracy to three decimal places
    int roundedNewLatitude = newLocation.coordinate.latitude * 1000;
    int roundedNewLongitude = newLocation.coordinate.longitude * 1000;
    int roundedOldLatitude = self.user.currentLocation.coordinates.latitude * 1000;
    int roundedOldLongitude = self.user.currentLocation.coordinates.longitude * 1000;
    
    // user does not have a current location
    if (!self.user.currentLocationId)
    {
        _currentLocation = [[CFMLocation alloc] init];
        [_currentLocation setUserId:self.user.id];
        [_currentLocation setCoordinates:newLocation.coordinate];
        [_currentLocation setDelegate:self];
        [_currentLocation save];
        return;
    }

    // user's location has not changed
    if (roundedNewLatitude == roundedOldLatitude &&
        roundedNewLongitude == roundedOldLongitude)
    {
        [self startBroadcasting];
        return;
    }
    
    // user's location has changed
    CFMLocation* location = self.user.currentLocation;
    [location setCoordinates:newLocation.coordinate];
    [location save];
    
    // TODO: check for lost signal
}

#pragma mark CFMLocationDelegate
- (void)saveSuccessfulForLocation:(CFMLocation *)location
{
    if (self.user.currentLocationId != location.id) {
        [self.user setCurrentLocationId:location.id];
        [self.user setCurrentLocation:location];
        [self.user save];
    }
    
    [self startBroadcasting];
}

- (void)saveFailedForLocation:(CFMLocation*)location
{
    [self startBroadcasting];
}

#pragma mark CFMUserBroadcastsDelegate
- (void)successfullyLoadedBroadcastsForUser:(CFMUser *)user
{
    // start broadcasting if we need too.
    for (CFMBroadcast* broadcast in user.broadcasts) {
        if ([broadcast.senderId isEqualToValue:user.id]) {
            self.isBroadcasting = true;
            return;
        }
    }
    self.isBroadcasting = false;
}

- (void)failedToLoadBroadcastsForUser:(CFMUser *)user
{
    // handle error state
    self.isBroadcasting = false;
}

@end
