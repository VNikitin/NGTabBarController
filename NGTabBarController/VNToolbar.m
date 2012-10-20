//
//  VNToolbar.m
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

#import "VNToolbar.h"
#import <QuartzCore/QuartzCore.h>

@interface VNToolbar () {
    CGAffineTransform _baseTransform;
    CGRect _initFrame;
    CGAffineTransform _appliedTransform;
}
@property (nonatomic, retain)     NSMutableArray *buttonsArray;

UIImage* _rotateByRadians(UIImage* sourceImage, CGFloat angleInRadians);
- (UIImage *)resizedImage:(UIImage *) anImage withContentMode:(UIViewContentMode)contentMode bounds:(CGSize)bounds interpolationQuality:(CGInterpolationQuality)quality;
@end

@implementation VNToolbar
@synthesize edgeStyle = _edgeStyle;
@synthesize isHorizontalMode = _isHorizontalMode;
@synthesize buttonsArray = _buttonsArray;
@synthesize isLeftSideMode = _isLeftSideMode;
@synthesize toolbarPosition = _toolbarPosition;
@synthesize sizeIsFixed = _sizeIsFixed;

#pragma mark - Accessors
- (void) setFrame:(CGRect)frame {
    _initFrame = frame;
    [self setBounds:CGRectMake(0, 0, frame.size.width, frame.size.height)];
}

- (void) setBounds:(CGRect)bounds {
    CGRect newBounds;
    if (!_isHorizontalMode) {
        newBounds = CGRectMake(0, 0, bounds.size.height, bounds.size.width);
    } else {
        newBounds = bounds;
    }
    [super setBounds:newBounds];
}

- (void) setButtonsWithCustomButtons:(NSArray *)aButtons {
    [self.buttonsArray setArray: [self elementsForButton:aButtons]];
    [self setItems:self.buttonsArray animated:FALSE];
}

- (void) setHorizontalMode:(BOOL)aMode {
    if (_isHorizontalMode != aMode) {
        _isHorizontalMode = aMode;
    }
}

- (void) setEdgeStyle:(VNToolbarEdgeStyle)anEdgeStyle {
    if (_edgeStyle != anEdgeStyle) {
        _edgeStyle = anEdgeStyle;
    }
}
- (void) setTransform:(CGAffineTransform)transform {
    transform = CGAffineTransformConcat(transform, _baseTransform);
    [super setTransform:transform];
}
- (void) setToolbarPosition:(VNToolbarPosition)toolbarPosition {
    if (toolbarPosition != _toolbarPosition) {
        _toolbarPosition = toolbarPosition;
        switch (toolbarPosition) {
            case VNToolbarPositionTop:
            case VNToolbarPositionBottom:
                _isHorizontalMode = TRUE;
                break;
            case VNToolbarPositionLeft:
                _isHorizontalMode = FALSE;
                break;
            case VNToolbarPositionRight:
                _isHorizontalMode = FALSE;
                break;
            default:
                break;
        }
    }
}

#pragma mark - Overriden
- (void) setItems:(NSArray *)items {
    [self setItems:items animated:FALSE];
}
- (void) setItems:(NSArray *)items animated:(BOOL)animated {
    [super setItems:items animated:animated];
    [self.buttonsArray setArray: items];
}
- (void) setSizeIsFixed:(BOOL)sizeIsFixed {
    if (_sizeIsFixed != sizeIsFixed) {
        _sizeIsFixed = sizeIsFixed;
    }
}
- (void) sizeToFit {
    [self configure];
}
#pragma mark - Init & Memory
- (void) toolbarInit {
    _edgeStyle = VNToolbarEdgeStyleNone;
    _baseTransform = CGAffineTransformIdentity;
    _appliedTransform = CGAffineTransformIdentity;
    [self setBarStyle:UIBarStyleDefault];
    self.buttonsArray = [NSMutableArray array];
    _sizeIsFixed = TRUE;
    _isLeftSideMode = TRUE;
}

- (id)initHorizontal:(BOOL)flag withFrame:(CGRect)frame {
    _isHorizontalMode = flag;
    self = [super initWithFrame:frame];
    if (self) {
        [self toolbarInit];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame {
    if ((frame.size.width / frame.size.height) < 1.5) {
        return [self initHorizontal:FALSE withFrame:frame];
    } else {
        return [self initHorizontal:TRUE withFrame:frame];
    }
}

#pragma mark - Add/Remove Items

- (NSArray *) elementsForButton:(NSArray *) aButtons {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[aButtons count]];
    for (UIButton *button in aButtons) {
        UIBarButtonItem *newItem = nil;
        if ([button isKindOfClass:[UIView class]]) {
            newItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        } else if ([button isKindOfClass:[UIImage class]])
        if (newItem) {
            [result addObject:newItem];
        }
    }
    return result;
}

- (void) addItemToToolbar:(UIBarButtonItem *) newItem atIndex:(NSInteger)anIndex {
    if (!newItem) {
        return;
    }
    if (anIndex < 0) {
        anIndex = 0;
    } else if (anIndex > [self.items count]) {
        anIndex = [self.items count];
    }
    
    NSMutableArray *newItems = [NSMutableArray arrayWithArray:self.items];
    if (!newItems) {
        newItems = [NSMutableArray array];
    }
    [newItems insertObject:newItem atIndex:anIndex];
    [super setItems:newItems animated:FALSE];
}

- (void) removeItemFromToolBar:(UIBarButtonItem *) oldItem {
    NSMutableArray *newItems = [NSMutableArray arrayWithArray:self.items];
    if (!newItems) {
        return;
    }
    [newItems removeObject:oldItem];
    [super setItems: newItems animated:FALSE];
}

- (void) reArrangeItems {
        NSMutableArray *reversedArray = [NSMutableArray arrayWithCapacity:[self.buttonsArray count]];
        NSEnumerator *enumerator = [self.buttonsArray reverseObjectEnumerator];
        for (id element in enumerator) {
            [reversedArray addObject:element];
        }
        [super setItems:reversedArray animated:FALSE];
}

#pragma mark - Configure
- (void) configure {
    _baseTransform = CGAffineTransformIdentity;
    //preserve toolbar gradient
    if (_toolbarPosition == VNToolbarPositionRight) {
        _baseTransform = CGAffineTransformRotate(_baseTransform, - 1 * M_PI_2);
    } else if (_toolbarPosition == VNToolbarPositionLeft) {
        _baseTransform = CGAffineTransformRotate(_baseTransform, M_PI_2);
    }
    [self updateLayoutForButtons];
    [self updateLayout];
    
    self.layer.mask = nil;

    switch (_edgeStyle) {
        case VNToolbarEdgeStyleRoundedAll:
            self.layer.mask = [self createRoundedClip];
            break;
        case VNToolbarEdgeStyleRoundedRight:
            if (_toolbarPosition == VNToolbarPositionRight) {
                self.layer.mask = [self createLeftRoundedClip];
            } else {
                self.layer.mask = [self createRightRoundedClip];
            }
            break;
        case VNToolbarEdgeStyleRoundedLeft:
            if (_toolbarPosition == VNToolbarPositionRight) {
                self.layer.mask = [self createRightRoundedClip];
            } else {
                self.layer.mask = [self createLeftRoundedClip];
            }
            break;
        case VNToolbarEdgeStyleArrowLeft:
            if (_toolbarPosition == VNToolbarPositionRight) {
                self.layer.mask = [self createRightArrowClip];
            } else {
                self.layer.mask = [self createLeftArrowClip];
            }
            break;
        case VNToolbarEdgeStyleArrowRight:
            if (_toolbarPosition == VNToolbarPositionRight) {
                self.layer.mask = [self createLeftArrowClip];
            } else {
                self.layer.mask = [self createRightArrowClip];
            }
            break;
        case VNToolbarEdgeStyleArrowAll:
            self.layer.mask = [self createArrowClipAllSide];
            break;
        default:
            break;
    }
    [super setTransform:_baseTransform];
    [self restoreOrigin];
}

#pragma mark - Layout 
- (void) restoreOrigin {
    CGPoint newCenter = CGPointMake(CGRectGetMidX(_initFrame), CGRectGetMidY(_initFrame));
    if (_sizeIsFixed) {
        self.center = newCenter;
        return;
    }

    if (_isHorizontalMode && _isLeftSideMode) {
        newCenter.x += super.bounds.size.width / 2 - _initFrame.size.width / 2;
    } else if (_isHorizontalMode && !_isLeftSideMode) {
        newCenter.x -=  + super.bounds.size.width / 2 - _initFrame.size.width / 2;
    } else if (!_isHorizontalMode && _isLeftSideMode) {
        CGRect modifiedBounds = CGRectApplyAffineTransform(super.bounds, self.transform);
        newCenter.y += modifiedBounds.size.height / 2  - _initFrame.size.height / 2;
    } else if (!_isHorizontalMode && !_isLeftSideMode) {
        CGRect modifiedBounds = CGRectApplyAffineTransform(super.bounds, self.transform);
        newCenter.y -= modifiedBounds.size.height / 2  - _initFrame.size.height / 2;
    }
    self.center = newCenter;
}
- (void) updateLayoutForButtons {
    if ([self.items count] < 1) {
        return;
    }
    if (super.bounds.size.height > 24) { // scale buttons if need it
        CGAffineTransform inverse = CGAffineTransformInvert(_baseTransform);

        if (CGAffineTransformIsIdentity(_baseTransform)) {
            inverse = _baseTransform;
            if (!CGAffineTransformIsIdentity(_appliedTransform)) {
                inverse = CGAffineTransformInvert(_appliedTransform);
            }
        }

        if (CGAffineTransformEqualToTransform(inverse, _appliedTransform) || (CGAffineTransformIsIdentity(_baseTransform) && CGAffineTransformIsIdentity(_appliedTransform)) ) {
            return;
        }
        
        if ([self.buttonsArray count] > 0) {
            if (CGAffineTransformIsIdentity(_baseTransform)) {
                _appliedTransform = _baseTransform;
            } else {
                _appliedTransform = inverse;
            }

            CGFloat radians = atan2f(inverse.b, inverse.a);

            CGFloat size = MIN(super.bounds.size.height, super.bounds.size.width) - 4 * kVNToolbarButtonGap;
            for (UIBarButtonItem *item in self.items) {
                if (item.customView) {
                    float hfactor = item.customView.bounds.size.width / size;
                    float vfactor = item.customView.bounds.size.height / size;
                    float factor = fmax(hfactor, vfactor);
                    factor = fmax(factor, 1);
                    item.customView.transform = CGAffineTransformScale(inverse, factor, factor);
                } else if (item.image) {
                    
                    UIImage *newImage = _rotateByRadians(item.image, radians);
                    newImage = [self resizedImage:newImage withContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(size, size) interpolationQuality:kCGInterpolationHigh];
                    item.image = newImage;
                }
                item.width = size;
            }
        }
    }
}

- (void) updateLayout {
    [self removeGaps];    

    CGFloat width = floorf([self arrowSize].width - 13);
    if (_edgeStyle == VNToolbarEdgeStyleRoundedLeft || _edgeStyle == VNToolbarEdgeStyleRoundedRight || _edgeStyle == VNToolbarEdgeStyleRoundedAll) {
        width = 1.0;
    }
    CGFloat size = floorf(MIN(super.bounds.size.height, super.bounds.size.width) - 2 * kVNToolbarButtonGap);

    NSInteger count = [self.buttonsArray count];
    if (count > 0 && !_sizeIsFixed) {
        CGRect bounds = super.bounds;
        CGFloat newWidth = [(NSNumber *)[self.items valueForKeyPath:@"@sum.width"] floatValue];
        if (newWidth > count) {
            bounds.size.width = 2*13 + newWidth + 10 * (count -1);
        } else {
            bounds.size.width = super.bounds.size.height * count + 10 * (count - 1) + 2 * 13;
        }
        newWidth = size * count + 10 * (count - 1); // + 2 * 13;
        if (bounds.size.width < newWidth) {
            bounds.size.width = newWidth;
        }
        bounds.size.width = floorf(bounds.size.width);
        bounds.size.height = floorf(bounds.size.height);
        super.bounds = bounds;
    }
    
    if (width > 0) {
        //rearrange before adding
        CGFloat radians = atan2f(_baseTransform.b, _baseTransform.a);
        if ((radians >= - M_PI && radians < -0.00000001) || (radians >= M_PI && radians < 2 * M_PI && _isLeftSideMode)) {
            [self reArrangeItems];
        } else {
            super.items = self.buttonsArray;
        }
        
        switch (_edgeStyle) {
            case VNToolbarEdgeStyleRoundedAll:
            case VNToolbarEdgeStyleArrowAll: {
                UIBarButtonItem *gap =[self gapItem];
                gap.width = width;
                gap.tag = 23456;
                [self addItemToToolbar:gap atIndex:0];
                gap =[self gapItem];
                gap.width = width;
                gap.tag = 98765;
                [self addItemToToolbar:gap atIndex:count + 1];
                if (!_sizeIsFixed) {
                    CGRect bounds = super.bounds;
                    bounds.size.width += width * 2;
                    super.bounds = bounds;
                }
            }
                break;
            case VNToolbarEdgeStyleArrowLeft:
            case VNToolbarEdgeStyleRoundedLeft: {
                UIBarButtonItem *gap =[self gapItem];
                gap.width = width;
                gap.tag = 23456;
                [self addItemToToolbar:gap atIndex:0];
                if (!_sizeIsFixed) {
                    CGRect bounds = super.bounds;
                    bounds.size.width += width;
                    super.bounds = bounds;
                }
            }
                break;
            case VNToolbarEdgeStyleArrowRight:
            case VNToolbarEdgeStyleRoundedRight: {
                UIBarButtonItem *gap =[self gapItem];
                gap.width = width;
                gap.tag = 98765;
                [self addItemToToolbar:gap atIndex:count];
                if (!_sizeIsFixed) {
                    CGRect bounds = super.bounds;
                    bounds.size.width += width;
                    super.bounds = bounds;
                }
            }
                break;
            default:
                break;
        }
    }
    if (_sizeIsFixed) {
        if ((_toolbarPosition == VNToolbarPositionBottom || _toolbarPosition == VNToolbarPositionTop) && !_isLeftSideMode) {
            UIBarButtonItem *gap = [self flexGap];
            gap.tag = 99999;
            [self addItemToToolbar:gap atIndex:0];
        } else if ((_toolbarPosition == VNToolbarPositionBottom || _toolbarPosition == VNToolbarPositionTop) && _isLeftSideMode) {
            UIBarButtonItem *gap = [self flexGap];
            gap.tag = 99998;
            [self addItemToToolbar:gap atIndex:[self.items count]];
        } else if ((_toolbarPosition == VNToolbarPositionLeft && _isLeftSideMode) || (_toolbarPosition == VNToolbarPositionRight && !_isLeftSideMode)) {
            UIBarButtonItem *gap = [self flexGap];
            gap.tag = 99998;
            [self addItemToToolbar:gap atIndex:[self.items count]];
        } else if ((_toolbarPosition == VNToolbarPositionLeft && !_isLeftSideMode) || (_toolbarPosition == VNToolbarPositionRight && _isLeftSideMode)) {
            UIBarButtonItem *gap = [self flexGap];
            gap.tag = 99999;
            [self addItemToToolbar:gap atIndex:0];
        }
    }
}
- (void) removeGaps {
    NSMutableArray *newItems = [NSMutableArray arrayWithArray:self.items];
    if ([newItems count] < 1) {
        return;
    }
    NSArray *itemsToRemove = [newItems filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UIBarButtonItem *evaluatedObject, NSDictionary *bindings) {
        return (evaluatedObject.tag == 98765 || evaluatedObject.tag == 23456 || evaluatedObject.tag == 99999 || evaluatedObject.tag == 99998);
    }]];
    if ([itemsToRemove count] < 1) {
        return;
    }
    [newItems removeObjectsInArray:itemsToRemove];
    [super setItems: newItems animated:FALSE];
}
- (UIBarButtonItem *) gapItem {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:NULL];
}
- (UIBarButtonItem *) flexGap {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
}

#pragma mark - Frame Calcs
- (CGSize) arrowSize {
    if (self.edgeStyle == VNToolbarEdgeStyleNone) {
        return CGSizeZero;
    }
    CGFloat height = super.bounds.size.height;
    CGFloat width = height * kVNArrowScale;
    return CGSizeMake(width, height);
}

#pragma mark - Styling
- (CAShapeLayer *) createRoundedClip  {
    UIBezierPath *oMaskPath = [UIBezierPath bezierPath];
    
    CGPoint currentPoint;
    CGPoint controlPoint;
    
    CGFloat cornerRadius = [self arrowSize].width;
    
    currentPoint.y = 0;
    currentPoint.x = cornerRadius;
    [oMaskPath moveToPoint:currentPoint];
    
    controlPoint = CGPointMake(0, 0);
    currentPoint.x = 0;
    currentPoint.y = cornerRadius;
    [oMaskPath addCurveToPoint:currentPoint controlPoint1:controlPoint controlPoint2:controlPoint];
    
    currentPoint.y = super.bounds.size.height - cornerRadius;
    [oMaskPath addLineToPoint:currentPoint];
    
    controlPoint = CGPointMake(0, super.bounds.size.height);
    currentPoint.x = cornerRadius;
    currentPoint.y = super.bounds.size.height;
    [oMaskPath addCurveToPoint:currentPoint controlPoint1:controlPoint controlPoint2:controlPoint];

    currentPoint.x = super.bounds.size.width - cornerRadius;
    [oMaskPath addLineToPoint:currentPoint];

    controlPoint = CGPointMake(super.bounds.size.width, super.bounds.size.height);
    currentPoint.x = super.bounds.size.width;
    currentPoint.y = super.bounds.size.height - cornerRadius;
    [oMaskPath addCurveToPoint:currentPoint controlPoint1:controlPoint controlPoint2:controlPoint];
    
    
    currentPoint.y = cornerRadius;
    [oMaskPath addLineToPoint:currentPoint];
    
    controlPoint = CGPointMake(super.bounds.size.width, 0);
    currentPoint.x = super.bounds.size.width - cornerRadius;
    currentPoint.y = 0;
    [oMaskPath addCurveToPoint:currentPoint controlPoint1:controlPoint controlPoint2:controlPoint];
    
    currentPoint.x = cornerRadius;
    [oMaskPath addLineToPoint:currentPoint];
    
    [oMaskPath closePath];
    
    CAShapeLayer *shapeL = [CAShapeLayer layer];
    shapeL.frame = super.bounds;
    shapeL.path = oMaskPath.CGPath;
    return shapeL;
}

- (CAShapeLayer *) createRightRoundedClip  {
    UIBezierPath *oMaskPath = [UIBezierPath bezierPath];
    
    CGPoint currentPoint;
    CGPoint controlPoint;
    
    CGFloat cornerRadius = [self arrowSize].width;
    
    currentPoint.y = 0;
    currentPoint.x = 0;
    [oMaskPath moveToPoint:currentPoint];
    currentPoint.x = super.bounds.size.width - cornerRadius;
    [oMaskPath addLineToPoint:currentPoint];
    
    controlPoint = CGPointMake(super.bounds.size.width, 0);
    currentPoint.x = super.bounds.size.width;
    currentPoint.y = cornerRadius;
    [oMaskPath addCurveToPoint:currentPoint controlPoint1:controlPoint controlPoint2:controlPoint];
    
    currentPoint.y = super.bounds.size.height - cornerRadius;
    [oMaskPath addLineToPoint:currentPoint];
    
    controlPoint = CGPointMake(super.bounds.size.width, super.bounds.size.height);
    currentPoint.x = super.bounds.size.width - cornerRadius;
    currentPoint.y = super.bounds.size.height;
    [oMaskPath addCurveToPoint:currentPoint controlPoint1:controlPoint controlPoint2:controlPoint];
    
    currentPoint.x = 0;
    [oMaskPath addLineToPoint:currentPoint];
    currentPoint.y = 0;
    [oMaskPath addLineToPoint:currentPoint];
    
    [oMaskPath closePath];
    
    CAShapeLayer *shapeL = [CAShapeLayer layer];
    shapeL.frame = super.bounds;
    shapeL.path = oMaskPath.CGPath;
    return shapeL;
}

- (CAShapeLayer *) createLeftRoundedClip  {
    UIBezierPath *oMaskPath = [UIBezierPath bezierPath];
    
    CGPoint currentPoint;
    CGPoint controlPoint;
    
    CGFloat cornerRadius = [self arrowSize].width;
    
    currentPoint.y = 0;
    currentPoint.x = cornerRadius;
    [oMaskPath moveToPoint:currentPoint];

    controlPoint = CGPointMake(0, 0);
    currentPoint.x = 0;
    currentPoint.y = cornerRadius;
    [oMaskPath addCurveToPoint:currentPoint controlPoint1:controlPoint controlPoint2:controlPoint];
    
    currentPoint.y = super.bounds.size.height - cornerRadius;
    [oMaskPath addLineToPoint:currentPoint];
    
    controlPoint = CGPointMake(0, super.bounds.size.height);
    currentPoint.x = cornerRadius;
    currentPoint.y = super.bounds.size.height;
    [oMaskPath addCurveToPoint:currentPoint controlPoint1:controlPoint controlPoint2:controlPoint];

    
    currentPoint.x = super.bounds.size.width;
    [oMaskPath addLineToPoint:currentPoint];
    
    
    currentPoint.y = 0;
    [oMaskPath addLineToPoint:currentPoint];
    currentPoint.x = cornerRadius;
    [oMaskPath addLineToPoint:currentPoint];
    
    [oMaskPath closePath];
    
    CAShapeLayer *shapeL = [CAShapeLayer layer];
    shapeL.frame = super.bounds;
    shapeL.path = oMaskPath.CGPath;
    return shapeL;
}
- (CAShapeLayer *) createLeftArrowClip {
    UIBezierPath *oMaskPath = [UIBezierPath bezierPath];
    
    CGPoint currentPoint;
    CGPoint controlPoint;
    
    CGSize arrowSize = [self arrowSize];
    
    currentPoint.x = arrowSize.width;
    currentPoint.y = 0;
    [oMaskPath moveToPoint:currentPoint];
    
    controlPoint = CGPointMake(0, arrowSize.height / 2);
    [oMaskPath addLineToPoint:controlPoint];
    currentPoint.y = super.bounds.size.height;
    [oMaskPath addLineToPoint:currentPoint];
    
    currentPoint.x = super.bounds.size.width ;
    [oMaskPath addLineToPoint:currentPoint];
    
    currentPoint.y = 0;
    [oMaskPath addLineToPoint:currentPoint];
    
    currentPoint.x = arrowSize.width;
    [oMaskPath addLineToPoint:currentPoint];
    
    [oMaskPath closePath];
    
    CAShapeLayer *shapeL = [CAShapeLayer layer];
    shapeL.frame = super.bounds;
    shapeL.path = oMaskPath.CGPath;
    return shapeL;
}
- (CAShapeLayer *) createRightArrowClip {
    UIBezierPath *oMaskPath = [UIBezierPath bezierPath];
    
    CGPoint currentPoint;
    CGPoint controlPoint;
    
    CGSize arrowSize = [self arrowSize];

    controlPoint = CGPointMake(super.bounds.size.width, arrowSize.height / 2);
    currentPoint.y = 0;
    currentPoint.x = 0;
    [oMaskPath moveToPoint:currentPoint];
    currentPoint.x = super.bounds.size.width - arrowSize.width;
    [oMaskPath addLineToPoint:currentPoint];
    [oMaskPath addLineToPoint:controlPoint];
    currentPoint.y = arrowSize.height;
    [oMaskPath addLineToPoint:currentPoint];

    currentPoint.x = 0;
    [oMaskPath addLineToPoint:currentPoint];
    currentPoint.y = 0;
    [oMaskPath addLineToPoint:currentPoint];
    [oMaskPath closePath];
    
    CAShapeLayer *shapeL = [CAShapeLayer layer];
    shapeL.frame = super.bounds;
    shapeL.path = oMaskPath.CGPath;
    return shapeL;

}
- (CAShapeLayer *) createArrowClipAllSide {
    UIBezierPath *oMaskPath = [UIBezierPath bezierPath];
    
    CGPoint currentPoint;
    CGPoint controlPoint;
    
    CGSize arrowSize = [self arrowSize];
    
    currentPoint.x = arrowSize.width;
    currentPoint.y = 0;
    [oMaskPath moveToPoint:currentPoint];
    
    controlPoint = CGPointMake(0, arrowSize.height / 2);
    [oMaskPath addLineToPoint:controlPoint];
    currentPoint.y = super.bounds.size.height;
    [oMaskPath addLineToPoint:currentPoint];
    
    currentPoint.x = super.bounds.size.width - arrowSize.width;
    [oMaskPath addLineToPoint:currentPoint];
    
    controlPoint = CGPointMake(super.bounds.size.width, super.bounds.size.height / 2);
    [oMaskPath addLineToPoint:controlPoint];
    currentPoint.y = 0;
    [oMaskPath addLineToPoint:currentPoint];
    
    
    currentPoint.x = arrowSize.width;
    [oMaskPath addLineToPoint:currentPoint];
    
    [oMaskPath closePath];
    
    CAShapeLayer *shapeL = [CAShapeLayer layer];
    shapeL.frame = super.bounds;
    shapeL.path = oMaskPath.CGPath;
    return shapeL;
}

#pragma mark - Helpers
UIImage* _rotateByRadians(UIImage* sourceImage, CGFloat angleInRadians) {
    
    CGImageRef imgRef = sourceImage.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformMakeScale(1.0, -1.0);
    transform = CGAffineTransformRotate(transform, - angleInRadians);
    
    CGPoint centerPoint = CGPointMake(width/2, height/2);
    CGPoint newCenterPoint = CGPointApplyAffineTransform (centerPoint, transform);
    CGFloat deltaX = newCenterPoint.x - centerPoint.x;
    CGFloat deltaY = newCenterPoint.y - centerPoint.y;
    transform = CGAffineTransformTranslate(transform, deltaX, deltaY);
    
    CGRect bounds = CGRectMake(0, 0, width, height);
    
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(context, CGRectMake(0, 0, bounds.size.width, bounds.size.height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

- (UIImage *)resizedImage:(UIImage *) anImage withContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality {

    CGFloat horizontalRatio = bounds.width / anImage.size.width;
    CGFloat verticalRatio = bounds.height / anImage.size.height;
    CGFloat ratio;
    
    switch (contentMode) {
        case UIViewContentModeScaleAspectFill:
            ratio = MAX(horizontalRatio, verticalRatio);
            break;
            
        case UIViewContentModeScaleAspectFit:
            ratio = MIN(horizontalRatio, verticalRatio);
            break;
            
        default:
            [NSException raise:NSInvalidArgumentException format:@"Unsupported content mode: %d", contentMode];
    }
    
    CGSize newSize = CGSizeMake(anImage.size.width * ratio, anImage.size.height * ratio);
    
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGRect transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
    CGImageRef imageRef = anImage.CGImage;
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wall"

    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (anImage.imageOrientation) {
        case UIImageOrientationDown:           // EXIF = 3
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:           // EXIF = 6
        case UIImageOrientationLeftMirrored:   // EXIF = 5
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:          // EXIF = 8
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, 0, newSize.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
    }
    
    switch (anImage.imageOrientation) {
        case UIImageOrientationUpMirrored:     // EXIF = 2
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:   // EXIF = 5
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, newSize.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
    }
#pragma clang diagnostic pop

    BOOL drawTransposed;
    
    switch (anImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            drawTransposed = YES;
            break;
            
        default:
            drawTransposed = NO;
    }

    // Build a context that's the same dimensions as the new size
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                CGImageGetBitsPerComponent(imageRef),
                                                0,
                                                CGImageGetColorSpace(imageRef),
                                                CGImageGetBitmapInfo(imageRef));
    
    // Rotate and/or flip the image if required by its orientation
    CGContextConcatCTM(bitmap, transform);
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(bitmap, quality);
    
    // Draw into the context; this scales the image
    CGContextDrawImage(bitmap, drawTransposed ? transposedRect : newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);
    
    return newImage;

}


#pragma mark - Description
- (NSString *) description {
    return [NSString stringWithFormat:@"%@; bounds = %@; transform = %@", [super description], NSStringFromCGRect(super.bounds), NSStringFromCGAffineTransform(_baseTransform)];
}
@end
