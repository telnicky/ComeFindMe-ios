//
//  CFMBadgeView.m
//  ComeFindMe
//
//  Created by travis elnicky on 4/14/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import "CFMBadgeView.h"

@implementation CFMBadgeView
{
    UILabel* _countLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _countLabel = [[UILabel alloc] init];
        [_countLabel setTextColor:[UIColor whiteColor]];
        [_countLabel setAdjustsFontSizeToFitWidth:true];
        [_countLabel setTextAlignment:NSTextAlignmentCenter];
        [_countLabel setNumberOfLines:1];
        [_countLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
        [_countLabel setFont:[UIFont boldSystemFontOfSize:12]];
        
        [self addSubview:_countLabel];

        self.count = 0;
        
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)setCount:(int)count
{
    _count = count;
    
    if (count < 100) {
        [_countLabel setText:[NSString stringWithFormat:@"%d", count]];
    } else {
        [_countLabel setText:[NSString stringWithFormat:@"%d", 99]];
    }
    
    [self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect frame = self.bounds;

    if (frame.size.height != frame.size.width) {
        float side = fminf(frame.size.height, frame.size.width);
        frame.size.height = side;
        frame.size.width = side;
    }
    
    CGRect outerFillFrame = frame;
    CGRect innerFillFrame = CGRectInset(outerFillFrame, outerFillFrame.size.width * 0.03f, outerFillFrame.size.height * 0.03f);
    CGRect countFrame = innerFillFrame;
    

    if (self.count > 0) {
        [[UIColor redColor] setFill];
        CGContextFillEllipseInRect(context, frame);
        
        [_countLabel setFrame:countFrame];
    }
}


@end
