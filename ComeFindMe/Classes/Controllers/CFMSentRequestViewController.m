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
        self.user = [CFMUser currentUser];
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
    [self.sentRequestView setDelegate:self];

    [[self.sentRequestView friendsTable]
     setDataSource:self.markersDataSource];

    [self.markersDataSource turnOnMarker:self.sentRequestView.destinationMarker];
    [self.markerDictionary setValue:self.sentRequestView.destinationMarker
                             forKey:self.sentRequestView.destinationMarker.title];
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
            [self.markerDictionary setValue:marker forKey:[user.id stringValue]];
            marker.title = user.firstName;
            marker.userData = [[NSMutableDictionary alloc] init];
            [self.sentRequestView.markers addObject:marker];
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
    [self.message.location setBroadcastsDelegate:self];
    [self.message.location loadBroadcasts];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.message.location setBroadcastsDelegate:nil];
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

#pragma mark CFMLocationBroadcastsDelegate
- (void)successfullyLoadedBroadcastsForLocation:(CFMLocation*)location
{
    
    NSMutableArray* userIds = [[NSMutableArray alloc] init];
    [userIds addObject:self.sentRequestView.destinationMarker.title];
    
    // update locations of users
    for (CFMBroadcast* broadcast in location.broadcasts)
    {
        // create marker if it does not exist
        if (![self.markerDictionary objectForKey:[broadcast.senderId stringValue]]) {
            GMSMarker* marker = [[GMSMarker alloc] init];
            marker.icon = [GMSMarker markerImageWithColor:[UIColor orangeColor]];
            [self.markerDictionary setValue:marker forKey:[broadcast.senderId stringValue]];
            marker.title = broadcast.sender.firstName;
            marker.userData = [[NSMutableDictionary alloc] init];
        }
        
        [userIds addObject:[broadcast.senderId stringValue]];
        GMSMarker* marker = [self.markerDictionary
                             objectForKey:[broadcast.senderId stringValue]];

        marker.position = broadcast.sender.currentLocation.coordinates;
        
        if (CLLocationCoordinate2DIsValid(marker.position))
        {
            [self.sentRequestView turnOnMarker:marker];
            [self.markersDataSource turnOnMarker:marker];
        }
    }
    
    NSMutableArray* deletedBroadcasts = [self.markerDictionary.allKeys mutableCopy];
    [deletedBroadcasts removeObjectsInArray:userIds];
    
    for (NSString* deletedBroadcastId in deletedBroadcasts)
    {
        GMSMarker* marker = [self.markerDictionary objectForKey:deletedBroadcastId];
        [self.sentRequestView turnOffMarker:marker];
        [self.markersDataSource turnOffMarker:marker];
    }
    
    // load broadcasts again
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:location
                                   selector:@selector(loadBroadcasts)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)failedToLoadBroadcastsForLocation:(CFMLocation*)location
{
    // lets try again in 10 seconds
    [NSTimer scheduledTimerWithTimeInterval:10.0f
                                     target:location
                                   selector:@selector(loadBroadcasts)
                                   userInfo:nil
                                    repeats:NO];
}


@end
