//
//  ViewController.m
//  TwoWeekClear
//
//  Created by SDT-1 on 2014. 1. 22..
//  Copyright (c) 2014년 Maybe There. All rights reserved.
//

#import "ViewController.h"
#import "FirstViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *back;
@property (weak, nonatomic) IBOutlet UIView *front;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *back2;
@property (weak, nonatomic) IBOutlet UIView *front2;
@property (weak, nonatomic) IBOutlet UIButton *btn2;


@end

@implementation ViewController


- (void) flipCard {
    //[self.flipTimer invalidate];
    if (self.flipped){
        return;
    }
    
    id animationsBlock = ^{
        self.back.alpha = 1.0f;
        self.front.alpha = 0.0f;
        [self.view1 bringSubviewToFront:self.front];
        self.flipped = YES;
        
        
       
        
        CALayer *layer = self.view1.layer;
        CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
        rotationAndPerspectiveTransform.m34 = 1.0 / 500;
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform,M_PI, 0.0f, 1.0f, 0.0f);
        
        
        layer.transform = rotationAndPerspectiveTransform;
    };
    [UIView animateWithDuration:1.28
                          delay:0.0
                        options: UIViewAnimationCurveEaseInOut
                     animations:animationsBlock
                     completion:nil];
    
}

- (void) flipCard1 {
    //[self.flipTimer invalidate];
    if (self.flipped2){
        return;
    }
    
    id animationsBlock = ^{
        self.back2.alpha = 1.0f;
        self.front2.alpha = 0.0f;
        [self.view2 bringSubviewToFront:self.front2];
        self.flipped2 = YES;
        
        
        
        
        CALayer *layer = self.view2.layer;
        CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
        rotationAndPerspectiveTransform.m34 = 1.0 / 500;
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform,M_PI, 0.0f, 1.0f, 0.0f);
        
        
        layer.transform = rotationAndPerspectiveTransform;
    };
    [UIView animateWithDuration:1.28
                          delay:0.0
                        options: UIViewAnimationCurveEaseInOut
                     animations:animationsBlock
                     completion:nil];
    
}


- (IBAction)btn1Press:(id)sender {
    NSLog(@"press");
    if (self.flipped == NO) {
        [self flipCard];
        [self performSelector:@selector(jumpView) withObject:nil afterDelay:1.28];
    }
    else{
        self.front.alpha = 1.0f;
        self.back.alpha = 1.0f;
        [self reverseCard];
    }
    
}

- (IBAction)btn2Press:(id)sender {
    [self flipCard1];
    [self performSelector:@selector(jumpView2) withObject:nil afterDelay:1.28];
}


-(void)jumpView{
    UIStoryboard *storyboard = self.storyboard;
    FirstViewController * vc = (FirstViewController *)[storyboard instantiateViewControllerWithIdentifier:@"FirstView"];
    [self presentViewController:vc animated:NO completion:nil];
}
-(void)jumpView2{
    UIStoryboard *storyboard = self.storyboard;
    FirstViewController * vc = (FirstViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SecondView"];
    [self presentViewController:vc animated:NO completion:nil];
}





- (void) reverseCard {
    //[self.flipTimer invalidate];
    if (!self.flipped){
        return;
    }
    
    id animationsBlock = ^{
        self.front.alpha = 1.0f;
        self.back.alpha = 0.0f;
        [self.view1 bringSubviewToFront:self.back];
        [self.view1 bringSubviewToFront:self.btn1];
        self.flipped = NO;
        
        CALayer *layer = self.view1.layer;
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
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
