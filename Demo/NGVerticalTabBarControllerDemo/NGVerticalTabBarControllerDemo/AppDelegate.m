//
//  AppDelegate.m
//  NGTabBarControllerDemo
//
//  Created by Tretter Matthias on 16.02.12.
//  Copyright (c) 2012 NOUS Wissensmanagement GmbH. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "NGTestTabBarController.h"
#import "NGColoredViewController.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    NGColoredViewController *vc1 = [[NGColoredViewController alloc] initWithNibName:nil bundle:nil];
    NGColoredViewController *vc2 = [[NGColoredViewController alloc] initWithNibName:nil bundle:nil];
    NGColoredViewController *vc3 = [[NGColoredViewController alloc] initWithNibName:nil bundle:nil];
    NGColoredViewController *vc4 = [[NGColoredViewController alloc] initWithNibName:nil bundle:nil];
    
    vc1.ng_tabBarItem = [NGTabBarItem itemWithTitle:@"Route" image:[UIImage imageNamed:@"route.png"]];
    vc2.ng_tabBarItem = [NGTabBarItem itemWithTitle:@"Online Observation" image:[UIImage imageNamed:@"buoyIconSmall.png"]];
    vc2.ng_tabBarItem.drawOriginalImage = TRUE;
    vc3.ng_tabBarItem = [NGTabBarItem itemWithTitle:@"Test Big" image:[UIImage imageNamed:@"sailboat.png"]];
    vc4.ng_tabBarItem = [NGTabBarItem itemWithTitle:@"test long long long text and even much more that fits into TabBarItem frame and truncate the tail" image:nil];
    
    vc1.ng_tabBarItem.selectedImageTintColor = [UIColor yellowColor];
    vc1.ng_tabBarItem.selectedTitleColor = [UIColor yellowColor];
    
    NSArray *viewController = [NSArray arrayWithObjects:vc1,vc2,vc3,vc4,nil];
    
    NGTabBarController *tabBarController = [[NGTestTabBarController alloc] initWithDelegate:self];
    tabBarController.tabBarPosition = NGTabBarPositionRight;
    tabBarController.viewControllers = viewController;
    
    UIBarButtonItem *testToolbarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"liveradio"] style:UIBarButtonItemStylePlain target:nil action:NULL];
    [tabBarController.toolbar setItems:[NSArray arrayWithObject:testToolbarItem]];
    tabBarController.toolbarPosition = VNToolbarPositionDynamicOpposite;
    //test topview
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height = 72;
    UIView *topView = [[UIView alloc] initWithFrame:frame];
    topView.backgroundColor = [UIColor lightGrayColor];
    [topView.layer setShadowColor: [UIColor blackColor].CGColor];
    [topView.layer setShadowOffset:CGSizeMake(0.0, 4.0)];
    [topView.layer setShadowRadius:3.0];
    [topView.layer setShadowOpacity:0.8];
    tabBarController.topBar = topView;
    topView.clipsToBounds = FALSE;
    
    self.window.rootViewController = tabBarController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

////////////////////////////////////////////////////////////////////////
#pragma mark - NGTabBarControllerDelegate
////////////////////////////////////////////////////////////////////////

- (CGSize)tabBarController:(NGTabBarController *)tabBarController 
sizeOfItemForViewController:(UIViewController *)viewController
                   atIndex:(NSUInteger)index 
                  position:(NGTabBarPosition)position {
    if (NGTabBarIsVertical(position)) {
        return CGSizeMake(100.f, 60.f);
    } else {
        return CGSizeMake(60.f, 49.f);
    }
}


@end
