//
//  CFMSentRequestViewController.m
//  ComeFindMe
//
//  Created by travis elnicky on 4/21/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import "CFMSentRequestViewController.h"

@interface CFMSentRequestViewController ()

@end

@implementation CFMSentRequestViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.friendsDataSource = [[CFMFriendsDataSource alloc] init];
        [self.friendsDataSource setShouldDisplayFullName:true];
        [self initRequestView];
        
        UIBarButtonItem* date = [[UIBarButtonItem alloc] initWithTitle:@"mar 27" style:UIBarButtonItemStyleBordered target:nil action:nil];
        [date setEnabled:false];
        [self.navigationItem setRightBarButtonItem:date];
    }
    return self;
}

- (void)initRequestView
{
    self.sentRequestView = [[CFMSentRequestView alloc] init];
    [[self.sentRequestView friendsTable]
     setDataSource:self.friendsDataSource];
}

- (void)loadView
{
    [self setView:self.sentRequestView];
}

- (void)setMessage:(CFMMessage*)message
{
    _message = message;
    
    [self updateLocation];
    [self updateNavbar];
    [self updateDataSource];
}

- (void)updateLocation
{
    [self.sentRequestView setCoordinates:self.message.location.coordinates];
}

- (void)updateNavbar
{
    [self setTitle:[NSString stringWithFormat:@"%@", self.message.sender.firstName]];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"Y-MM-dd HH:mm:ss Z"];
    NSString* dateString = self.message.createdAt;
    NSDate* date = [dateFormatter dateFromString:dateString];
    [dateFormatter setDateFormat:@"h:mm a M/d"];
    dateString = [dateFormatter stringFromDate:date];
    [self.navigationItem.rightBarButtonItem setTitle:dateString];
}

- (void)updateDataSource
{
    [self.friendsDataSource setFriends:self.message.receivers];
    [[self.sentRequestView friendsTable]
     setDataSource:self.friendsDataSource];
    [self.sentRequestView.friendsTable reloadData];
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


@end
