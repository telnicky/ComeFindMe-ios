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
    GMSMarker* _marker;
    GMSCameraPosition* _camera;
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
    [self addSubview:self.friendsTable];
}

- (void)initMapView
{
    _camera = [GMSCameraPosition cameraWithTarget:self.coordinates zoom:15];
    self.mapView = [[GMSMapView alloc] init];
    [self.mapView setMyLocationEnabled:true];
    [self.mapView setCamera:_camera];
    [self.mapView setDelegate:self];
    [self addSubview:self.mapView];
    
    _marker = [[GMSMarker alloc] init];
    _marker.draggable = true;
    _marker.position = self.coordinates;
    _marker.map = self.mapView;
}

- (void)setCoordinates:(CLLocationCoordinate2D)coordinates
{
    _coordinates = coordinates;
    _marker.position = coordinates;
    _camera = [GMSCameraPosition cameraWithTarget:coordinates zoom:_camera.zoom];
    [self.mapView setCamera:_camera];
}

- (void)layoutSubviews
{
    if (_friendsTableisVisible)
    {
        // layout with table
        [self layoutWithTable];
    }
    else
    {
        // layout without table
        [self layoutWithoutTable];
    }
}

- (void)layoutWithTable
{
    CGRect frame = self.bounds;
    CGRect upperFrame = CGRectZero;
    CGRect lowerFrame = CGRectZero;
    _mapViewFrame = CGRectZero;
    _friendsButtonFrame = CGRectZero;
    _friendsTableFrame = CGRectZero;
    
    
    CGRectDivide(frame, &upperFrame, &lowerFrame, 2 * frame.size.height / 5.0f, CGRectMinYEdge);
    
    _mapViewFrame = upperFrame;
    _friendsTableFrame = lowerFrame;
    
    [self.mapView setFrame:upperFrame];
    [self.friendsButton setFrame:_friendsButtonFrame];
    [self.friendsTable setFrame:_friendsTableFrame];
}

- (void)layoutWithoutTable
{
    CGRect frame = self.bounds;
    CGRect upperFrame = CGRectZero;
    CGRect lowerFrame = CGRectZero;
    _mapViewFrame = CGRectZero;
    _friendsButtonFrame = CGRectZero;
    _friendsTableFrame = CGRectZero;
    
    
    CGRectDivide(frame, &upperFrame, &lowerFrame, 4 * frame.size.height / 5.0f, CGRectMinYEdge);
    
    _mapViewFrame = upperFrame;
    _friendsButtonFrame = CGRectInset(lowerFrame, lowerFrame.size.width / 5.0f, lowerFrame.size.height / 5.0f);
    
    [self.mapView setFrame:upperFrame];
    [self.friendsButton setFrame:_friendsButtonFrame];
    [self.friendsTable setFrame:_friendsTableFrame];
}

-(void)onFriendsButtonPressed
{
    _friendsTableisVisible = true;
    [self layoutSubviews];
    [self setNeedsDisplay];
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
