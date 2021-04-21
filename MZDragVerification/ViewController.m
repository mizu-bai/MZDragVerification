//
//  ViewController.m
//  MZDragVerification
//
//  Created by mizu-bai on 2021/4/21.
//

#import "ViewController.h"
#import "MZVerificationView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet MZVerificationView *verificationView;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;

- (IBAction)buttonRefresh:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buttonRefresh:nil];
    self.verificationView.verify = ^(BOOL result) {
        if (result) {
            [self.labelTitle setText:@"吃到鱼了，验证成功"];
        } else {
            [self.labelTitle setText:@"没吃到鱼，验证失败"];
        }
        return result;
    };
}


- (IBAction)buttonRefresh:(id)sender {
    [self.labelTitle setText:@"给猫猫球喂小鱼验证哦"];
    [self.verificationView awakeFromNib];
}


@end
