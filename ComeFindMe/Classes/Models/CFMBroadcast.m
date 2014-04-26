//
//  CFMBroadcast.m
//  ComeFindMe
//
//  Created by travis elnicky on 4/23/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import "CFMBroadcast.h"
#import "CFMMessage.h"
#import "CFMUser.h"

@implementation CFMBroadcast

- (void)create
{
    [[CFMRestService instance]
     createResource:@"broadcasts"
     body:[[self toJson] dataUsingEncoding:NSUTF8StringEncoding]
     completionHandler:
     ^(NSURLResponse* response, NSData* data, NSError* error)
     {
         
         BOOL isValid = [[CFMRestService instance] parseObject:self
                                                      response:response
                                                          data:data
                                                         error:error];
         if (isValid)
         {
             [self.delegate saveSuccessfulForBroadcast:self];
             return;
         }
         
         NSLog(@"FATAL: Broadcasts#create - %@", self.error);
         [self.delegate saveFailedForBroadcast:self];
     }];
}

- (void)fromJson:(NSDictionary*)json
{
    // Set Attributes
    [self setId:[json objectForKey:@"id"]];
    [self setMessageId:[json objectForKey:@"message_id"]];
    [self setSenderId:[json objectForKey:@"sender_id"]];
    [self setUserId:[json objectForKey:@"user_id"]];
    
    // Set Relationships
    CFMMessage* message = [[CFMMessage alloc] init];
    [message fromJson:[json objectForKey:@"message"]];
    [self setMessage:message];
    
    CFMUser* sender = [[CFMUser alloc] init];
    [sender fromJson:[json objectForKey:@"sender"]];
    [self setSender:sender];
    
    CFMUser* user = [[CFMUser alloc] init];
    [user fromJson:[json objectForKey:@"user"]];
    [self setUser:user];
}

- (NSString*)toJson
{
    NSString* body = @"{";
    
    if (self.senderId) {
        NSString* senderIdJson = [NSString stringWithFormat:@"\"sender_id\": %@,", self.senderId];
        body = [body stringByAppendingString:senderIdJson];
    }
    
    if (self.messageId) {
        NSString* messageIdJson = [NSString stringWithFormat:@"\"message_id\": %@,", self.messageId];
        body = [body stringByAppendingString:messageIdJson];
    }
    
    if (self.userId) {
        NSString* userIdJson = [NSString stringWithFormat:@"\"user_id\": \"%@\",", self.userId];
        body = [body stringByAppendingString:userIdJson];
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
    // no updates for broadcasts, only creates
    [self create];
}

- (void)destroy
{
    [[CFMRestService instance]
     destroyResource:@"broadcasts"
     guid:[[self id] stringValue]
     completionHandler:
     ^(NSURLResponse* response, NSData* data, NSError* error)
     {
         if (error) {
             NSLog(@"FATAL: Broadcast#delete - Create Failed");
             [self.delegate destroyFailedForBroadcast:self];
             return;
         }
         
         if (error) {
             NSLog(@"FATAL: Broadcast#delete - Parse Data Failed");
             [self.delegate destroyFailedForBroadcast:self];
             return;
         }
         
         // TODO: may want to handle the response from the server here
         [self.delegate destroySuccessfulForBroadcast:self];
     }];
}

@end
