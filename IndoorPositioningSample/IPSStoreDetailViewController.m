//
//  IPSViewController.m
//  IndoorPositioningSample
//
//  Created by Ruben Xifré on 16/4/15.
//  Copyright (c) 2015 Ruben Xifré. All rights reserved.
//

#import "IPSStoreDetailViewController.h"
#import "IPSStore.h"

@interface IPSStoreDetailViewController ()

@property (weak, nonatomic) IBOutlet UIView *mainImageContainer;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

@implementation IPSStoreDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.mainImageContainer.layer.cornerRadius = 10.0;
    
    self.nameLabel.text = self.store.name;
    self.detailDescriptionLabel.text = self.store.detailDescription;
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
