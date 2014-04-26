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
    GMSCameraPosition* _camera;
    BOOL _keyboardIsVisible;
    CGRect _mapViewFrame;
    CGRect _descriptionViewFrame;
    CGRect _selectFriendsButtonFrame;
    CGRect _markerFrame;
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
    self.selectFriendsButton.backgroundColor = UIColorFromRGB(MainColor1);
    [self.selectFriendsButton addTarget:self action:@selector(onSelectFriendsPressed) forControlEvents:UIControlEventTouchDown];
//    [self.selectFriendsButton setHidden:true];
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
//    [self.descriptionView setHidden:true];
    [self.descriptionView setBackgroundColor:UIColorFromRGB(Accent4)];
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
    
    self.marker = [[UIImageView alloc]
                   initWithImage:[GMSMarker markerImageWithColor:[UIColor redColor]]];
    
    // set position to the point of the marker image
    [self.marker.layer setAnchorPoint:CGPointMake(0.5f, 1.0f)];
    
    [self.mapView addSubview:self.marker];
}

- (void)layoutSubviews
{
    CGRect frame = self.bounds;
    CGRect upperFrame = CGRectZero;
    CGRect lowerFrame = CGRectZero;
    _mapViewFrame = CGRectZero;
    _descriptionViewFrame = CGRectZero;
    _selectFriendsButtonFrame = CGRectZero;
    _markerFrame = CGRectZero;
    
    
    CGRectDivide(frame, &upperFrame, &lowerFrame, 2 * frame.size.height / 3.0f, CGRectMinYEdge);
    CGRectDivide(lowerFrame, &_descriptionViewFrame, &_selectFriendsButtonFrame, lowerFrame.size.height * 0.5f, CGRectMinYEdge);
    
    _mapViewFrame = frame;
    _markerFrame.size = self.marker.image.size;
    _markerFrame.origin = self.center;
    _markerFrame.origin.x -= _markerFrame.size.width * 0.5f;
    _markerFrame.origin.y = self.bounds.size.height * 0.25f;

    _descriptionViewFrame = CGRectInset(_descriptionViewFrame, 10.0f, 5.0f);
    _selectFriendsButtonFrame = CGRectInset(_selectFriendsButtonFrame, _descriptionViewFrame.size.width / 5.0f, 10.0f);
    

    [self.mapView setFrame:_mapViewFrame];
    [self.marker setFrame:_markerFrame];
    [self.descriptionView setFrame:_descriptionViewFrame];
    [self.selectFriendsButton setFrame:_selectFriendsButtonFrame];
}

- (void)moveCameraToLocation:(CLLocation*)location
{
    GMSCameraPosition* camera = [GMSCameraPosition cameraWithTarget:location.coordinate zoom:_camera.zoom];
    [self.mapView animateToCameraPosition:camera];
    _camera = camera;
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
    return [[self.mapView projection] coordinateForPoint:self.marker.layer.position];
}

- (void)onSelectFriendsPressed
{
    [self.delegate selectFriendsPressedFromSelectLocationView:self];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.descriptionView endEditing:true];
}

- (void)showDescritionAndButton
{
    [self.selectFriendsButton setHidden:false];
    [self.descriptionView setHidden:false];

    [UIView animateWithDuration:1.0 animations:^{
        [self.selectFriendsButton setAlpha:1];
        [self.descriptionView setAlpha:1];
    }];
}

#pragma mark GMSMapViewDelegate

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    if (_keyboardIsVisible) {
        [self.descriptionView endEditing:true];
        return;
    }
}

- (void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture
{
//    [UIView animateWithDuration:1.0 animations:^{
//        [self.selectFriendsButton setAlpha:0];
//        [self.descriptionView setAlpha:0];
//    } completion: ^(BOOL finished) {
//        [self.selectFriendsButton setHidden:finished];
//        [self.descriptionView setHidden:finished];
//    }];
}

- (void)mapView:(GMSMapView *)mapView
idleAtCameraPosition:(GMSCameraPosition *)position
{
//    [NSTimer scheduledTimerWithTimeInterval:1.8
//                                     target:self
//                                   selector:@selector(showDescritionAndButton)
//                                   userInfo:nil
//                                    repeats:NO];
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
