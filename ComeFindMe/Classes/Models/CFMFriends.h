//
//  CFMFriends.h
//  ComeFindMe
//
//  Created by travis elnicky on 4/15/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
@class CFMFriends;

@protocol CFMFriendsDelegate <NSObject>
- (void)friendsDidLoad:(CFMFriends*)friends;
@end

@interface CFMFriends : NSObject < UITableViewDataSource >
@property (nonatomic, assign) id< CFMFriendsDelegate > delegate;
@property (nonatomic) NSMutableDictionary* friends;
@property (nonatomic) NSMutableDictionary* sectionsWithFriends;
@property (nonatomic) NSMutableArray* sections;
@property (nonatomic) NSMutableDictionary* imagesWithFriends;

+ (CFMFriends*)instance;

- (void)loadData;
@end
