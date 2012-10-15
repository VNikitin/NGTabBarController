#import "NGTabBarItem.h"


#define kNGDefaultTintColor                 [UIColor colorWithRed:41.0/255.0 green:147.0/255.0 blue:239.0/255.0 alpha:1.0]
#define kNGDefaultTitleColor                [UIColor lightGrayColor]
#define kNGDefaultSelectedTitleColor        [UIColor whiteColor]
//#define kNGImageOffset                       5.f
#define kNGDefaultLabelFont                 [UIFont boldSystemFontOfSize:12.f]
//fit the image or label to self.frame with inset
#define kNGDefaultContentInset              2.f


@interface NGTabBarItem () {
    BOOL _selectedByUser;
}

@property (nonatomic, strong) UILabel *titleLabel;

@end


@implementation NGTabBarItem

@synthesize selected = _selected;
@synthesize selectedImageTintColor = _selectedImageTintColor;
@synthesize titleColor = _titleColor;
@synthesize selectedTitleColor = _selectedTitleColor;
@synthesize image = _image;
@synthesize selectedImage = _selectedImage;
@synthesize titleLabel = _titleLabel;
@synthesize drawOriginalImage = _drawOriginalImage;

////////////////////////////////////////////////////////////////////////
#pragma mark - Lifecycle
////////////////////////////////////////////////////////////////////////

+ (NGTabBarItem *)itemWithTitle:(NSString *)title image:(UIImage *)image {
    NGTabBarItem *item = [[NGTabBarItem alloc] initWithFrame:CGRectZero];
    
    item.title = title;
    item.image = image;
    
    return item;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor clearColor];
        _drawOriginalImage = FALSE;
        
        _selectedByUser = NO;
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = kNGDefaultLabelFont;
        _titleLabel.textAlignment = UITextAlignmentCenter;
        _titleLabel.textColor = kNGDefaultTitleColor;
        _titleLabel.shadowColor = [UIColor blackColor];
        _titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        _titleLabel.numberOfLines = 0;
        _titleLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
        _titleLabel.adjustsFontSizeToFitWidth = FALSE;
        [self addSubview:_titleLabel];
    }
    
    return self;
}

////////////////////////////////////////////////////////////////////////
#pragma mark - UIView
////////////////////////////////////////////////////////////////////////

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    bounds = CGRectInset(bounds, kNGDefaultContentInset, kNGDefaultContentInset);
    
    if (self.image != nil) {
        CGFloat textTop = floor(CGRectGetMaxY([self imageRect]));
        self.titleLabel.frame = CGRectMake(bounds.origin.x, textTop, bounds.size.width, self.titleLabel.font.lineHeight);
    } else {
        self.titleLabel.frame = bounds;
    }
}
- (CGFloat) imageOffset {
    CGFloat imageOffset = kNGDefaultContentInset;
    if (self.titleLabel.text.length > 0) {
        CGRect bounds = self.bounds;
        //calc 1 line text height to find image offset with given font size
        CGRect textBounds = CGRectInset(bounds, kNGDefaultContentInset, kNGDefaultContentInset);
        textBounds.size.width = CGFLOAT_MAX;
        textBounds.size = [self.titleLabel.text sizeWithFont:self.titleLabel.font constrainedToSize:textBounds.size];
        //and preserve spacing for label between own edge and image
        imageOffset = textBounds.size.height + kNGDefaultContentInset;
    }
    return imageOffset;
}
- (CGRect) imageRect {
    CGRect bounds = self.bounds;
    // calc an image rect in the center of the cell (offset to the top)
    CGSize imageSize = self.image.size;
    CGFloat imageOffset = [self imageOffset];
    
    //scale image if it's too big or too small
    CGFloat horizontalRatio = (bounds.size.width - 2 * kNGDefaultContentInset) / imageSize.width;
    CGFloat verticalRatio = (bounds.size.height - imageOffset - kNGDefaultContentInset) / imageSize.height;
    CGFloat ratio = MIN(horizontalRatio, verticalRatio);
    
    CGSize newSize = CGSizeMake(floorf(imageSize.width * ratio), floorf(imageSize.height * ratio));

    CGRect imageRect = CGRectMake(floorf((bounds.size.width-newSize.width)/2.f),
                                  floorf(kNGDefaultContentInset),
                                  newSize.width,
                                  newSize.height);

    return imageRect;
}
- (void)drawRect:(CGRect)rect {
    CGRect bounds = self.bounds;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (self.image != nil) {
        CGContextSaveGState(context);
        
        // flip the coordinates system
        CGContextTranslateCTM(context, 0.f, bounds.size.height);
        CGContextScaleCTM(context, 1.f, -1.f);
        
        CGRect imageRect = [self imageRect];
        imageRect = CGRectMake(imageRect.origin.x, floorf([self imageOffset] ), imageRect.size.width, imageRect.size.height);
        
        // Set the quality level to use when rescaling
        CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
        
        // draw either a selection gradient/glow or a regular image
        if (_selectedByUser && _selectedImage) {
            CGContextDrawImage(context, imageRect, self.selectedImage.CGImage);
        } else if (!_selectedByUser && _drawOriginalImage) {
            CGContextDrawImage(context, imageRect, self.image.CGImage);
        } else {            
            if (_selectedByUser) {
                // default to shadow + gradient
                // setup shadow
                CGSize shadowOffset = CGSizeMake(0.0f, 1.0f);
                CGFloat shadowBlur = 3.0;
                CGColorRef cgShadowColor = [[UIColor blackColor] CGColor];
                
                // set shadow
                CGContextSetShadowWithColor(context, shadowOffset, shadowBlur, cgShadowColor);

                // set transparency layer and clip to mask
                CGContextBeginTransparencyLayer(context, NULL);
                CGContextClipToMask(context, imageRect, [self.image CGImage]);
                
                // fill and end the transparency layer
                CGContextSetFillColorWithColor(context, [self.selectedImageTintColor CGColor]);
                CGContextFillRect(context, imageRect);

                // setup gradient
                CGFloat alpha0 = 0.8;
                CGFloat alpha1 = 0.6;
                CGFloat alpha2 = 0.0;
                CGFloat alpha3 = 0.1;
                CGFloat alpha4 = 0.5;
                CGFloat locations[5] = {0,0.55,0.55,0.7,1};
                
                CGFloat components[20] = {1,1,1,alpha0,1,1,1,alpha1,1,1,1,alpha2,1,1,1,alpha3,1,1,1,alpha4};
                CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
                CGGradientRef colorGradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, (size_t)5);
                CGColorSpaceRelease(colorSpace);
                CGPoint start = CGPointMake(CGRectGetMidX(imageRect), imageRect.origin.y);
                CGPoint end = CGPointMake(CGRectGetMidX(imageRect)-imageRect.size.height/4, imageRect.size.height+imageRect.origin.y);
                CGContextDrawLinearGradient(context, colorGradient, end, start, 0);
                CGContextEndTransparencyLayer(context);
                CGGradientRelease(colorGradient);
            } else {
                // default to shadow + gradient
                // setup shadow
                CGSize shadowOffset = CGSizeMake(0.0f, -1.0f);
                CGFloat shadowBlur = 3.0;
                CGColorRef cgShadowColor = [[UIColor blackColor] CGColor];
                
                // set shadow
                CGContextSetShadowWithColor(context, shadowOffset, shadowBlur, cgShadowColor);
                // set transparency layer and clip to mask
                CGContextBeginTransparencyLayer(context, NULL);
                CGContextClipToMask(context, imageRect, [self.image CGImage]);
                
                // fill and end the transparency layer
                CGContextSetFillColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
                CGContextFillRect(context, imageRect);

                CGContextEndTransparencyLayer(context);
            }
        }
        CGContextRestoreGState(context);
    }
}

////////////////////////////////////////////////////////////////////////
#pragma mark - UIControl
////////////////////////////////////////////////////////////////////////

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    // somehow self.selected always returns NO, so we store it in our own iVar
    _selectedByUser = selected;
    
    if (selected) {
        self.titleLabel.textColor = self.selectedTitleColor;
    } else {
        self.titleLabel.textColor = self.titleColor;
    }
    
    [self setNeedsDisplay];
}

////////////////////////////////////////////////////////////////////////
#pragma mark - NGTabBarItem
////////////////////////////////////////////////////////////////////////

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
    [self setNeedsLayout];
}

- (NSString *)title {
    return self.titleLabel.text;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
    
    [self setNeedsDisplay];
    [self setNeedsLayout];
}

- (UIColor *)selectedImageTintColor {
    return _selectedImageTintColor ?: kNGDefaultTintColor;
}

- (UIColor *)titleColor {
    return _titleColor ?: kNGDefaultTitleColor;
}

- (UIColor *)selectedTitleColor {
    return _selectedTitleColor ?: kNGDefaultSelectedTitleColor;
}

@end
