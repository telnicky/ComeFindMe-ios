//
//  CFMSentRequestViewController.h
//  ComeFindMe
//
//  Created by travis elnicky on 4/21/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

#import "CFMSentRequestView.h"
#import "CFMUser.h"
#import "CFMFriendsDataSource.h"

@interface CFMSentRequestViewController : UIViewController
@property (nonatomic) NSDictionary* message;
@property (nonatomic) CFMSentRequestView* sentRequestView;
@property (nonatomic) CFMFriends* friendsTable;
@property (nonatomic) CFMFriendsDataSource* friendsDataSource;
@end
