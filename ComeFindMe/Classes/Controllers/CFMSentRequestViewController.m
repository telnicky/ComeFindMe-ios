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
    [[self.sentRequestView friendsTable] setDataSource:self.friendsDataSource];
}

- (void)loadView
{
    [self setView:self.sentRequestView];
}

- (void)setMessage:(NSDictionary *)message
{
    _message = message;
    
    [self updateLocation];
    [self updateNavbar];
    [self updateDataSource];
}

- (void)updateLocation
{
    NSDictionary* location = [self.message objectForKey:@"location"];
    CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake([[location objectForKey:@"latitude"] floatValue],[[location objectForKey:@"longitude"] floatValue]);
    [self.sentRequestView setCoordinates:coordinates];
}

- (void)updateNavbar
{
    NSDictionary<FBGraphUser>* sender = [[CFMUser instance] facebookUser];
    [self setTitle:[NSString stringWithFormat:@"%@", sender.first_name]];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"Y-MM-dd HH:mm:ss Z"];
    NSString* dateString = [self.message objectForKey:@"created_at"];
    NSDate* date = [dateFormatter dateFromString:dateString];
    [dateFormatter setDateFormat:@"h:mm a M/d"];
    dateString = [dateFormatter stringFromDate:date];
    [self.navigationItem.rightBarButtonItem setTitle:dateString];
}

- (void)updateDataSource
{
    for (NSDictionary* receiver in [self.message objectForKey:@"receivers"])
    {
        NSString* facebookId = [receiver objectForKey:@"facebook_id"];
        [[self.friendsDataSource friendIds] addObject:facebookId];
    }
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
