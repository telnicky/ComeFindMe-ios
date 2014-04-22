//
//  CFMMessages.m
//  ComeFindMe
//
//  Created by travis elnicky on 4/19/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import "CFMMessages.h"
#import "CFMUser.h"

@implementation CFMMessages

static CFMMessages* instance;
static BOOL initialized = false;

+ (void)initialize
{
    if (!initialized) {
        initialized = true;
        instance = [[CFMMessages alloc] init];
        instance.delegates = [[NSMutableArray alloc] init];
    }
}

+ (CFMMessages*)instance
{
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.messages = [[NSMutableArray alloc] init];
    }
    return self;
}

- (int)count
{
    return self.messages.count;
}

- (void)loadData
{
    [[CFMRestService instance] readResource:@"messages" completionHandler:^(NSURLResponse* response, NSData* data, NSError* error) {
        [self loadDataFinishedWithResponse:response data:data error:error];
    }];
}

- (void)loadDataFinishedWithResponse:(NSURLResponse*)response data:(NSData*)data error:(NSError*)error
{
    if (error) {
        NSLog(@"FATAL: Messages - Load Data Failed");
        return;
    }

    self.messages = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    if (error) {
        NSLog(@"FATAL: Messages - Parse Data Failed");
        [self.messages removeAllObjects];
        return;
    }
    
    // TODO: handle bad responses from server
    
    [self aggregateMessages];
    
    for (id< CFMMessagesDelegate > delegate in self.delegates)
    {
        [delegate messagesDidLoad:self];
    }
}

+ (NSString*)createJsonMessagesForSenderId:(NSString*)senderId locationId:(NSString*)locationId andFacebookId:(NSString*)facebookId
{
    NSString* body = @"{";
    
    if (senderId) {
        NSString* senderIdJson = [NSString stringWithFormat:@"\"sender_id\": %@,", senderId];
        body = [body stringByAppendingString:senderIdJson];
    }
    
    if (locationId) {
        NSString* locationIdJson = [NSString stringWithFormat:@"\"location_id\": %@,", locationId];
        body = [body stringByAppendingString:locationIdJson];
    }
    
    if (facebookId) {
        NSString* facebookIdJson = [NSString stringWithFormat:@"\"facebook_id\": \"%@\",", facebookId];
        body = [body stringByAppendingString:facebookIdJson];
    }
    
    if (![body isEqualToString:@"{"]) {
        // remove extra comma
        body = [body substringToIndex:[body length] - 1];
    }
    
    body = [body stringByAppendingString:@"}"];
    
    return body;
}

// this will set didSend on the message
- (void)aggregateMessages
{
    for (NSDictionary* message in self.messages)
    {
        NSDictionary* sender = [message objectForKey:@"sender"];
        NSString* senderId = [sender objectForKey:@"facebook_id"];
        NSString* userId = [[CFMUser instance] facebookUser].id;
        if ([senderId isEqualToString:userId])
        {
            NSNumber* boolNumber = [NSNumber numberWithBool:true];
            [message setValue:boolNumber forKey:@"didSend"];
        }
        else
        {
            NSNumber* boolNumber = [NSNumber numberWithBool:false];
            [message setValue:boolNumber forKey:@"didSend"];
        }
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSDictionary* message = [self.messages objectAtIndex:[indexPath row]];
    
    NSDictionary<FBGraphUser>* sender;
    UIImage* image;
    if ([[message objectForKey:@"didSend"] boolValue])
    {
        // this is one of our messages
        sender = [[CFMUser instance] facebookUser];
        image = [UIImage imageNamed:@"glyphicons_346_hand_left"];
    }
    else
    {
        // this is a message we have received
        NSDictionary* senderJson = [message objectForKey:@"sender"];

        sender = [[[CFMFriends instance] friends] objectForKey:[senderJson objectForKey:@"facebook_id"]];
        image = [UIImage imageNamed:@"glyphicons_345_hand_right"];
    }

    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CFMMessages class])];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1  reuseIdentifier:NSStringFromClass([CFMMessages class])];
    }
    
    // image
    [cell.imageView setImage:image];
    
    // name
    NSString* title = [NSString stringWithFormat:@"%@ %@", sender.first_name, sender.last_name];
    [[cell textLabel] setText:title];
    
    // date
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"Y-MM-dd HH:mm:ss Z"];
    NSString* dateString = [message objectForKey:@"created_at"];
    NSDate* date = [dateFormatter dateFromString:dateString];
    [dateFormatter setDateFormat:@"hh:mm a M/d/Y"];
    dateString = [dateFormatter stringFromDate:date];
    [[cell detailTextLabel] setText:dateString];
    [[cell detailTextLabel] setFont:[UIFont systemFontOfSize:12]];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

@end
