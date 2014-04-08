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
        // Initialization code
        self.latitude = -33.86;
        self.longitude = 151.20;
        
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
    [self.onMayWayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.onMayWayButton.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    self.onMayWayButton.titleLabel.textColor = [UIColor blackColor];
    self.onMayWayButton.layer.borderColor = [[UIColor blackColor] CGColor];
    self.onMayWayButton.layer.borderWidth = 2.0f;
    self.onMayWayButton.backgroundColor = [UIColor yellowColor];
    [self.onMayWayButton addTarget:self action:@selector(onOnMyWayPressed) forControlEvents:UIControlEventTouchDown];
    [self addSubview:self.onMayWayButton];
}

- (void)initDescriptionView
{
    self.description = @"Lorem Ipsum foobar...";
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
    [self.mapView setCamera:_camera];
    [self.mapView setDelegate:self];
    [self addSubview:self.mapView];
    
    
    _marker = [[GMSMarker alloc] init];
    _marker.draggable = true;
    _marker.position = CLLocationCoordinate2DMake(self.latitude,
                                                  self.longitude);
    _marker.map = self.mapView;
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
    
    _mapViewFrame = upperFrame;
    _descriptionViewFrame = CGRectInset(_descriptionViewFrame, 10.0f, 5.0f);
    _onMyWayButtonFrame = CGRectInset(_onMyWayButtonFrame, _descriptionViewFrame.size.width / 5.0f, 10.0f);
    
    [self.mapView setFrame:upperFrame];
    [self.descriptionView setFrame:_descriptionViewFrame];
    [self.onMayWayButton setFrame:_onMyWayButtonFrame];
}

-(void)onOnMyWayPressed
{
    NSLog(@"On My Way!!");
}

@end