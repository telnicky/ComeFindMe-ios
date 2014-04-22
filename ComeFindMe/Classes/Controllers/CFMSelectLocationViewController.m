//
//  CFMSelectLocationViewController.m
//  ComeFindMe
//
//  Created by travis elnicky on 4/13/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import "CFMSelectLocationViewController.h"

@interface CFMSelectLocationViewController ()

@end

@implementation CFMSelectLocationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setTitle:@"Come Find Me"];
        
        [self initLocationView];
        [self initNavButtons];
        [self initLocationManager];
    }
    return self;
}

- (void)initLocationManager
{
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
}

- (void)initLocationView
{
    self.selectLocationView = [[CFMSelectLocationView alloc] init];
    CLLocation* location = [self.locationManager location];
    [self.selectLocationView setLatitude:location.coordinate.latitude];
    [self.selectLocationView setLongitude:location.coordinate.longitude];
    [self.selectLocationView setDelegate:self];
}

- (void)initNavButtons
{
    [[[CFMMessages instance] delegates] addObject:self];
    self.messagesButton = [[CFMMessagesButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [self.messagesButton addTarget:self action:@selector(messagesButtonPressed) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem* messages = [[UIBarButtonItem alloc] initWithCustomView:self.messagesButton];
    
    [self.navigationItem setRightBarButtonItems: @[ messages ]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    [self setView:self.selectLocationView];
}

- (void)messagesButtonPressed
{
    [self.delegate messagesPressedFromSelectLocationViewController:self];
}

- (void)startStandardLocationUpdates
{
    [self.locationManager startUpdatingLocation];
}

#pragma mark CFMSelectLocationViewDelegate
- (void)selectFriendsPressedFromSelectLocationView:(CFMSelectLocationView *)selectLocation
{
    [[[CFMUser instance] location] setCoordinates:[selectLocation markerPosition]];
    [[[CFMUser instance] location] setDescription:[self.selectLocationView locationDescription]];

    [self.delegate selectFriendsPressedFromSelectLocationViewController:self];
}

#pragma mark CFMMessagesDelegate
- (void)messagesDidLoad:(CFMMessages *)messages
{
    NSLog(@"count: %d", messages.count);
    [self.messagesButton.badge setCount:messages.count];
}

#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
    [self.selectLocationView moveCameraToLocation:newLocation];
    [self.locationManager stopUpdatingLocation];
}

@end
