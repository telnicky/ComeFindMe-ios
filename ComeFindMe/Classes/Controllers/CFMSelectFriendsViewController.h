//
//  CFMSelectFriendsViewController.h
//  ComeFindMe
//
//  Created by travis elnicky on 4/13/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

#import "CFMSelectFriendsView.h"
#import "CFMUser.h"

@interface CFMSelectFriendsViewController : UIViewController <CFMFriendsDelegate >
@property (nonatomic) CFMSelectFriendsView* selectFriendsView;
@end
