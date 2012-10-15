//
//  VNToolbar.h
//  Marine Weather
//
//  Created by submarine on 9/29/12.
//  Copyright (c) 2012 Valeriy Nikitin. Mistral LLC. All rights reserved.
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in
//    all copies or substantial portions of the Software.
//    Please contact developers@mistralservice.ru to purchase a license without copyright notice.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//    THE SOFTWARE.
//
//

#import <UIKit/UIKit.h>

#define kVNToolbarButtonSize 48
#define kVNToolbarButtonGap 4
#define kVNArrowScale 0.3

typedef NS_OPTIONS(NSUInteger, VNToolbarEdgeStyle) {
    VNToolbarEdgeStyleRoundedLeft = 1UL << 0, //-M_PI_2
    VNToolbarEdgeStyleRoundedRight = 1UL << 1,
    VNToolbarEdgeStyleRoundedAll = VNToolbarEdgeStyleRoundedLeft | VNToolbarEdgeStyleRoundedRight,
    VNToolbarEdgeStyleArrowLeft = 1UL << 2, //-M_PI_2
    VNToolbarEdgeStyleArrowRight = 1UL << 3,
    VNToolbarEdgeStyleArrowAll = VNToolbarEdgeStyleArrowLeft | VNToolbarEdgeStyleArrowRight,
    VNToolbarEdgeStyleNone = NSUIntegerMax
};

@interface VNToolbar : UIToolbar

@property (nonatomic) VNToolbarEdgeStyle edgeStyle;
@property (nonatomic, setter = setHorizontalMode:) BOOL isHorizontalMode; //-M_PI_2
@property (nonatomic, setter = setLeftSideMode:) BOOL isLeftSideMode; // align content to left side, or to right side
@property (nonatomic) BOOL sizeIsFixed;

- (id)initHorizontal:(BOOL)flag withFrame:(CGRect)frame;
/*!
 *  use this method to add bar element. 
 *  if you use standart method setItems: than be careful with elemement rotation
 *  according the bar style.
 */
- (void) setButtonsWithCustomButtons:(NSArray *)aButtons;

- (void) configure;
@end
