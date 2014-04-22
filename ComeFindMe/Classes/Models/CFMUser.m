//
//  CFMUser.m
//  ComeFindMe
//
//  Created by travis elnicky on 4/20/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import "CFMUser.h"

@implementation CFMUser

static CFMUser* instance;
static BOOL initialized = false;

+ (void)initialize
{
    if (!initialized) {
        initialized = true;
        instance = [[CFMUser alloc] init];
    }
}

+ (CFMUser*)instance
{
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.friends = [CFMFriends instance];
        [self.friends setDelegate:self];
     
        self.messages = [CFMMessages instance];
        [self.messages.delegates addObject:self];
        
        self.location = [[CFMLocation alloc] init];
    }
    return self;
}

- (void)loadData
{
    [self.friends loadData];
}

- (void)login
{

    NSString* requestBody = [self sessionCreateBody];
    [[CFMRestService instance] createResource:@"sessions"
                    body:[requestBody dataUsingEncoding:NSUTF8StringEncoding]
       completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         if (error) {
             return;
         }
         
         id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
         NSString* facebookId = [jsonObject objectForKey:@"facebook_id"];
         if ([facebookId isEqualToString:self.facebookUser.id])
         {
             [self setAttributes:jsonObject];
             [self setId:[jsonObject objectForKey:@"id"]];
             [[self location] setUserId:[[self attributes] objectForKey:@"id"]];
             [self.delegate userSuccessfullyLoggedIn:self];
         }
         else
         {
             [self.delegate userFailedLogin:self];
         }
     }];
}

- (NSString*)sessionCreateBody
{
    NSString* accessToken = [[[FBSession activeSession] accessTokenData] accessToken];
    NSString* requestBody = [NSString stringWithFormat:@"{\"facebook_id\": \"%@\", \"facebook_access_token\": \"%@\"}\n", self.facebookUser.id, accessToken];

    return requestBody;
}

#pragma mark CFMFriendsDelegate
- (void)friendsDidLoad:(CFMFriends *)friends
{
    [self.messages loadData];
}

#pragma mark CFMMessagesDelegate
- (void)messagesDidLoad:(CFMMessages *)messages
{
    [self setMessages:messages];
    [self.delegate userDidFinishLoading:self];
}

@end
