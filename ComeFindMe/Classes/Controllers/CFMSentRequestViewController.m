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
        self.markersDataSource = [[CFMMarkersDataSource alloc] init];
        self.markerDictionary = [[NSMutableDictionary alloc] init];

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
     setDataSource:self.markersDataSource];
    [self.sentRequestView setDelegate:self];
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
    for (CFMUser* user in self.message.receivers) {
        // create marker if it does not exist
        if (![self.markerDictionary objectForKey:[user.id stringValue]]) {
            GMSMarker* marker = [[GMSMarker alloc] init];
            marker.icon = [GMSMarker markerImageWithColor:[UIColor orangeColor]];
            [self.sentRequestView addMarker:marker];
            [self.markerDictionary setValue:marker forKey:[user.id stringValue]];
            marker.title = user.firstName;
        }
    }
    
    [self.markersDataSource setMarkers:self.sentRequestView.markers];
    [[self.sentRequestView friendsTable]
     setDataSource:self.markersDataSource];
    [self.sentRequestView.friendsTable reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.message setBroadcastsDelegate:self];
    [self.message loadBroadcasts];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.message setBroadcastsDelegate:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark CFMSentRequestViewDelegate
- (void)sentRequestView:(CFMSentRequestView *)sentRequestView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [sentRequestView.friendsTable deselectRowAtIndexPath:indexPath animated:true];
    
    GMSMarker* marker = [self.sentRequestView.markers objectAtIndex:[indexPath row]];
    [self.sentRequestView setCameraCoordinates:marker.position];
    [self.sentRequestView.mapView setSelectedMarker:marker];
}

#pragma mark CFMMessageBroadcastsDelegate
- (void)successfullyLoadedBroadcastsForMessage:(CFMMessage *)message
{
    bool updateDatasource = false;
    
    // update locations of users
    for (CFMBroadcast* broadcast in message.broadcasts)
    {
        if (![self.markerDictionary objectForKey:[broadcast.senderId stringValue]]) {
            // this should never happen but if it does add a marker
            GMSMarker* marker = [[GMSMarker alloc] init];
            marker.icon = [GMSMarker markerImageWithColor:[UIColor orangeColor]];
            [self.sentRequestView addMarker:marker];
            [self.markerDictionary setValue:marker forKey:[broadcast.senderId stringValue]];
            marker.title = broadcast.sender.firstName;
            
            updateDatasource = true;
        }
        
        GMSMarker* marker = [self.markerDictionary
                             objectForKey:[broadcast.senderId stringValue]];
        marker.position = broadcast.sender.currentLocation.coordinates;
    }
    
    if (updateDatasource) {
        [self updateDataSource];
    }

    // load broadcasts again
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self.message
                                   selector:@selector(loadBroadcasts)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)failedToLoadBroadcastsForMessage:(CFMMessage *)message
{
    // TODO: handle failed state
}


@end
