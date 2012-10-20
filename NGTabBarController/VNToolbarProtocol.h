//
//  VNToolbarProtocol.h
//  ShareKit
//
//  Created by submarine on 10/19/12.
//
//

#import <Foundation/Foundation.h>
#import "VNToolbarPosition.h"

typedef NS_OPTIONS(NSUInteger, VNToolbarEdgeStyle) {
    VNToolbarEdgeStyleRoundedLeft = 1UL << 0, //-M_PI_2
    VNToolbarEdgeStyleRoundedRight = 1UL << 1,
    VNToolbarEdgeStyleRoundedAll = VNToolbarEdgeStyleRoundedLeft | VNToolbarEdgeStyleRoundedRight,
    VNToolbarEdgeStyleArrowLeft = 1UL << 2, //-M_PI_2
    VNToolbarEdgeStyleArrowRight = 1UL << 3,
    VNToolbarEdgeStyleArrowAll = VNToolbarEdgeStyleArrowLeft | VNToolbarEdgeStyleArrowRight,
    VNToolbarEdgeStyleNone = NSUIntegerMax
};

@protocol VNToolbarProtocol <NSObject>
@property (nonatomic) VNToolbarEdgeStyle edgeStyle;
@property (nonatomic, assign) VNToolbarPosition toolbarPosition;
@property (nonatomic, setter = setHorizontalMode:) BOOL isHorizontalMode __attribute__((deprecated));//-M_PI_2
@property (nonatomic, setter = setLeftSideMode:) BOOL isLeftSideMode; // align content to left side, or to right side
@property (nonatomic) BOOL sizeIsFixed;
@property (nonatomic) UIBarStyle barStyle;


- (void) configure;
@optional
- (id)initHorizontal:(BOOL)flag withFrame:(CGRect)frame;
/*!
 *  use this method to add bar element.
 *  if you use standart method setItems: than be careful with elemement rotation
 *  according the bar style.
 */
- (void) setButtonsWithCustomButtons:(NSArray *)aButtons;

@end
