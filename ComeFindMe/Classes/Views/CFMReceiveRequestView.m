//
//  CFMReceiveRequestView.m
//  ComeFindMe
//
//  Created by travis elnicky on 4/6/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import "CFMReceiveRequestView.h"

@implementation CFMReceiveRequestView
{
    GMSMarker* _marker;
    GMSCameraPosition* _camera;
    CGRect _mapViewFrame;
    CGRect _descriptionViewFrame;
    CGRect _onMyWayButtonFrame;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isBroadcasting = false;
        [self initMapView];
        [self initDescriptionView];
        [self initButtonView];
    }
    return self;
}

- (void)initButtonView
{
    self.onMayWayButton = [[UIButton alloc] init];
    [self.onMayWayButton setTitle:@"On My Way" forState:UIControlStateNormal];
    [self.onMayWayButton setTitle:@"Broadcasting location" forState:UIControlStateSelected];
    [self.onMayWayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.onMayWayButton.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    self.onMayWayButton.titleLabel.textColor = [UIColor blackColor];
    self.onMayWayButton.layer.borderColor = [[UIColor blackColor] CGColor];
    self.onMayWayButton.layer.borderWidth = 2.0f;
    self.onMayWayButton.backgroundColor = UIColorFromRGB(MainColor);
    [self.onMayWayButton addTarget:self action:@selector(onOnMyWayPressed) forControlEvents:UIControlEventTouchDown];
    [self addSubview:self.onMayWayButton];
}

- (void)initDescriptionView
{
    self.description = @"No description...";
    self.descriptionView = [[UITextView alloc] init];
    self.descriptionView.editable = false;
    self.descriptionView.layer.borderWidth = 2.0f;
    self.descriptionView.layer.borderColor = [[UIColor blackColor] CGColor];
    self.descriptionView.font = [UIFont systemFontOfSize:16.0f];
    self.descriptionView.returnKeyType = UIReturnKeyDefault;
    self.descriptionView.delegate = self;
    self.descriptionView.text = self.description;
    self.descriptionView.textColor = [UIColor blackColor];
    [self addSubview:self.descriptionView];
}

- (void)initMapView
{
    _camera = [GMSCameraPosition cameraWithLatitude:self.latitude
                                          longitude:self.longitude
                                               zoom:15];
    self.mapView = [[GMSMapView alloc] init];
    [self.mapView setMyLocationEnabled:true];
    [self.mapView setCamera:_camera];
    [self.mapView setDelegate:self];
    [self addSubview:self.mapView];
    
    
    _marker = [[GMSMarker alloc] init];
    _marker.draggable = true;
    _marker.position = CLLocationCoordinate2DMake(self.latitude,
                                                  self.longitude);
    _marker.map = self.mapView;
}

- (void)setDescription:(NSString *)description
{
    _description = description;
    if (description && ![description isEqualToString:@""]) {
        [self.descriptionView setText:description];
        [self.descriptionView setNeedsDisplay];
    }

}

- (void)setLatitude:(float)latitude
{
    _latitude = latitude;
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    _marker.position = coordinate;
    _camera = [GMSCameraPosition cameraWithTarget:coordinate zoom:_camera.zoom];
    [self.mapView setCamera:_camera];
}

- (void)setLongitude:(float)longitude
{
    _longitude = longitude;
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    _marker.position = coordinate;
    _camera = [GMSCameraPosition cameraWithTarget:coordinate zoom:_camera.zoom];
    [self.mapView setCamera:_camera];
}

- (void)layoutSubviews
{
    CGRect frame = self.bounds;
    CGRect upperFrame = CGRectZero;
    CGRect lowerFrame = CGRectZero;
    _mapViewFrame = CGRectZero;
    _descriptionViewFrame = CGRectZero;
    _onMyWayButtonFrame = CGRectZero;
    
    CGRectDivide(frame, &upperFrame, &lowerFrame, 2 * frame.size.height / 3.0f, CGRectMinYEdge);
    CGRectDivide(lowerFrame, &_descriptionViewFrame, &_onMyWayButtonFrame, lowerFrame.size.height * 0.5f, CGRectMinYEdge);
    
    _mapViewFrame = frame;
    _descriptionViewFrame = CGRectInset(_descriptionViewFrame, 10.0f, 5.0f);
    _onMyWayButtonFrame = CGRectInset(_onMyWayButtonFrame, _descriptionViewFrame.size.width / 5.0f, 10.0f);
    
    [self.mapView setFrame:_mapViewFrame];
    [self.descriptionView setFrame:_descriptionViewFrame];
    [self.onMayWayButton setFrame:_onMyWayButtonFrame];
}

-(void)onOnMyWayPressed
{
    self.onMayWayButton.enabled = false;
    [self.delegate didSelectOnMyWayButtonForReceiveRequestView:self];
}

- (void)setIsBroadcasting:(bool)isBroadcasting
{
    _isBroadcasting = isBroadcasting;
    
    if (isBroadcasting) {
        // TODO: may need to update button here

    }

    self.onMayWayButton.selected = isBroadcasting;
    self.onMayWayButton.enabled = true;
}

#pragma mark GMSMapViewDelegate
- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    [self.delegate didTapMapViewOnReceiveRequestView:self];
}

@end
