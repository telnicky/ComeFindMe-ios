//
//  CFMUser.h
//  ComeFindMe
//
//  Created by travis elnicky on 4/20/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

#import "CFMFriends.h"
#import "CFMLocation.h"
#import "CFMMessages.h"
#import "CFMRestService.h"

@class CFMUser;

@protocol CFMUserDelegate <NSObject>

- (void)userSuccessfullyLoggedIn:(CFMUser*)user;
- (void)userFailedLogin:(CFMUser*)user;
- (void)userDidFinishLoading:(CFMUser*)user;
- (void)user:(CFMUser*)user DidFailLoadingWithError:(NSError*)error;

@end

@interface CFMUser : NSObject < CFMFriendsDelegate, CFMMessagesDelegate >
@property (nonatomic) id < CFMUserDelegate > delegate;
@property (nonatomic) NSDictionary<FBGraphUser>* facebookUser;
@property (nonatomic) CFMFriends* friends;
@property (nonatomic) CFMMessages* messages;
@property (nonatomic) CFMLocation* location;
@property (nonatomic) NSString* id;
@property (nonatomic) NSDictionary* attributes;

+ (CFMUser*)instance;
- (void)loadData;
- (void)login;
@end
