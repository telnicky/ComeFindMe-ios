//
//  CFMSelectFriendsViewController.m
//  ComeFindMe
//
//  Created by travis elnicky on 4/13/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import "CFMSelectFriendsViewController.h"

@interface CFMSelectFriendsViewController ()

@end

@implementation CFMSelectFriendsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setTitle:@"Select Friends"];
        
        // Setup select location nav button
        UIImage* selectLocationImage = [UIImage imageNamed:@"07-map-marker"];
        UIBarButtonItem* selectLocationButton = [[UIBarButtonItem alloc] initWithImage:selectLocationImage style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed)];
        [selectLocationButton setTintColor:UIColorFromRGB(Black)];
        [self.navigationItem setLeftBarButtonItem:selectLocationButton];
        
        self.selectFriendsView = [[CFMSelectFriendsView alloc] init];
        [self.selectFriendsView setDelegate:self];
        
        self.friendsDataSource = [[CFMFriendsDataSource alloc] init];
        [self.friendsDataSource setShouldAllowSelection:true];
        [self.friendsDataSource setShouldUseSections:true];
        [self.friendsDataSource setShouldDisplayFullName:true];
        [self.friendsDataSource
         setFriends:[[CFMUser currentUser] friends]];

        [self.selectFriendsView.friendsTable
         setDataSource:self.friendsDataSource];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    [self setView:self.selectFriendsView];
}

- (void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:false];
}

#pragma mark CFMSelectFriendsDelegate
- (void)sendButtonPressedOnSelectFriendsView:(CFMSelectFriendsView *)selectFriendsView
{
    NSArray* friendIndexes = [[self.selectFriendsView friendsTable]
                              indexPathsForSelectedRows];

    NSMutableArray* friends = [[NSMutableArray alloc]
                               initWithCapacity:friendIndexes.count];

    for (NSIndexPath* friendIndex in friendIndexes)
    {
        NSString* section = [self.friendsDataSource.sections
                             objectAtIndex:[friendIndex section]];

        CFMUser* friend = [[self.friendsDataSource.friendsWithSections
                            objectForKey:section]
                           objectAtIndex:[friendIndex row]];

        [friends addObject:friend];
    }
    
    [self.delegate selectFriendsViewController:
     self sendMessagesToFriends:friends];
}

#pragma mark CFMUserFriendsDelegate
- (void)successfullyLoadedFriendsForUser:(CFMUser *)user
{
    [self.selectFriendsView setNeedsDisplay];
}

- (void)failedToLoadFriendsForUser:(CFMUser *)user
{
    // TODO: handle failed state
}

@end
