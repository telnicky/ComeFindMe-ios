//
//  CFMMessagesViewController.h
//  ComeFindMe
//
//  Created by travis elnicky on 4/19/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CFMUser.h"
#import "CFMMessagesDataSource.h"

@class CFMMessagesViewController;

@protocol CFMMessagesViewControllerDelegate <NSObject>

- (void)messagesViewController:(CFMMessagesViewController*)messagesViewController didSelectSentMessage:(CFMMessage*)message;

- (void)messagesViewController:(CFMMessagesViewController*)messagesViewController didSelectReceivedMessage:(CFMMessage*)message;

- (void)settingsButtonPressedForMessagesViewController:(CFMMessagesViewController*)messagesViewController;

@end

@interface CFMMessagesViewController : UITableViewController < UITableViewDelegate, CFMUserMessagesDelegate >

// Attributes
@property (nonatomic) CFMMessagesDataSource* dataSource;

// delegates
@property (nonatomic, assign) id < CFMMessagesViewControllerDelegate > delegate;

// Instance Methods
- (id)initWithStyle:(UITableViewStyle)style;

@end
