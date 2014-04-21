//
//  CFMMessagesViewController.h
//  ComeFindMe
//
//  Created by travis elnicky on 4/19/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CFMMessagesView.h"
#import "CFMUser.h"

@class CFMMessagesViewController;

@protocol CFMMessagesViewControllerDelegate <NSObject>

- (void)messagesViewController:(CFMMessagesViewController*)messagesViewController didSelectSentMessage:(NSDictionary*)message;

- (void)messagesViewController:(CFMMessagesViewController*)messagesViewController didSelectReceivedMessage:(NSDictionary*)message;

- (void)settingsButtonPressedForMessagesViewController:(CFMMessagesViewController*)messagesViewController;

@end

@interface CFMMessagesViewController : UIViewController < UITableViewDelegate >
@property (nonatomic, assign) id < CFMMessagesViewControllerDelegate > delegate;
@property (nonatomic) CFMMessagesView* messagesView;
@end
