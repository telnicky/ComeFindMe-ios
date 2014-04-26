//
//  CFMMessage.h
//  ComeFindMe
//
//  Created by travis elnicky on 4/22/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CFMBase.h"
#import "CFMLocation.h"
#import "CFMBroadcast.h"

@class CFMMessage;
@class CFMUser;

@protocol CFMMessageDelegate <NSObject>

- (void)saveSuccessfulForMessage:(CFMMessage*)message;
- (void)savefailedForMessage:(CFMMessage*)message;

@end

@protocol CFMMessageBroadcastsDelegate <NSObject>

- (void)successfullyLoadedBroadcastsForMessage:(CFMMessage*)message;
- (void)failedToLoadBroadcastsForMessage:(CFMMessage*)message;

@end

@interface CFMMessage : NSObject < CFMBroadcastDelegate, CFMBaseProtocol >

// relationships
@property (nonatomic) CFMUser* user;
@property (nonatomic) CFMUser* sender;
@property (nonatomic) CFMLocation* location;
@property (nonatomic) NSMutableArray* receivers;
@property (nonatomic) NSMutableArray* broadcasts;

// Attributes
@property (nonatomic) NSNumber* id;
@property (nonatomic) NSString* error;

@property (nonatomic) NSNumber* senderId;
@property (nonatomic) NSNumber* locationId;
@property (nonatomic) NSNumber* userId;
@property (nonatomic) NSString* createdAt;
@property (nonatomic) NSString* facebookId;
@property (nonatomic) bool read;

// Delegates
@property (nonatomic) id < CFMMessageDelegate > delegate;
@property (nonatomic) id < CFMMessageBroadcastsDelegate > broadcastsDelegate;

// Instance Methods
- (void)fromJson:(NSDictionary*)json;
- (void)loadBroadcasts;
- (NSString*)toJson;
- (void)save;
@end
