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
    CGRect _friendsButtonFrame;
    CGRect _friendsTableFrame;
    bool _friendsTableisVisible;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.coordinates = CLLocationCoordinate2DMake(-33.86, 151.20);
        self.markers = [[NSMutableArray alloc] init];

        [self initMapView];
        [self initButtonView];
        [self initFriendsTable];
        
    }
    return self;
}

- (void)initButtonView
{
    self.friendsButton = [[UIButton alloc] init];
    [self.friendsButton setTitle:@"Friends" forState:UIControlStateNormal];
    [self.friendsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.friendsButton.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    self.friendsButton.titleLabel.textColor = [UIColor blackColor];
    self.friendsButton.layer.borderColor = [[UIColor blackColor] CGColor];
    self.friendsButton.layer.borderWidth = 2.0f;
    self.friendsButton.backgroundColor = [UIColor yellowColor];
    [self.friendsButton addTarget:self action:@selector(onFriendsButtonPressed) forControlEvents:UIControlEventTouchDown];
    [self addSubview:self.friendsButton];
}

- (void)initFriendsTable
{
    _friendsTableisVisible = false;
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
    _friendsButtonFrame = CGRectZero;
    _friendsTableFrame = CGRectZero;
    
    _mapViewFrame = frame;
    
    if (_friendsTableisVisible)
    {
        CGRectDivide(frame, &upperFrame, &lowerFrame, 3 * frame.size.height / 5.0f, CGRectMinYEdge);
        _friendsTableFrame = lowerFrame;
        CGSize tableContent = self.friendsTable.contentSize;
        if (_friendsTableFrame.size.height > tableContent.height) {

            _friendsTableFrame.origin.y += (_friendsTableFrame.size.height - tableContent.height);
            _friendsTableFrame.size.height = tableContent.height;
        }
    }
    else
    {
        CGRectDivide(frame, &upperFrame, &lowerFrame, 4 * frame.size.height / 5.0f, CGRectMinYEdge);
        _friendsButtonFrame = CGRectInset(lowerFrame, lowerFrame.size.width / 5.0f, lowerFrame.size.height / 5.0f);
    }
    
    [self.friendsTable setFrame:_friendsTableFrame];
    [self.friendsButton setFrame:_friendsButtonFrame];
    [self.mapView setFrame:_mapViewFrame];
}

//- (void)layoutWithTable
//{
//    CGRect frame = self.bounds;
//    CGRect upperFrame = CGRectZero;
//    CGRect lowerFrame = CGRectZero;
//    _mapViewFrame = CGRectZero;
//    _friendsButtonFrame = CGRectZero;
//    _friendsTableFrame = CGRectZero;
//    
//    
//    CGRectDivide(frame, &upperFrame, &lowerFrame, 2 * frame.size.height / 5.0f, CGRectMinYEdge);
//    
//    _mapViewFrame = upperFrame;
//    _friendsTableFrame = lowerFrame;
//    
//    [self.mapView setFrame:upperFrame];
//    [self.friendsButton setFrame:_friendsButtonFrame];
//    [self.friendsTable setFrame:_friendsTableFrame];
//}
//
//- (void)layoutWithoutTable
//{
//    CGRect frame = self.bounds;
//    CGRect upperFrame = CGRectZero;
//    CGRect lowerFrame = CGRectZero;
//    _mapViewFrame = CGRectZero;
//    _friendsButtonFrame = CGRectZero;
//    _friendsTableFrame = CGRectZero;
//    
//    
//    CGRectDivide(frame, &upperFrame, &lowerFrame, 4 * frame.size.height / 5.0f, CGRectMinYEdge);
//    
//    _mapViewFrame = upperFrame;
//    _friendsButtonFrame = CGRectInset(lowerFrame, lowerFrame.size.width / 5.0f, lowerFrame.size.height / 5.0f);
//    
//    [self.mapView setFrame:upperFrame];
//    [self.friendsButton setFrame:_friendsButtonFrame];
//    [self.friendsTable setFrame:_friendsTableFrame];
//}

-(void)onFriendsButtonPressed
{
    _friendsTableisVisible = true;
    [self layoutSubviews];
    [self setNeedsDisplay];
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate sentRequestView:self didSelectRowAtIndexPath:indexPath];
}

#pragma mark GMSMapViewDelegate
- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    if (_friendsTableisVisible) {
        _friendsTableisVisible = false;
        [self layoutSubviews];
        [self setNeedsDisplay];
        return;
    }
}

@end
