//
//  CFMMessages.h
//  ComeFindMe
//
//  Created by travis elnicky on 4/19/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CFMRestService.h"
#import "CFMFriends.h"

@class CFMMessages;

@protocol CFMMessagesDelegate <NSObject>

- (void)messagesDidLoad:(CFMMessages*)messages;

@end

@interface CFMMessages : NSObject < UITableViewDataSource >
@property (nonatomic, assign) id < CFMMessagesDelegate > delegate;
@property (nonatomic) NSMutableArray* messages;
@property (nonatomic) CFMRestService* restService;
@property (nonatomic) CFMFriends* friends;

+ (CFMMessages*)instance;

- (void)loadData;
- (int)count;
@end
