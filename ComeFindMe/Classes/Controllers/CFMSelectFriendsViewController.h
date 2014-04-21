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

@class CFMSelectFriendsViewController;

@protocol CFMSelectFriendsViewControllerDelegate <NSObject>

- (void)selectFriendsViewController:(CFMSelectFriendsViewController*)selectFriendsViewController sendMessagesToFriends:(NSArray*)friends;

@end

@interface CFMSelectFriendsViewController : UIViewController <CFMFriendsDelegate, CFMSelectFriendsView >
@property (nonatomic, assign) id < CFMSelectFriendsViewControllerDelegate > delegate;
@property (nonatomic) CFMSelectFriendsView* selectFriendsView;
@end
