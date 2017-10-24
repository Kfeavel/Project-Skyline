//
//  MessageNavigationController.m
//  Aethyr
//
//  Created by Keeton Feavel on 6/26/17.
//  Copyright © 2017 Keeton Feavel. All rights reserved.
//

#import "MessageNavigationController.h"

@interface MessageNavigationController ()

@end

@implementation MessageNavigationController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configure];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIViewController Configuration

- (void)configure {
//    [[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
//    [[UINavigationBar appearance] setBarTintColor:[RMColor colorFromHexString:@"#e7eced"]];
//    [self.navigationController.navigationBar setTranslucent:NO];
    
    //This would go in the controller you specifically want to theme differently
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
