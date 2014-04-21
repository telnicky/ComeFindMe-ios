//
//  CFMFriendsDataSource.m
//  ComeFindMe
//
//  Created by travis elnicky on 4/21/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import "CFMFriendsDataSource.h"

@implementation CFMFriendsDataSource

- (id)init
{
    self = [super init];
    if (self) {
        self.friendIds = [[NSMutableArray alloc] init];
    }
    
    return self;
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.friendIds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* friendId = [self.friendIds objectAtIndex:[indexPath row]];
    NSDictionary<FBGraphUser>* friend = [[[[CFMUser instance] friends] friends] objectForKey:friendId];

    NSString* title = friend.name;
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CFMFriends class])];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:NSStringFromClass([CFMFriends class])];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [[cell textLabel] setText:title];
    return cell;
}

@end
