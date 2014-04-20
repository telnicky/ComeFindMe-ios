//
//  CFMMessagesViewController.h
//  ComeFindMe
//
//  Created by travis elnicky on 4/19/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CFMMessagesView.h"
#import "CFMMessages.h"

@interface CFMMessagesViewController : UIViewController
@property (nonatomic) CFMMessagesView* messagesView;
@property (nonatomic) CFMMessages* messages;
@end
