//
//  CFMSelectLocationView.m
//  ComeFindMe
//
//  Created by travis elnicky on 4/4/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import "CFMSelectLocationView.h"

@implementation CFMSelectLocationView
{
    GMSMarker* _marker;
    GMSCameraPosition* _camera;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.latitude = -33.86;
        self.longitude = 151.20;


        _camera = [GMSCameraPosition cameraWithLatitude:self.latitude
                                              longitude:self.longitude
                                                   zoom:6];
        self.mapView = [[GMSMapView alloc] init];
        [self.mapView setCamera:_camera];
        [self addSubview:self.mapView];
        
        
        _marker = [[GMSMarker alloc] init];
        _marker.position = CLLocationCoordinate2DMake(self.latitude,
                                                      self.longitude);
        _marker.map = self.mapView;
    }
    return self;
}

- (void) layoutSubviews
{
    [self.mapView setFrame:self.bounds];
}

@end
