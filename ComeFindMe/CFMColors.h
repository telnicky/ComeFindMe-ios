//
//  CFMColors.h
//  ComeFindMe
//
//  Created by travis elnicky on 4/24/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#ifndef ComeFindMe_CFMColors_h
#define ComeFindMe_CFMColors_h
// TODO: use this to define the colors we want
#define UIColorFromRGB(rgbValue) \
    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                    green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                     blue:((float)(rgbValue & 0xFF))/255.0 \
                    alpha:1.0f]

#define MainColor 0xffe454
#define Accent1   0x54ff99
#define Accent2   0x5495ff
#define Accent3   0xff54e1

#define Black 0x000000

#endif
