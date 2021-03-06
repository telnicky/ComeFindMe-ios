//
//  CFMMessage.m
//  ComeFindMe
//
//  Created by travis elnicky on 4/22/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import "CFMMessage.h"
#import "CFMRestService.h"
#import "CFMUser.h"

@implementation CFMMessage

- (id)init
{
    self = [super init];
    if (self) {
        self.receivers = [[NSMutableArray alloc] init];
        self.broadcasts = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)create
{
    [[CFMRestService instance]
     createResource:@"messages"
     body:[[self toJson] dataUsingEncoding:NSUTF8StringEncoding]
     completionHandler:
     ^(NSURLResponse* response, NSData* data, NSError* error)
     {
         BOOL isValid = [[CFMRestService instance] parseObject:self
                                                      response:response
                                                          data:data
                                                      loadData:true
                                                         error:error];
         if (isValid)
         {
             [self.delegate saveSuccessfulForMessage:self];
             return;
         }
         
         NSLog(@"FATAL: Message#create - %@", self.error);
         [self.delegate savefailedForMessage:self];
     }];
}

- (void)fromJson:(NSDictionary*)json
{
    // Set Attributes
    [self setId:[json objectForKey:@"id"]];
    [self setLocationId:[json objectForKey:@"location_id"]];
    [self setSenderId:[json objectForKey:@"sender_id"]];
    [self setUserId:[json objectForKey:@"user_id"]];
    [self setCreatedAt:[json objectForKey:@"created_at"]];
    [self setRead:[[json objectForKey:@"read"] boolValue]];
    
    // Set Relationships
    CFMLocation* location = [[CFMLocation alloc] init];
    [location fromJson:[json objectForKey:@"location"]];
    [self setLocation:location];
    

    for (NSDictionary* userJson in [json objectForKey:@"receivers"])
    {
        CFMUser* user = [[CFMUser alloc] init];
        [user fromJson:userJson];
        [self.receivers addObject:user];
        
        if ([[userJson objectForKey:@"id"] isEqualToValue:[json objectForKey:@"user_id"]])
        {
            user = [[CFMUser alloc] init];
            [user fromJson:userJson];
            [self setUser:user];
        }
    }
    
    
    CFMUser* sender = [[CFMUser alloc] init];
    [sender fromJson:[json objectForKey:@"sender"]];
    [self setSender:sender];
}

- (void)loadBroadcasts
{
    NSString* resource = [NSString stringWithFormat:@"messages/%@/broadcasts", self.id];
    [[CFMRestService instance]
     readResource:resource
     completionHandler:^(NSURLResponse* response, NSData* data, NSError* error) {
        [self loadBroadcastsFinishedWithResponse:response data:data error:error];
    }];
}

- (void)loadBroadcastsFinishedWithResponse:(NSURLResponse*)response data:(NSData*)data error:(NSError*)error
{
    BOOL isValid = [[CFMRestService instance]
                    parseCollection:self.broadcasts
                    object:self
                    className:@"Broadcast"
                    response:response
                    data:data
                    error:error];
    
    if (isValid)
    {
        [self.broadcastsDelegate successfullyLoadedBroadcastsForMessage:self];
        return;
    }
    
    NSLog(@"FATAL: User#loadBroadcastsFinishedWithResponse - %@", self.error);
    [self.broadcastsDelegate failedToLoadBroadcastsForMessage:self];
}

- (NSString*)toJson
{
    NSString* body = @"{";
    
    if (self.senderId) {
        NSString* senderIdJson = [NSString stringWithFormat:@"\"sender_id\": %@,", self.senderId];
        body = [body stringByAppendingString:senderIdJson];
    }
    
    if (self.locationId) {
        NSString* locationIdJson = [NSString stringWithFormat:@"\"location_id\": %@,", self.locationId];
        body = [body stringByAppendingString:locationIdJson];
    }
    
    if (self.read) {
        NSString* locationIdJson = [NSString stringWithFormat:@"\"read\": %s,", self.read ? "true" : "false"];
        body = [body stringByAppendingString:locationIdJson];
    }
    
    if (self.userId) {
        NSString* userIdJson = [NSString stringWithFormat:@"\"user_id\": \"%@\",", self.userId];
        body = [body stringByAppendingString:userIdJson];
    }
    else if (self.facebookId) {
        NSString* facebookIdJson = [NSString stringWithFormat:@"\"facebook_id\": \"%@\",", self.facebookId];
        body = [body stringByAppendingString:facebookIdJson];
    }
    
    if (![body isEqualToString:@"{"]) {
        // remove extra comma
        body = [body substringToIndex:[body length] - 1];
    }
    
    body = [body stringByAppendingString:@"}"];
    
    return body;
}

- (void)save
{
    if (self.id)
    {
        [self update];
    }
    else
    {
        [self create];
    }
}

- (void)update
{
    [[CFMRestService instance]
     updateResource:@"messages"
     guid:[self.id stringValue]
     body:[[self toJson] dataUsingEncoding:NSUTF8StringEncoding]
     completionHandler:
     ^(NSURLResponse* response, NSData* data, NSError* error)
     {
         BOOL isValid = [[CFMRestService instance] parseObject:self
                                                      response:response
                                                          data:data
                                                      loadData:true
                                                         error:error];
         if (isValid)
         {
             [self.delegate saveSuccessfulForMessage:self];
             return;
         }
         
         NSLog(@"FATAL: Message#update - %@", self.error);
         [self.delegate savefailedForMessage:self];
     }];
}

#pragma mark CFMBroadcastDelegate
- (void)saveSuccessfulForBroadcast:(CFMBroadcast *)broadcast
{
    // TODO: We will need these for when we enable notifications
}

- (void)saveFailedForBroadcast:(CFMBroadcast *)broadcast
{
    // TODO:
}

- (void)destroySuccessfulForBroadcast:(CFMBroadcast *)broadcast
{
    // TODO:
}

- (void)destroyFailedForBroadcast:(CFMBroadcast *)broadcast
{
    // TODO:
}

@end
