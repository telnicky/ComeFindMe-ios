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
        self.friends = [[NSMutableArray alloc] init];
        self.friendsWithSections = [[NSMutableDictionary alloc] init];
        self.sections = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)buildSectionsWithFriends
{
    for ( CFMUser* friend in self.friends )
    {
        NSString* character = [friend.firstName substringToIndex:1];
        
        if (![self.friendsWithSections objectForKey:character]) {
            [self.friendsWithSections
             setValue:[[NSMutableArray alloc] init]
             forKey:character];
            [self.sections addObject:character];
        }
        
        [[self.friendsWithSections objectForKey:character]
         addObject:friend];
    }
    
    [self.sections sortUsingSelector:
     @selector(localizedCaseInsensitiveCompare:)];
    
    for ( NSString* key in self.friendsWithSections.allKeys ) {
        NSMutableArray *descriptors = [[NSMutableArray alloc] init];
        
        NSSortDescriptor *firstDescriptor =
        [[NSSortDescriptor alloc] initWithKey:@"firstName"
         ascending:true
         selector:@selector(localizedCaseInsensitiveCompare:)];
        
        NSSortDescriptor* lastDescriptor =
        [[NSSortDescriptor alloc]
         initWithKey:@"lastName"
         ascending:true
         selector:@selector(localizedCaseInsensitiveCompare:)];
        
        if ([self shouldDisplayFullName]) {
            [descriptors addObject:lastDescriptor];
        }
        
        [descriptors addObject:firstDescriptor];
        
        [[self.friendsWithSections objectForKey:key]
         sortUsingDescriptors:descriptors];
    }
}

- (CFMUser*)friendFromIndexPath:(NSIndexPath*)indexPath
{
    CFMUser* friend;
    if ([self shouldUseSections])
    {
        NSString* section = [self.sections
                             objectAtIndex:[indexPath section]];
        friend = [[self.friendsWithSections
                   objectForKey:section]
                  objectAtIndex:[indexPath row]];
    }
    else
    {
        friend = [self.friends objectAtIndex:[indexPath row]];
    }

    return friend;
}

- (NSString*)titleForFriend:(CFMUser*)friend
{
    NSString* title;
    if ([self shouldDisplayFullName])
    {
        title = [NSString stringWithFormat:@"%@ %@", friend.firstName, friend.lastName];
    }
    else
    {
        title = friend.firstName;
    }
    
    return title;
}

- (void)setFriends:(NSMutableArray *)friends
{
    _friends = friends;
    
    if ([self shouldUseSections]) {
        [self buildSectionsWithFriends];
    }

}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.friends.count == 0) {
        return 1; // this will be used for the zero data state case
    }
    
    if ([self shouldUseSections]) {
        NSString* sectionName = [self.sections
                                 objectAtIndex:section];
        return [[self.friendsWithSections
                 objectForKey:sectionName]
                count];
    }
 
    return self.friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.friends.count == 0) {
        // cell for zero data state
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.textLabel.text = @"No friends have app installed yet!";
        [cell setBackgroundColor:UIColorFromRGB(Accent4)];
        return cell;
    }
    
    CFMUser* friend = [self friendFromIndexPath:indexPath];
    NSString* title = [self titleForFriend:friend];
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CFMFriendsDataSource class])];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:NSStringFromClass([CFMFriendsDataSource class])];
    }
    
    if ([self shouldAllowSelection]) {
        if([[tableView indexPathsForSelectedRows]
            containsObject:indexPath])
        {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        } else {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
    }
    
    if (self.shouldAllowSelectionStyle) {
        [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
    }
    else {
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    [[cell textLabel] setText:title];

    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (![self shouldUseSections] || self.friends.count == 0) {
        return 1;
    }
    
    return [self.sections count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (![self shouldUseSections] || self.friends.count == 0) {
        return nil;
    }
    
    return [self.sections objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (![self shouldUseSections] || self.friends.count == 0) {
        return nil;
    }

    return self.sections;
}

@end
