//
//  HSPlopperViewController.h
//  HSPlopper
//
//  Created by Weston (Work) on 1/3/13.
//  Copyright (c) 2013 Hanners Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSPlopperViewController;

#pragma mark - Protocol Defination

@protocol HSPlopperDelegate <NSObject>

- (void)wasDismissed:(HSPlopperViewController *)plopper;
- (void)wasShown:(HSPlopperViewController *)plopper;

@end

#pragma mark - HSPlopperViewController

@interface HSPlopperViewController : UIViewController

@property BOOL                              shown;
@property NSString                          *displayTitle;
@property UIViewController                  *superView;
@property (weak) id<HSPlopperDelegate>      delegate;

- (id)initWithSize:(CGSize)size;

@end

#pragma mark - HSPlopperView

@interface HSPlopperView : UIView

@end
