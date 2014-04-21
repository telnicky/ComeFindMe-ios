//
//  CFMReceiveRequestViewController.m
//  ComeFindMe
//
//  Created by travis elnicky on 4/20/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import "CFMReceiveRequestViewController.h"

@interface CFMReceiveRequestViewController ()

@end

@implementation CFMReceiveRequestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initRequestView];
        UIBarButtonItem* date = [[UIBarButtonItem alloc] initWithTitle:@"mar 27" style:UIBarButtonItemStyleBordered target:nil action:nil];
        [date setEnabled:false];
        [self.navigationItem setRightBarButtonItem:date];
    }
    return self;
}

- (void)initRequestView
{
    self.receiveRequestView = [[CFMReceiveRequestView alloc] init];
}

- (void)loadView
{
    [self setView:self.receiveRequestView];
}

- (void)setMessage:(NSDictionary *)message
{
    _message = message;
    
    [self updateLocation];
    [self updateNavbar];
}

- (void)updateLocation
{
    NSDictionary* location = [self.message objectForKey:@"location"];
    [self.receiveRequestView setLongitude:[[location objectForKey:@"longitude"] floatValue]];
    [self.receiveRequestView setLatitude:[[location objectForKey:@"latitude"] floatValue]];
    [self.receiveRequestView setDescription:[location objectForKey:@"description"]];
}

- (void)updateNavbar
{
    
    NSDictionary<FBGraphUser>* sender = [[self.message objectForKey:@"sender"] objectForKey:@"facebook_user"];
    [self setTitle:[NSString stringWithFormat:@"%@ %@", sender.first_name, sender.last_name]];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"Y-MM-dd HH:mm:ss Z"];
    NSString* dateString = [self.message objectForKey:@"created_at"];
    NSDate* date = [dateFormatter dateFromString:dateString];
    [dateFormatter setDateFormat:@"h:mm a M/d"];
    dateString = [dateFormatter stringFromDate:date];
    [self.navigationItem.rightBarButtonItem setTitle:dateString];
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
