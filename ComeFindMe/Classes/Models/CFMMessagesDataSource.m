//
//  CFMMessagesDataSource.m
//  ComeFindMe
//
//  Created by travis elnicky on 4/19/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import "CFMMessagesDataSource.h"
#import "CFMMessage.h"
#import "CFMUser.h"

@implementation CFMMessagesDataSource

- (id)init
{
    self = [super init];
    if (self) {
        self.messages = [[NSMutableArray alloc] init];
    }

    return self;
}

- (BOOL)isBroadcastingForMessage:(CFMMessage*)message
{
    for (CFMBroadcast* broadcast in [[CFMUser currentUser] broadcasts])
    {
        if ([broadcast.senderId isEqualToValue:[CFMUser currentUser].id] &&
            [broadcast.messageId isEqualToValue:message.id])
        {
            return true;
        }
    }
    
    return false;
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.messages.count == 0) {
        return 1; // this will be used for the zero data state case
    }
    return self.messages.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.messages.count == 0) {
        // cell for zero data state
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.textLabel.text = @"No messages to display";
        [cell setBackgroundColor:UIColorFromRGB(Accent4)];
        return cell;
    }

    CFMMessage* message = [self.messages objectAtIndex:[indexPath row]];
    UIImage* image;
    NSString* title;
    bool isSentMessage = [[message senderId] isEqualToValue:[CFMUser currentUser].id];
    if (isSentMessage)
    {
        // this is one of our messages
        image = [UIImage imageNamed:@"113-navigation"];
        title = @"Sent Location";
    }
    else
    {
        // this is a message we have received
        image = [UIImage imageNamed:@"18-envelope"];
        if ([message read]) {
            image = [UIImage imageNamed:@"63-runner"];
        }

        title = [NSString stringWithFormat:@"%@ %@", message.sender.firstName, message.sender.lastName];
    }

    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CFMMessagesDataSource class])];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1  reuseIdentifier:NSStringFromClass([CFMMessagesDataSource class])];
    }
    
    // image
    [cell.imageView setImage:image];
    [cell.imageView setFrame:CGRectMake(0, 0, 20, 20)];
    
    // name
    [[cell textLabel] setText:title];
    
    // date
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"Y-MM-dd HH:mm:ss Z"];
    NSString* dateString = [message createdAt];
    NSDate* date = [dateFormatter dateFromString:dateString];
    [dateFormatter setDateFormat:@"hh:mm a M/d/Y"];
    dateString = [dateFormatter stringFromDate:date];
    [[cell detailTextLabel] setText:dateString];
    [[cell detailTextLabel] setFont:[UIFont systemFontOfSize:12]];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    if (!isSentMessage && [self isBroadcastingForMessage:message])
    {
        [UIView
         animateWithDuration:1.0f
         delay:0.0f
         options: UIViewAnimationOptionRepeat |
         UIViewAnimationOptionAutoreverse |
         UIViewAnimationOptionAllowUserInteraction
         animations: ^(void) {
             [cell setBackgroundColor:UIColorFromRGB(MainColor1)];
             [cell setBackgroundColor:UIColorFromRGB(Accent1)];
             [cell setBackgroundColor:UIColorFromRGB(Accent2)];
             [cell setBackgroundColor:UIColorFromRGB(Accent3)];
             [cell setBackgroundColor:UIColorFromRGB(Accent4)];
         }
         completion:NULL];
        
    }
    else
    {
        [UIView animateWithDuration:1.0f animations:^(void) {
            [cell setBackgroundColor:UIColorFromRGB(Accent4)];
        }];
    }
    
    return cell;
}

@end
