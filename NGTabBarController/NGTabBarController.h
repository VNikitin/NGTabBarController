//
//  NGTabBarController.h
//  NGTabBarController
//
//  Created by Tretter Matthias on 14.02.12.
//  Copyright (c) 2012 NOUS Wissensmanagement GmbH. All rights reserved.
//

#import "NGTabBarControllerDelegate.h"
#import "NGTabBar.h"
#import "NGTabBarControllerAnimation.h"
#import "NGTabBarPosition.h"
#import "NGTabBarItem.h"
#import "UIViewController+NGTabBarItem.h"
#import "VNToolbarPosition.h"
#import "VNToolbar.h"

#define kNGTabBarControllerKey      @"kNGTabBarControllerKey"


/** NGTabBarController is a customized TabBar displayed on any side of the device */
@interface NGTabBarController : UIViewController <UINavigationControllerDelegate>

/** An array of the view controllers displayed by the tab bar */
@property (nonatomic, copy) NSArray *viewControllers;
/** The index of the view controller associated with the currently selected tab item. */
@property (nonatomic, assign) NSUInteger selectedIndex;
/** The view controller associated with the currently selected tab item. */
@property (nonatomic, unsafe_unretained) UIViewController *selectedViewController;

/** The tab bar controller’s delegate object. */
@property (nonatomic, unsafe_unretained) id<NGTabBarControllerDelegate> delegate;

/** The tableView used to display all tab bar elements */
@property (nonatomic, strong, readonly) NGTabBar *tabBar;
/** The postion of the tabBar on screen (top/left/bottom/right) */
@property (nonatomic, assign) NGTabBarPosition tabBarPosition;

/** The animation used when changing selected tabBarItem, default: none */
@property (nonatomic, assign) NGTabBarControllerAnimation animation;
/** The duration of the used animation, only taken into account when animation is different from none */
@property (nonatomic, assign) NSTimeInterval animationDuration;

@property (nonatomic, assign) BOOL tabBarHidden;

/** The designated initializer. */
- (id)initWithDelegate:(id<NGTabBarControllerDelegate>)delegate;

- (void)setTabBarHidden:(BOOL)tabBarHidden animated:(BOOL)animated;


/*
 *  modified by SubMarine on 10/13/12.
 *  Copyright (c) 2012 Valeriy Nikitin. All rights reserved.
 *  
 *  Configuring Custom Toolbars like UINavigationController toolbar
 *  Setup UIToolbar position
 */
@property (nonatomic, strong, readonly) VNToolbar *toolbar;
- (void) setToolbarHidden:(BOOL)hidden animated:(BOOL)animated;
@property (nonatomic, getter=isToolbarHidden) BOOL toolbarHidden;
@property (nonatomic, assign) VNToolbarPosition toolbarPosition;
@property (nonatomic, strong) UIView *topBar;
- (void) setTopbarHidden:(BOOL)hidden animated:(BOOL)animated;
- (void) setToolbar:(VNToolbar *)toolbar;
@end
