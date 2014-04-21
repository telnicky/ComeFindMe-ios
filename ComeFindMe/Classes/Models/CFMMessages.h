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
@property (nonatomic) NSMutableArray* delegates;
@property (nonatomic) NSMutableArray* messages;

+ (CFMMessages*)instance;
+ (NSString*)createJsonMessagesForSenderId:(NSString*)senderId locationId:(NSString*)locationId andFacebookId:(NSString*)facebookId;

- (void)loadData;
- (int)count;
@end
