//
//  CFMMessages.m
//  ComeFindMe
//
//  Created by travis elnicky on 4/19/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import "CFMMessages.h"

@implementation CFMMessages

static CFMMessages* instance;
static BOOL initialized = false;

+ (void)initialize
{
    if (!initialized) {
        initialized = true;
        instance = [[CFMMessages alloc] init];
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
        self.friends = [CFMFriends instance];
        self.messages = [[NSMutableArray alloc] init];
        self.restService = [CFMRestService instance];
    }
    return self;
}

- (int)count
{
    return self.messages.count;
}

- (void)loadData
{
    [self.restService readResource:@"messages" completionHandler:^(NSURLResponse* response, NSData* data, NSError* error) {
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
    
    [self.delegate messagesDidLoad:self];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSDictionary* message = [[self.messages objectAtIndex:[indexPath row]] objectForKey:@"message"];
    NSDictionary* senderJson = [message objectForKey:@"sender"];
    NSString* facebookId = [senderJson objectForKey:@"facebook_id"];
    
    NSDictionary<FBGraphUser>* sender;
    UIImage* image;
    if ([facebookId isEqualToString:[[CFMRestService instance] user].id])
    {
        // this is one of our messages
        sender = [[CFMRestService instance] user];
        image = [UIImage imageNamed:@"glyphicons_346_hand_left"];
    }
    else
    {
        // this is a message we have received
        for (NSDictionary<FBGraphUser>* friend in self.friends.friends)
        {
            if ([friend.id isEqualToString:facebookId])
            {
                sender = friend;
                break;
            }
        }

        image = [UIImage imageNamed:@"glyphicons_345_hand_right"];
    }

    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CFMFriends class])];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1  reuseIdentifier:NSStringFromClass([CFMFriends class])];
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
