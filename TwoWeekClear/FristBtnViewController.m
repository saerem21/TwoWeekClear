//
//  FristBtnViewController.m
//  TwoWeekClear
//
//  Created by SDT-1 on 2014. 1. 22..
//  Copyright (c) 2014년 Maybe There. All rights reserved.
//

#import "FristBtnViewController.h"

@interface FristBtnViewController ()
@property (weak, nonatomic) IBOutlet UIView *back;
@property (weak, nonatomic) IBOutlet UIView *front;

@end

@implementation FristBtnViewController

- (void) flipCard {
    //[self.flipTimer invalidate];
    if (self.flipped){
        return;
    }
    
    id animationsBlock = ^{
        self.back.alpha = 1.0f;
        self.front.alpha = 0.0f;
        [self.view bringSubviewToFront:self.front];
        self.flipped = YES;
        
        CALayer *layer = self.view.layer;
        CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
        rotationAndPerspectiveTransform.m34 = 1.0 / 500;
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform,M_PI, 0.0f, 1.0f, 0.0f);
        layer.transform = rotationAndPerspectiveTransform;
    };
    [UIView animateWithDuration:0.28
                          delay:0.0
                        options: UIViewAnimationCurveEaseInOut
                     animations:animationsBlock
                     completion:nil];
    
}
- (IBAction)buttonPress:(id)sender {
    NSLog(@"press");
    
}

- (void) reverseCard {
    //[self.flipTimer invalidate];
    if (!self.flipped){
        return;
    }
    
    id animationsBlock = ^{
        self.front.alpha = 1.0f;
        self.back.alpha = 0.0f;
        [self.view bringSubviewToFront:self.back];
        self.flipped = NO;
        
        CALayer *layer = self.view.layer;
        CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
        rotationAndPerspectiveTransform.m34 = 1.0 / 500;
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform,0, 0.0f, 1.0f, 0.0f);
        layer.transform = rotationAndPerspectiveTransform;
    };
    [UIView animateWithDuration:0.28
                          delay:0.0
                        options: UIViewAnimationCurveEaseInOut
                     animations:animationsBlock
                     completion:nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
