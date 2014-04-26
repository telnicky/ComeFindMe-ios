//
//  CFMFriendsDataSource.h
//  ComeFindMe
//
//  Created by travis elnicky on 4/21/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CFMUser.h"
#import "CFMColors.h"

@interface CFMFriendsDataSource : NSObject < UITableViewDataSource >
@property (nonatomic) NSMutableArray* friends;
@property (nonatomic) NSMutableArray* sections;
@property (nonatomic) NSMutableDictionary* friendsWithSections;
@property (nonatomic) bool shouldAllowSelection;
@property (nonatomic) bool shouldDisplayFullName;
@property (nonatomic) bool shouldUseSections;
@property (nonatomic) bool shouldAllowSelectionStyle;
@end
