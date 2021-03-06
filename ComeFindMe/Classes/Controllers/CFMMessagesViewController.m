//
//  CFMMessagesViewController.m
//  ComeFindMe
//
//  Created by travis elnicky on 4/19/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import "CFMMessagesViewController.h"

@interface CFMMessagesViewController ()

@end

// TODO:
// Paging idea
// request paginated messages
// return a list of url's that will return paginated records

// TODO:
// Add ability to delete messages

// TODO:
// Add badges for sent requests with broadcasting users

@implementation CFMMessagesViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.dataSource = [[CFMMessagesDataSource alloc] init];
        [self.dataSource setMessages:[[CFMUser currentUser] messages]];

        [self initMessagesTable];
        [self initNavbar];
    }
    return self;
}

- (void)initMessagesTable
{
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 0.01f)];
    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self.dataSource];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)initNavbar
{
    [self setTitle:@"Come Find Me"];
    
    // Setup select location nav button
    UIImage* selectLocationImage = [UIImage imageNamed:@"07-map-marker"];
    UIBarButtonItem* selectLocationButton = [[UIBarButtonItem alloc] initWithImage:selectLocationImage style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed)];
    [selectLocationButton setTintColor:UIColorFromRGB(Black)];
    [self.navigationItem setLeftBarButtonItem:selectLocationButton];
    
    // setup our back button
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    
    UIImage* settingsImage = [UIImage imageNamed:@"20-gear2"];
    UIBarButtonItem* settingsButton = [[UIBarButtonItem alloc] initWithImage:settingsImage style:UIBarButtonItemStyleBordered target:self action:@selector(settingsButtonPressed)];
    [settingsButton setTintColor:UIColorFromRGB(Black)];
    [self.navigationItem setRightBarButtonItem:settingsButton];
    
}

- (void)settingsButtonPressed
{
    [self.delegate settingsButtonPressedForMessagesViewController:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self refresh];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refresh
{
    [self.refreshControl beginRefreshing];
    [[CFMUser currentUser] loadMessages];;
}

- (void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:false];
}

#pragma mark CFMUserMessagesDelegate
- (void)successfullyLoadedMessagesForUser:(CFMUser *)user
{
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

- (void)failedToLoadMessagesForUser:(CFMUser *)user
{
    // Silently fail :)
    [self.refreshControl endRefreshing];
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray* messages = [[CFMUser currentUser] messages];
    CFMMessage* message = [messages objectAtIndex:[indexPath row]];
    if ([[message senderId] isEqualToValue:[CFMUser currentUser].id])
    {
        [self.delegate messagesViewController:self didSelectSentMessage:message];
    }
    else
    {
        [self.delegate messagesViewController:self didSelectReceivedMessage:message];
    }
    
}

@end
