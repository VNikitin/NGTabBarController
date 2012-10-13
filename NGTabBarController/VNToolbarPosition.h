//
//  VNToolbarPosition.h
//
//  Created by SubMarine on 9/29/12.
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
//    Please contact developers@mistralservice.ru to purchase a license without
//    copyright notice.
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


/*
 *  enum for VNToolbarPosition position
 *  Dynamic - toolbar position is clockwise according to tabbar position. 
 *  Ex. if NGTabBarPositionRight, than  VNToolbarPositionBottom, if 
 *  NGTabBarPositionBottom, than VNToolbarPositionLeft
 *  Fixed - toolbar position is always fixed. If NGTabBarPositionRight and 
 *  VNToolbarPositionFixedRight than toolbar is under tabbar
 */
#import "NGTabBarPosition.h"

typedef NS_OPTIONS(NSUInteger, VNToolbarPosition) {
    VNToolbarPositionTop                = 1,
    VNToolbarPositionBottom             = 2,
    VNToolbarPositionRight              = 3,
    VNToolbarPositionLeft               = 4,
    VNToolbarPositionDynamicOpposite    = 5,
    VNToolbarPositionDynamicLeft        = 6,
    VNToolbarPositionDynamicRight       = 7,
};

#define kVNToolbarPositionDefault    VNToolbarPositionDynamicOpposite

//TODO: add NGTabBarIsVertical to compare

NS_INLINE BOOL VNToolbarIsVertical(VNToolbarPosition position, NGTabBarPosition tabBarPosition) {
    return position == VNToolbarPositionRight || position == VNToolbarPositionLeft || (NGTabBarIsVertical(tabBarPosition) && position == VNToolbarPositionDynamicOpposite);
}

NS_INLINE BOOL VNToolbarIsHorizontal(VNToolbarPosition position, NGTabBarPosition tabBarPosition) {
    return position == VNToolbarPositionTop || position == VNToolbarPositionBottom || (NGTabBarIsHorizontal(tabBarPosition) && (position == VNToolbarPositionDynamicRight || position == VNToolbarPositionDynamicLeft));
}

NS_INLINE BOOL VNToolbarRealPosition (VNToolbarPosition position, NGTabBarPosition tabBarPosition) {
    VNToolbarPosition realPosition;
    switch (position) {
        case VNToolbarPositionBottom:
        case VNToolbarPositionLeft:
        case VNToolbarPositionRight:
        case VNToolbarPositionTop:
            realPosition = position;
            break;
        case VNToolbarPositionDynamicOpposite: {
            switch (tabBarPosition) {
                case NGTabBarPositionBottom:
                    realPosition = VNToolbarPositionTop;
                    break;
                case NGTabBarPositionLeft:
                    realPosition = VNToolbarPositionRight;
                    break;
                case NGTabBarPositionRight:
                    realPosition = VNToolbarPositionLeft;
                    break;
                case NGTabBarPositionTop:
                    realPosition = VNToolbarPositionBottom;
                    break;
            }
        }
            break;
        case VNToolbarPositionDynamicLeft: {
            switch (tabBarPosition) {
                case NGTabBarPositionBottom:
                    realPosition = VNToolbarPositionLeft;
                    break;
                case NGTabBarPositionLeft:
                    realPosition = VNToolbarPositionTop;
                    break;
                case NGTabBarPositionRight:
                    realPosition = VNToolbarPositionBottom;
                case NGTabBarPositionTop:
                    realPosition = VNToolbarPositionRight;
            }
        }
            break;
        case VNToolbarPositionDynamicRight: {
            switch (tabBarPosition) {
                case NGTabBarPositionBottom:
                    realPosition = VNToolbarPositionRight;
                    break;
                case NGTabBarPositionLeft:
                    realPosition = VNToolbarPositionBottom;
                    break;
                case NGTabBarPositionRight:
                    realPosition = VNToolbarPositionTop;
                case NGTabBarPositionTop:
                    realPosition = VNToolbarPositionLeft;
            }
        }
            break;
    }
    return realPosition;
}
