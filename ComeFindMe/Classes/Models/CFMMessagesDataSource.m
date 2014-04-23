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

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    CFMMessage* message = [self.messages objectAtIndex:[indexPath row]];

    UIImage* image;
    if ([[message senderId] isEqualToValue:[CFMUser currentUser].id])
    {
        // this is one of our messages
        image = [UIImage imageNamed:@"glyphicons_346_hand_left"];
    }
    else
    {
        // this is a message we have received
        image = [UIImage imageNamed:@"glyphicons_345_hand_right"];
    }

    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CFMMessagesDataSource class])];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1  reuseIdentifier:NSStringFromClass([CFMMessagesDataSource class])];
    }
    
    // image
    [cell.imageView setImage:image];
    
    // name
    NSString* title = [NSString stringWithFormat:@"%@ %@", message.sender.firstName, message.sender.lastName];
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
    return cell;
}

@end
