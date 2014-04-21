//
//  CFMFriendsDataSource.h
//  ComeFindMe
//
//  Created by travis elnicky on 4/21/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CFMUser.h"

@interface CFMFriendsDataSource : NSObject < UITableViewDataSource >
@property (nonatomic) NSMutableArray* friendIds;
@end
