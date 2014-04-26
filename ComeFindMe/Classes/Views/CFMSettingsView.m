//
//  CFMSettingsView.m
//  ComeFindMe
//
//  Created by travis elnicky on 4/20/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import "CFMSettingsView.h"

@implementation CFMSettingsView
{
    NSString* _glyphishAttribution;
    NSString* _googleAttribution;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _glyphishAttribution = @"Icons by Glyphish\nwww.glyphish.com\n\n";
        _googleAttribution =  [GMSServices openSourceLicenseInfo];
        [self initAttributionView];
        
        self.logoutView = [[FBLoginView alloc] init];
        [self.logoutView setDelegate:self];
        [self addSubview:self.logoutView];
    }
    return self;
}

- (void)initAttributionView
{
    self.attribution = [[UITextView alloc] init];
    self.attribution.text = [_glyphishAttribution
                             stringByAppendingString:_googleAttribution];
    self.attribution.editable = false;
    self.attribution.font = [UIFont systemFontOfSize:16.0f];
    self.attribution.returnKeyType = UIReturnKeyDefault;
    self.attribution.textColor = [UIColor blackColor];
    [self addSubview:self.attribution];
}

- (void)layoutSubviews
{
    CGRect frame = self.bounds;
    CGRect upperFrame = CGRectZero;
    CGRect lowerFrame = CGRectZero;
    
    CGRectDivide(frame, &upperFrame, &lowerFrame, self.logoutView.frame.size.height, CGRectMinYEdge);

    [self.logoutView setFrame:upperFrame];
    [self.attribution setFrame:lowerFrame];
}

#pragma mark FBLoginViewDelegate
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    [self.delegate loggedOutUserFromSettingsView:self];
}

@end
