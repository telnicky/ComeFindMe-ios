//
//  CFMFriends.m
//  ComeFindMe
//
//  Created by travis elnicky on 4/15/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import "CFMFriends.h"

@implementation CFMFriends

- (id)init
{
    self = [super init];
    if (self) {
        self.friends = [[NSMutableDictionary alloc] init];
        self.sections = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)loadData
{
    FBRequest* friendsRequest = [FBRequest requestForMyFriends];
    [friendsRequest startWithCompletionHandler:
     ^(FBRequestConnection *connection,
       NSDictionary* result,
       NSError *error)
    {
        NSMutableArray* friends = [result objectForKey:@"data"];

        NSLog(@"Found: %i friends", friends.count);
        for (NSDictionary<FBGraphUser>* friend in friends) {
            NSLog(@"I have a friend named %@ with id %@", friend.name, friend.id);
        }
        
        
        [self buildSectionsWithFriends:friends];

        [self.delegate friendsDidLoad:self];
    }];
}

- (void)buildSectionsWithFriends:(NSMutableArray*)friends
{
    for ( NSDictionary<FBGraphUser>* friend in friends )
    {
        NSString* character = [friend.name substringToIndex:1];
        bool sectionIsPresent = false;
        
        for ( NSString* section in self.sections )
        {
            if ( [section isEqualToString:character] )
            {
                sectionIsPresent = true;
            }
        }
        
        if ( !sectionIsPresent ) {
            [self.friends setValue:[[NSMutableArray alloc] init] forKey:character];
            [self.sections addObject:character];
        }
        
        [[self.friends objectForKey:character] addObject:friend];
    }
    
    [self.sections sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    for ( NSString* key in self.friends.allKeys ) {
        NSSortDescriptor* lastDescriptor =
        [[NSSortDescriptor alloc] initWithKey:@"last_name"
                                    ascending:true
                                     selector:@selector(localizedCaseInsensitiveCompare:)];
        NSSortDescriptor *firstDescriptor =
        [[NSSortDescriptor alloc] initWithKey:@"first_name"
                                    ascending:true
                                     selector:@selector(localizedCaseInsensitiveCompare:)];
        
        NSArray *descriptors = [NSArray arrayWithObjects:lastDescriptor, firstDescriptor, nil];
        
        [[self.friends objectForKey:key] sortUsingDescriptors:descriptors];
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.friends objectForKey:[self.sections objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* section = [self.sections objectAtIndex:[indexPath section]];
    NSDictionary<FBGraphUser>* friend = [[self.friends objectForKey:section] objectAtIndex:[indexPath row]];
    NSString* title = friend.name;
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CFMFriends class])];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NSStringFromClass([CFMFriends class])];
    }
    
    [[cell textLabel] setText:title];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sections count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.sections objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.sections;
}

@end
