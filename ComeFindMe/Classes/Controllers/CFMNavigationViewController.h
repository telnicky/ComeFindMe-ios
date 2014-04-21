//
//  CFMNavigationViewController.h
//  ComeFindMe
//
//  Created by travis elnicky on 4/12/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CFMLoginViewController.h"
#import "CFMSelectLocationViewController.h"
#import "CFMSelectFriendsViewController.h"
#import "CFMMessagesViewController.h"
#import "CFMReceiveRequestViewController.h"
#import "CFMSentRequestViewController.h"
#import "CFMSettingsViewController.h"

#import "CFMRestService.h"
#import "CFMUser.h"

@interface CFMNavigationViewController : UINavigationController < CFMLoginViewControllerDelegate, CFMSelectLocationViewControllerDelegate,  CFMMessagesViewControllerDelegate, CFMUserDelegate, CFMSelectFriendsViewControllerDelegate >
@property (nonatomic) CFMUser* user;
@property (nonatomic) CFMLoginViewController* loginViewController;
@property (nonatomic) CFMSelectLocationViewController* selectLocationController;
@property (nonatomic) CFMSelectFriendsViewController* selectFriendsController;
@property (nonatomic) CFMMessagesViewController* messagesViewController;
@property (nonatomic) CFMReceiveRequestViewController* receiveRequestViewController;
@property (nonatomic) CFMSettingsViewController* settingsViewController;
@property (nonatomic) CFMSentRequestViewController* sentRequestViewController;
@end
