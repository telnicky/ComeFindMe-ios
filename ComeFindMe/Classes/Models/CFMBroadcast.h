//
//  CFMBroadcast.h
//  ComeFindMe
//
//  Created by travis elnicky on 4/23/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CFMLocation.h"

@class CFMMessage;
@class CFMUser;
@class CFMBroadcast;

@protocol CFMBroadcastDelegate <NSObject>

- (void)saveSuccessfulForBroadcast:(CFMBroadcast*)broadcast;
- (void)saveFailedForBroadcast:(CFMBroadcast*)broadcast;

- (void)destroySuccessfulForBroadcast:(CFMBroadcast*)broadcast;
- (void)destroyFailedForBroadcast:(CFMBroadcast*)broadcast;

@end

@interface CFMBroadcast : NSObject

// Attributes
@property (nonatomic) NSNumber* id;
@property (nonatomic) NSNumber* senderId;
@property (nonatomic) NSNumber* messageId;
@property (nonatomic) NSNumber* userId;

// Relationships
@property (nonatomic) CFMUser* user;
@property (nonatomic) CFMUser* sender;
@property (nonatomic) CFMMessage* message;

// Delegats
@property (nonatomic) id < CFMBroadcastDelegate > delegate;

// Instance Methods
- (void)fromJson:(NSDictionary*)json;
- (NSString*)toJson;
- (void)save;
- (void)destroy;

@end
