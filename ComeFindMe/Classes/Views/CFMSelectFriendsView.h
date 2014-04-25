//
//  CFMSelectFriendsView.h
//  ComeFindMe
//
//  Created by travis elnicky on 4/13/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFMColors.h"

@class CFMSelectFriendsView;

@protocol CFMSelectFriendsView <NSObject>

- (void)sendButtonPressedOnSelectFriendsView:(CFMSelectFriendsView*)selectFriendsView;

@end

@interface CFMSelectFriendsView : UIView < UITableViewDelegate >
@property (nonatomic, assign) id < CFMSelectFriendsView > delegate;
@property (nonatomic) UITableView* friendsTable;
@property (nonatomic) UIButton* sendButton;
@end
