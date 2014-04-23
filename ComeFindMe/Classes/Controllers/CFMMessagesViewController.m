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
// refresh the messages list on pull-down

@implementation CFMMessagesViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.dataSource = [[CFMMessagesDataSource alloc] init];
        [self.dataSource setMessages:[[CFMUser currentUser] messages]];
        
        [self setTitle:@"Come Find Me"];
        
        [self.tableView setDelegate:self];
        [self.tableView setDataSource:self.dataSource];
        
        self.refreshControl = [[UIRefreshControl alloc] init];
        [self.refreshControl addTarget:self action:@selector(refresh)
                      forControlEvents:UIControlEventValueChanged];
        
        UIImage* settingsImage = [UIImage imageNamed:@"glyphicons_070_umbrella"];
        UIBarButtonItem* settingsButton = [[UIBarButtonItem alloc] initWithImage:settingsImage style:UIBarButtonItemStylePlain target:self action:@selector(settingsButtonPressed)];
        [self.navigationItem setRightBarButtonItem:settingsButton];

    }
    return self;
}

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        self.dataSource = [[CFMMessagesDataSource alloc] init];
//        [self.dataSource setMessages:[[CFMUser currentUser] messages]];
//        
//        [self setTitle:@"Come Find Me"];
//        
//        [self.tableView setDelegate:self];
//        [self.tableView setDataSource:self.dataSource];
//        
//        self.refreshControl = [[UIRefreshControl alloc] init];
//        [self.refreshControl addTarget:self action:@selector(refresh)
//                 forControlEvents:UIControlEventValueChanged];
//        
//        UIImage* settingsImage = [UIImage imageNamed:@"glyphicons_070_umbrella"];
//        UIBarButtonItem* settingsButton = [[UIBarButtonItem alloc] initWithImage:settingsImage style:UIBarButtonItemStylePlain target:self action:@selector(settingsButtonPressed)];
//        [self.navigationItem setRightBarButtonItem:settingsButton];
//    }
//    return self;
//}

- (void)settingsButtonPressed
{
    [self.delegate settingsButtonPressedForMessagesViewController:self];
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
    NSLog(@"refresh!");
    [self.refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Refreshing"]];
    
    [[CFMUser currentUser] loadMessages];
    
    [self.refreshControl endRefreshing];
}

#pragma mark CFMUserMessagesDelegate
- (void)successfullyLoadedMessagesForUser:(CFMUser *)user
{
    [self.tableView reloadData];
}

- (void)failedToLoadMessagesForUser:(CFMUser *)user
{
    // TODO: handle failed state
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
