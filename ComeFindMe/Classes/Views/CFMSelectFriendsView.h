//
//  CFMSelectFriendsView.h
//  ComeFindMe
//
//  Created by travis elnicky on 4/13/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFMSelectFriendsView : UIView < UITableViewDelegate >
@property (nonatomic) UITableView* friendsTable;
@property (nonatomic) UIButton* sendButton;
@end
