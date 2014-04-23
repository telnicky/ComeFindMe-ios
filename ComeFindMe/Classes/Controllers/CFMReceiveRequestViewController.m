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
    [self.receiveRequestView setDelegate:self];
}

- (void)loadView
{
    [self setView:self.receiveRequestView];
}

- (void)setMessage:(CFMMessage*)message
{
    _message = message;
    
    [self updateLocation];
    [self updateNavbar];
}

- (void)updateLocation
{
    CLLocationCoordinate2D coordinates = self.message.location.coordinates;
    [self.receiveRequestView setLongitude:coordinates.longitude];
    [self.receiveRequestView setLatitude:coordinates.latitude];
    [self.receiveRequestView setDescription:self.message.location.description];
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

#pragma mark CFMReceiveRequestViewDelegate
- (void)didTapMapViewOnReceiveRequestView:(CFMReceiveRequestView *)receiveRequestView
{
    if ([[UIApplication sharedApplication] canOpenURL:
         [NSURL URLWithString:@"comgooglemaps-x-callback://"]])
    {
        // google maps exists
        NSString* path = [NSString
                          stringWithFormat:@"comgooglemaps-x-callback://?daddr=%f,%f&directionsmode=driving&&x-success=comefindme://?resume=true&x-source=Come+Find+Me",
                          [[self receiveRequestView] latitude],
                          [[self receiveRequestView] longitude]];
        
        [[UIApplication sharedApplication] openURL:
         [NSURL URLWithString:path]];
        
    }
    else
    {
        // good luck having apple maps guide you
    }
}

@end
