//
//  HSViewController.m
//  Plopper
//
//  Created by Weston Hanners on 5/2/13.
//  Copyright (c) 2013 Hanners Software. All rights reserved.
//

#import "HSViewController.h"
#import "HSPlopper.h"

@interface HSViewController () <HSPlopperDelegate>

@property NSMutableArray *ploppers;

@end

@implementation HSViewController

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.ploppers = [[NSMutableArray alloc] init];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *t = [touches anyObject];
    CGPoint p = [t locationInView:self.view];
    if (p.x < 0){
        NSLog(@"out");
    }
    HSPlopperViewController *plopper = [[HSPlopperViewController alloc] initWithSize:CGSizeMake(150, 100)];  // Init our Plopper Instance
    plopper.superView = self;                                                                                // Setup SuperView (this is to prevent the plopper from rendering outside the view).
    plopper.displayTitle = [NSString stringWithFormat:@"Plop %d", self.ploppers.count];
    plopper.view.center = p;                                                                                 // Position the Plopper.
    plopper.delegate = self;                                                                                 // Register to recieve callbacks using the <HSPlopperDelegate> protocol.
    [self.ploppers addObject:plopper];                                                                       // Add Plopper to an array to keep track.
    [self.view addSubview:plopper.view];                                                                     // Add Plopper to our view, animation is automatic.
}

- (void)wasDismissed:(HSPlopperViewController *)plopper {
    [self.ploppers removeObject:plopper];                                                                    // Remove Plopper when it is hidden
}

- (void)wasShown:(HSPlopperViewController *)plopper {
    NSLog(@"Plopper %@ at (%f,%f)", plopper, plopper.view.frame.origin.x, plopper.view.frame.origin.y);
}

@end
