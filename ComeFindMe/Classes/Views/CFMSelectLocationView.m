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
    BOOL _keyboardIsVisible;
    CGRect _mapViewFrame;
    CGRect _descriptionViewFrame;
    CGRect _selectFriendsButtonFrame;
    NSString* _placeHolderText;
    float _originalY;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _originalY = 0;

        [self initMapView];
        [self initDescriptionView];
        [self initButtonView];
        

        // Keyboard events
        _keyboardIsVisible = false;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];

    }
    return self;
}

- (void)initButtonView
{
    self.selectFriendsButton = [[UIButton alloc] init];
    [self.selectFriendsButton setTitle:@"Select Friends" forState:UIControlStateNormal];
    [self.selectFriendsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.selectFriendsButton.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    self.selectFriendsButton.titleLabel.textColor = [UIColor blackColor];
    self.selectFriendsButton.layer.borderColor = [[UIColor blackColor] CGColor];
    self.selectFriendsButton.layer.borderWidth = 2.0f;
    self.selectFriendsButton.backgroundColor = [UIColor yellowColor];
    [self.selectFriendsButton addTarget:self action:@selector(onSelectFriendsPressed) forControlEvents:UIControlEventTouchDown];
    [self addSubview:self.selectFriendsButton];
}

- (void)initDescriptionView
{
    _placeHolderText = @"Description...";
    self.descriptionView = [[UITextView alloc] init];
    self.descriptionView.editable = true;
    self.descriptionView.layer.borderWidth = 2.0f;
    self.descriptionView.layer.borderColor = [[UIColor blackColor] CGColor];
    self.descriptionView.font = [UIFont systemFontOfSize:16.0f];
    self.descriptionView.returnKeyType = UIReturnKeyDefault;
    self.descriptionView.delegate = self;
    self.descriptionView.text = _placeHolderText;
    self.descriptionView.textColor = [UIColor lightGrayColor];
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
    [self.mapView setMyLocationEnabled:true];
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
    _selectFriendsButtonFrame = CGRectZero;
    
    CGRectDivide(frame, &upperFrame, &lowerFrame, 2 * frame.size.height / 3.0f, CGRectMinYEdge);
    CGRectDivide(lowerFrame, &_descriptionViewFrame, &_selectFriendsButtonFrame, lowerFrame.size.height * 0.5f, CGRectMinYEdge);
    
    _mapViewFrame = upperFrame;
    _descriptionViewFrame = CGRectInset(_descriptionViewFrame, 10.0f, 5.0f);
    _selectFriendsButtonFrame = CGRectInset(_selectFriendsButtonFrame, _descriptionViewFrame.size.width / 5.0f, 10.0f);
    
    [self.mapView setFrame:upperFrame];
    [self.descriptionView setFrame:_descriptionViewFrame];
    [self.selectFriendsButton setFrame:_selectFriendsButtonFrame];
}

- (void)moveCameraToLocation:(CLLocation*)location
{
    GMSCameraPosition* camera = [GMSCameraPosition cameraWithTarget:location.coordinate zoom:_camera.zoom];
    [self.mapView animateToCameraPosition:camera];
    _camera = camera;
    
    [_marker setPosition:location.coordinate];
}

- (void)keyboardWillHide
{
    CGRect newFrame = self.frame;
    newFrame.origin.y = _originalY;
    [self setFrame:newFrame];
    [self layoutSubviews];
    _keyboardIsVisible = false;
}

- (void)keyboardWillShow:(NSNotification*)notification
{
    _originalY = self.frame.origin.y;
    
    float scrollY = -self.descriptionView.frame.size.height;
    CGRect newFrame = self.frame;
    newFrame.origin.y = scrollY;
    [self setFrame:newFrame];

    _keyboardIsVisible = true;
}

- (NSString*)locationDescription
{
    if ([self.descriptionView.text isEqualToString:_placeHolderText]) {
        return @"";
    }
    return self.descriptionView.text;
}

- (CLLocationCoordinate2D)markerPosition
{
    return _marker.position;
}

- (void)onSelectFriendsPressed
{
    NSLog(@"Select Friends!!");
    [self.delegate selectFriendsPressedFromSelectLocationView:self];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.descriptionView endEditing:true];
}

#pragma mark GMSMapViewDelegate

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    if (_keyboardIsVisible) {
        [self.descriptionView endEditing:true];
        return;
    }

    [_marker setPosition:coordinate];
    NSLog(@"coordinates: %f,%f", coordinate.latitude, coordinate.longitude);
}

- (void)mapView:(GMSMapView *)mapView
didChangeCameraPosition:(GMSCameraPosition *)position
{
    // TODO: fix the marker over the center
}

#pragma mark UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:_placeHolderText]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }

    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = _placeHolderText;
        textView.textColor = [UIColor lightGrayColor];
    }
    
    [textView resignFirstResponder];
}

@end
