//
//  MZVerificationView.m
//  MZDragVerification
//
//  Created by mizu-bai on 2021/4/21.
//

#import "MZVerificationView.h"

#define kWidth self.bounds.size.width
#define kHeight self.bounds.size.height
#define kImage [UIImage imageNamed:@"neko_ball"]

@interface MZVerificationView ()

@property(nonatomic, strong) UIButton *buttonBullet;
@property(nonatomic, strong) UIButton *buttonTarget;
@property(nonatomic, assign) BOOL firstTouchInBullet;
@property(nonatomic, assign) BOOL verificationSuccess;

@end

@implementation MZVerificationView

- (UIButton *)buttonBullet {
    if (_buttonBullet == nil) {
        UIButton *buttonBullet = [[UIButton alloc] init];
        [buttonBullet setTitle:@"🐟" forState:UIControlStateNormal];
        [buttonBullet setTitle:@"🐠" forState:UIControlStateHighlighted];
        [buttonBullet setTitle:@"🐡" forState:UIControlStateDisabled];
        [buttonBullet.titleLabel setFont:[UIFont systemFontOfSize:40]];
        [buttonBullet setUserInteractionEnabled:NO];
        [self addSubview:buttonBullet];
        _buttonBullet = buttonBullet;
    }
    return _buttonBullet;
}

- (UIButton *)buttonTarget {
    if (_buttonTarget == nil) {
        UIButton *buttonTarget = [[UIButton alloc] init];
        [buttonTarget setImage:kImage forState:UIControlStateNormal];
        [buttonTarget setUserInteractionEnabled:NO];
        [self addSubview:buttonTarget];
        _buttonTarget = buttonTarget;
    }
    return _buttonTarget;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUserInteractionEnabled:YES];
    // set frame
    // target
    CGPoint randomPointTarget = [self randomPointWithSize:CGSizeMake(kImage.size.width, kImage.size.height)];
    [self.buttonTarget setFrame:CGRectMake(randomPointTarget.x, randomPointTarget.y, kImage.size.width, kImage.size.height)];
    // bullet
    CGPoint randomPointBullet;
    while (YES) {
        randomPointBullet = [self randomPointWithSize:CGSizeMake(kImage.size.width, kImage.size.height)];
        CGRect randomFrameBullet = CGRectMake(randomPointBullet.x, randomPointBullet.y, 50, 50);
        if (!CGRectIntersectsRect(self.buttonTarget.frame, randomFrameBullet)) {
            [self.buttonBullet setFrame:randomFrameBullet];
            break;
        }
    }
    [self.buttonBullet setHighlighted:NO];
    [self.buttonBullet setEnabled:YES];

}

- (CGPoint)randomPointWithSize:(CGSize)size {
    return CGPointMake((CGFloat) arc4random_uniform((uint32_t) (kWidth - size.width)), (CGFloat) arc4random_uniform((uint32_t) (kHeight - size.height)));
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    self.firstTouchInBullet = CGRectContainsPoint(self.buttonBullet.frame, point);
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.firstTouchInBullet) {
        return;
    }
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGFloat tx = point.x - self.buttonBullet.center.x;
    if (point.x < 0) {
        tx = 0 - self.buttonBullet.center.x;
    } else if (point.x > kWidth) {
        tx = kWidth - self.buttonBullet.center.x;
    }

    CGFloat ty = point.y - self.buttonBullet.center.y;
    if (point.y < 0) {
        ty = 0 - self.buttonBullet.center.y;
    } else if (point.y > kHeight) {
        ty = kHeight - self.buttonBullet.center.y;
    }
    [self.buttonBullet setTransform:CGAffineTransformMakeTranslation(tx, ty)];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.firstTouchInBullet) {
        return;
    }
    [self setUserInteractionEnabled:NO];
    if (CGRectIntersectsRect(self.buttonTarget.frame, self.buttonBullet.frame)) {
        self.verificationSuccess = YES;
        [self.buttonBullet setHighlighted:YES];
    } else {
        self.verificationSuccess = NO;
        [self.buttonBullet setEnabled:NO];
        [self.buttonBullet setHighlighted:NO];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            // if you want to give the users more chances, reset the transform of buttonBullet
            self.buttonBullet.transform = CGAffineTransformIdentity;
            [self.buttonBullet setEnabled:YES];
            // if you want to refresh automatically, awake this view
            // [self awakeFromNib];
        });
    }
    if (self.verify) {
        self.verify(self.verificationSuccess);
    }
}

@end
