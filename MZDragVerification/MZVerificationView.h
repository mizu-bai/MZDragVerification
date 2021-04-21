//
//  MZVerificationView.h
//  Meow
//
//  Created by mizu-bai on 2021/4/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MZVerificationView : UIView

@property(nonatomic, copy) BOOL (^verify)(BOOL result);
@property(nonatomic, assign) BOOL verificationSuccess;

@end

NS_ASSUME_NONNULL_END
