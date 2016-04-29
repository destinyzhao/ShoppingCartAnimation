//
//  ViewController.m
//  ShoppingCartAnimation
//
//  Created by Alex on 16/4/28.
//  Copyright © 2016年 Alex. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) NSMutableArray *redLayers;

@property (weak, nonatomic) IBOutlet UIImageView *cartImgView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation ViewController

- (NSMutableArray *)redLayers
{
    if (!_redLayers) {
        _redLayers = [NSMutableArray array];
    }
    return _redLayers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)viewDidLayoutSubviews
{
    CGPoint startPoint = CGPointMake(self.view.frame.size.width-10, 84);
    CGPoint endPoint = [self.view convertPoint:self.cartImgView.center fromView:self.bottomView];
    
    [self doAnimation:startPoint endPoind:endPoint];
}

- (void)doAnimation:(CGPoint)startPoint endPoind:(CGPoint)endPoint {
    
    CALayer *flyStarLayer = [[CALayer alloc] init];
    flyStarLayer.frame = CGRectMake(10, 10, 15, 15);
    flyStarLayer.cornerRadius = CGRectGetWidth(flyStarLayer.frame)/2.f;
    flyStarLayer.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:flyStarLayer];
    [self.redLayers addObject:flyStarLayer];
    
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPathMoveToPoint(curvedPath, NULL, startPoint.x, startPoint.y);
    CGPathAddQuadCurveToPoint(curvedPath, NULL, endPoint.x, startPoint.y, endPoint.x, endPoint.y);
    
    CAKeyframeAnimation *animation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.duration = 1.f;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.calculationMode = kCAAnimationCubicPaced;
    animation.path=curvedPath;
    animation.delegate = self;
    
    [flyStarLayer addAnimation:animation forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    shakeAnimation.duration = 0.25f;
    shakeAnimation.fromValue = [NSNumber numberWithFloat:0.5];
    shakeAnimation.toValue = [NSNumber numberWithFloat:1];
    shakeAnimation.autoreverses = YES;
    [_cartImgView.layer addAnimation:shakeAnimation forKey:nil];
    
    [self.redLayers[0] removeFromSuperlayer];
    [self.redLayers removeObjectAtIndex:0];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
