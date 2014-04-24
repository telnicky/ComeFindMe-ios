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
        [self initNavBarItems];
        [self initRequestView];
    }
    return self;
}

- (void)initNavBarItems
{
    UIBarButtonItem* date = [[UIBarButtonItem alloc] initWithTitle:@"mar 27" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [date setEnabled:false];
    [self.navigationItem setRightBarButtonItem:date];
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
    
    [message setBroadcastsDelegate:self];
    [self.message loadBroadcasts];
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

#pragma mark CFMMessageBroadcastsDelegate
- (void)successfullyLoadedBroadcastsForMessage:(CFMMessage *)message
{
    for (CFMBroadcast* broadcast in message.broadcasts)
    {
        if ([broadcast.senderId isEqualToValue:[CFMUser currentUser].id])
        {
            // we should be broadcasting
            [self.receiveRequestView setIsBroadcasting:true];
            [self setBroadcast:broadcast];
            [self.broadcast setDelegate:self];
            return;
        }
    }
    
    // no longer broadcasting
    [self setBroadcast:nil];
    [self.receiveRequestView setIsBroadcasting:false];
}

- (void)failedToLoadBroadcastsForMessage:(CFMMessage *)message
{
    // TODO: more error state
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
        // TODO:
    }
}

- (void)didSelectOnMyWayButtonForReceiveRequestView:(CFMReceiveRequestView*)receiverRequestView
{

    if (!self.receiveRequestView.isBroadcasting) {
        // create a broadcast it will fail if one exists so don't worry about that
        // It looks confusing but the sender of the message will be the
        // receiver of the broadcast
        CFMBroadcast* broadcast = [[CFMBroadcast alloc] init];
        [broadcast setMessageId:self.message.id];
        [broadcast setUserId:self.message.senderId];
        [broadcast setSenderId:self.message.userId];
        [broadcast setDelegate:self];
        [broadcast save];
        [self setBroadcast:broadcast];
    }
    else {
        [self.broadcast destroy];
        [self setBroadcast:nil];
    }
    
    // TODO: show a spinner?

}

#pragma mark CFMBroadcastDelegate
- (void)saveSuccessfulForBroadcast:(CFMBroadcast *)broadcast
{
    [[CFMUser currentUser] loadBroadcasts];
    [self.receiveRequestView setIsBroadcasting:true];
}

- (void)saveFailedForBroadcast:(CFMBroadcast *)broadcast
{
    [[CFMUser currentUser] loadBroadcasts];
    [self.receiveRequestView setIsBroadcasting:false];
}

- (void)destroySuccessfulForBroadcast:(CFMBroadcast *)broadcast
{
    [[CFMUser currentUser] loadBroadcasts];
    [self.receiveRequestView setIsBroadcasting:false];
}

- (void)destroyFailedForBroadcast:(CFMBroadcast *)broadcast
{
    [[CFMUser currentUser] loadBroadcasts];
    [self.receiveRequestView setIsBroadcasting:true];
}

@end
