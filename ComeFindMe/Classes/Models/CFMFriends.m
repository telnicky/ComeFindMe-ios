//
//  CFMFriends.m
//  ComeFindMe
//
//  Created by travis elnicky on 4/15/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import "CFMFriends.h"

@implementation CFMFriends

static CFMFriends* instance;
static BOOL initialized = false;

+ (void)initialize
{
    if (!initialized) {
        initialized = true;
        instance = [[CFMFriends alloc] init];
    }
}

+ (CFMFriends*)instance
{
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.sectionsWithFriends = [[NSMutableDictionary alloc] init];
        self.sections = [[NSMutableArray alloc] init];
        self.friends = [[NSMutableDictionary alloc] init];
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
        NSArray* friends = [result objectForKey:@"data"];
        [self buildSectionsWithFriends:friends];
        [self.delegate friendsDidLoad:self];
    }];
}

- (void)buildSectionsWithFriends:(NSArray*)friends
{
    for ( NSDictionary<FBGraphUser>* friend in friends )
    {
        [self.friends setValue:friend forKey:friend.id];
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
            [self.sectionsWithFriends setValue:[[NSMutableArray alloc] init] forKey:character];
            [self.sections addObject:character];
        }
        
        [[self.sectionsWithFriends objectForKey:character] addObject:friend];
    }
    
    [self.sections sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    for ( NSString* key in self.sectionsWithFriends.allKeys ) {
        NSSortDescriptor* lastDescriptor =
        [[NSSortDescriptor alloc] initWithKey:@"last_name"
                                    ascending:true
                                     selector:@selector(localizedCaseInsensitiveCompare:)];
        NSSortDescriptor *firstDescriptor =
        [[NSSortDescriptor alloc] initWithKey:@"first_name"
                                    ascending:true
                                     selector:@selector(localizedCaseInsensitiveCompare:)];
        
        NSArray *descriptors = [NSArray arrayWithObjects:lastDescriptor, firstDescriptor, nil];
        
        [[self.sectionsWithFriends objectForKey:key] sortUsingDescriptors:descriptors];
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.sectionsWithFriends objectForKey:[self.sections objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* section = [self.sections objectAtIndex:[indexPath section]];
    NSDictionary<FBGraphUser>* friend = [[self.sectionsWithFriends objectForKey:section] objectAtIndex:[indexPath row]];
    NSString* title = friend.name;
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CFMFriends class])];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:NSStringFromClass([CFMFriends class])];
    }
    
    if([[tableView indexPathsForSelectedRows] containsObject:indexPath]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
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
