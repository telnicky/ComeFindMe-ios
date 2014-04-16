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

@interface CFMNavigationViewController : UINavigationController < CFMLoginViewControllerDelegate, CFMSelectLocationViewControllerDelegate >
@property (nonatomic) CFMLoginViewController* loginViewController;
@property (nonatomic) CFMSelectLocationViewController* selectLocationController;
@property (nonatomic) CFMSelectFriendsViewController* selectFriendsController;
@end
