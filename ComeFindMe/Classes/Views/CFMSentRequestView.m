//
//  CFMSentRequestView.m
//  ComeFindMe
//
//  Created by travis elnicky on 4/21/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import "CFMSentRequestView.h"

@implementation CFMSentRequestView
{
    CGRect _mapViewFrame;
    CGRect _friendsTableFrame;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.coordinates = CLLocationCoordinate2DMake(-33.86, 151.20);
        self.markers = [[NSMutableArray alloc] init];

        [self initMapView];
        [self initFriendsTable];
        
    }
    return self;
}

- (void)initFriendsTable
{
    self.friendsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
    [self.friendsTable setDelegate:self];
    [self.friendsTable setBackgroundColor:[UIColor clearColor]];
    
    [self addSubview:self.friendsTable];
}

- (void)initMapView
{
    self.camera = [GMSCameraPosition cameraWithTarget:self.coordinates zoom:15];
    self.mapView = [[GMSMapView alloc] init];
    [self.mapView setMyLocationEnabled:true];
    [self.mapView setCamera:self.camera];
    [self.mapView setDelegate:self];
    [self addSubview:self.mapView];
    
    self.destinationMarker = [[GMSMarker alloc] init];
    self.destinationMarker.position = self.coordinates;
    self.destinationMarker.map = self.mapView;
    self.destinationMarker.icon = [GMSMarker markerImageWithColor:[UIColor redColor]];
    [self.markers addObject:self.destinationMarker];
    [self layoutMarkers];
}

- (void)addMarker:(GMSMarker*)marker
{
    [[self markers] addObject:marker];
    marker.map = self.mapView;
}

- (void)removeMarker:(GMSMarker*)marker
{
    [[self markers] removeObject:marker];
    marker.map = nil;
}

- (void)layoutMarkers
{
    for (GMSMarker* marker in self.markers) {
        marker.map = self.mapView;
    }
    [self setNeedsDisplay];
}

- (void)setCoordinates:(CLLocationCoordinate2D)coordinates
{
    _coordinates = coordinates;
    self.destinationMarker.position = coordinates;
    self.destinationMarker.title = @"destination";
    [self setCameraCoordinates:coordinates];
}

- (void)setCameraCoordinates:(CLLocationCoordinate2D)coordinates
{
    self.camera = [GMSCameraPosition cameraWithTarget:coordinates zoom:self.camera.zoom];
    [self.mapView setCamera:self.camera];
}

- (void)layoutSubviews
{
    CGRect frame = self.bounds;
    CGRect upperFrame = CGRectZero;
    CGRect lowerFrame = CGRectZero;
    _mapViewFrame = CGRectZero;
    _friendsTableFrame = CGRectZero;
    
    _mapViewFrame = frame;
    
    CGRectDivide(frame, &upperFrame, &lowerFrame, 3 * frame.size.height / 5.0f, CGRectMinYEdge);
    _friendsTableFrame = lowerFrame;
    CGSize tableContent = self.friendsTable.contentSize;
    if (_friendsTableFrame.size.height > tableContent.height) {

        _friendsTableFrame.origin.y += (_friendsTableFrame.size.height - tableContent.height);
        _friendsTableFrame.size.height = tableContent.height;
    }

    [self.friendsTable setFrame:_friendsTableFrame];
    [self.mapView setFrame:_mapViewFrame];
}

-(void)onFriendsButtonPressed
{
    [self layoutSubviews];
    [self setNeedsDisplay];
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate sentRequestView:self didSelectRowAtIndexPath:indexPath];
}

@end
