//
//  HSPlopper.m
//  HSPlopper
//
//  Created by Weston Hanners on 1/4/13.
//  Copyright (c) 2013 Hanners Software. All rights reserved.
//

#pragma mark - Constant Definitions

#define kAnimationDuration 0.15
#define kAutoAdjustPadding 5
#define kStatusBarHeight 20

#import "HSPlopper.h"
#import <QuartzCore/QuartzCore.h>

@class HSPlopperView;
@class HSPlopperViewController;

#pragma mark - HSPlopperViewController

@interface HSPlopperViewController () {
    UITapGestureRecognizer *tapRecognizer;
}

@property (nonatomic, strong) HSPlopperView *view;

- (void)tappedView:(UITapGestureRecognizer *)recognizer;

@end

@implementation HSPlopperViewController {
    float rightBounds;
    float leftBounds;
    float topBounds;
    float bottomBounds;
}

- (id)initWithSize:(CGSize)size {
    if (self == [super init]) {
        self.view = [[HSPlopperView alloc] initWithFrame:CGRectMake(0,0,size.width, size.height)];
        self.view.opaque = NO;
        self.view.alpha = 0;
        tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedView:)];
        [self.view addGestureRecognizer:tapRecognizer];
        self.shown = NO;
    }
    return self;
}

- (void)adjustPosition {
    CGPoint center = self.view.center;
    CGSize size = self.view.frame.size;
    CGRect windowRect = self.superView.view.bounds;
    CGPoint newCenter = center;

    rightBounds = (windowRect.size.width) - (size.width / 2) - kAutoAdjustPadding;
    leftBounds = (size.width / 2) + kAutoAdjustPadding;
    topBounds = (size.height / 2) + kAutoAdjustPadding;
    bottomBounds = (windowRect.size.height) - (size.height / 2) - kAutoAdjustPadding - kStatusBarHeight;

    if (center.x > rightBounds) {
        newCenter.x = rightBounds;
    }
    if (center.x < leftBounds) {
        newCenter.x = leftBounds;
    }
    if (center.y < topBounds) {
        newCenter.y = topBounds;
    }
    if (center.y > bottomBounds) {
        newCenter.y = bottomBounds;
    }
    self.view.center = newCenter;
}

- (void)tappedView:(UITapGestureRecognizer *)recognizer {
    [UIView animateWithDuration:kAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.view.layer setAffineTransform:CGAffineTransformMakeScale(0, 0)];
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
    self.shown = NO;
    [_delegate wasDismissed:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [self adjustPosition];
    [self.view.layer setAffineTransform:CGAffineTransformMakeScale(0, 0)];

    [UIView animateWithDuration:kAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.view.layer setAffineTransform:CGAffineTransformMakeScale(1.2, 1.2)];
        self.view.alpha = 1;
    } completion:^(BOOL finished) {
        [self.view.layer setAffineTransform:CGAffineTransformMakeScale(1, 1)];
    }];
    self.shown = YES;
    [_delegate wasShown:self];
    
}

- (void)setDisplaytitle:(NSString *)displaytitle {
}

@end

//--------------------------------
#pragma mark - HSPlopperView
//--------------------------------

@implementation HSPlopperView

- (float)scaledFontSize {
    return (self.frame.size.height / 4) + 12 ;
}

- (void)setDisplayTitle:(NSString *)displayTitle {
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();

    //// Color Declarations
    UIColor* color = [UIColor colorWithRed: 0.294 green: 0.294 blue: 0.294 alpha: 1];
    UIColor* shineColorStart = [UIColor colorWithRed: 0.572 green: 0.572 blue: 0.572 alpha: 1];
    UIColor* shineColorEnd = [UIColor colorWithRed: 0.09 green: 0.09 blue: 0.09 alpha: 1];
    UIColor* shineColor = [UIColor colorWithRed: 0.834 green: 0.834 blue: 0.834 alpha: 1];

    //// Gradient Declarations
    NSArray* shineGradientColors = [NSArray arrayWithObjects:
                                    (id)shineColorStart.CGColor,
                                    (id)[UIColor colorWithRed: 0.357 green: 0.357 blue: 0.357 alpha: 1].CGColor,
                                    (id)shineColorEnd.CGColor, nil];
    CGFloat shineGradientLocations[] = {0, 0.33, 1};
    CGGradientRef shineGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)shineGradientColors, shineGradientLocations);

    //// Shadow Declarations
    UIColor* shadow = [UIColor blackColor];
    CGSize shadowOffset = CGSizeMake(0.1, 1.1);
    CGFloat shadowBlurRadius = 2;

    //// Frames
    CGRect imageFrame = rect;

    //// Subframes
    CGRect emblem = CGRectMake(CGRectGetMinX(imageFrame) + 1, CGRectGetMinY(imageFrame) + 2, CGRectGetWidth(imageFrame) - 2, CGRectGetHeight(imageFrame) - 4);


    //// Emblem
    {
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);

        CGContextSetAlpha(context, 0.75);
        CGContextBeginTransparencyLayer(context, NULL);


        //// rectShine Drawing
        UIBezierPath* rectShinePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(CGRectGetMinX(emblem) + floor(CGRectGetWidth(emblem) * 0.01042) + 0.5, CGRectGetMinY(emblem) + floor(CGRectGetHeight(emblem) * 0.00000 + 0.5), floor(CGRectGetWidth(emblem) * 0.98958) - floor(CGRectGetWidth(emblem) * 0.01042), floor(CGRectGetHeight(emblem) * 1.00000 + 0.5) - floor(CGRectGetHeight(emblem) * 0.00000 + 0.5)) cornerRadius: 8];
        [shineColor setFill];
        [rectShinePath fill];
        [color setStroke];
        rectShinePath.lineWidth = 1;
        [rectShinePath stroke];


        //// mainRect Drawing
        CGRect mainRectRect = CGRectMake(CGRectGetMinX(emblem) + floor(CGRectGetWidth(emblem) * 0.02083 + 0.5), CGRectGetMinY(emblem) + floor(CGRectGetHeight(emblem) * 0.00000 + 0.5), floor(CGRectGetWidth(emblem) * 0.97917 + 0.5) - floor(CGRectGetWidth(emblem) * 0.02083 + 0.5), floor(CGRectGetHeight(emblem) * 1.00000 + 0.5) - floor(CGRectGetHeight(emblem) * 0.00000 + 0.5));
        UIBezierPath* mainRectPath = [UIBezierPath bezierPathWithRoundedRect: mainRectRect cornerRadius: 8];
        CGContextSaveGState(context);
        [mainRectPath addClip];
        CGContextDrawLinearGradient(context, shineGradient,
                                    CGPointMake(CGRectGetMidX(mainRectRect), CGRectGetMinY(mainRectRect)),
                                    CGPointMake(CGRectGetMidX(mainRectRect), CGRectGetMaxY(mainRectRect)),
                                    0);
        CGContextRestoreGState(context);
        
        
        CGContextEndTransparencyLayer(context);
        CGContextRestoreGState(context);
    }
    
    
    //// Cleanup
    CGGradientRelease(shineGradient);
    CGColorSpaceRelease(colorSpace);
    

    
}


@end
