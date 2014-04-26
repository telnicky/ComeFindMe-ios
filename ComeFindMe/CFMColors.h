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

// Hue Friends
#define MainColor1 0xffe454
#define MainColor2 0x54ff99
#define MainColor3 0x5495ff
#define MainColor4 0xff54e1

// Chroma Friends
#define Accent1  0xffea91
#define Accent2  0xfff0b8
#define Accent3  0xfff6d7
#define Accent4  0xfffbf1

#define Black     0x000000

#endif
