//
//  KZViewController.m
//  KZCityPicker
//
//  Created by gujianxing on 05/16/2020.
//  Copyright (c) 2020 gujianxing. All rights reserved.
//

#import "KZViewController.h"
#import <KZCityPicker/KZCityPickerView.h>
@interface KZViewController ()

@end

@implementation KZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
//    [KZCityPickerView loadJson];
    
    KZCityPickerView *view = [[KZCityPickerView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [[UIScreen mainScreen] bounds].size.height)];
    
    [self.view addSubview:view];
    
    [view selected:^(NSDictionary * _Nonnull provice, NSDictionary * _Nonnull city) {
       
        NSLog(@"provice:%@\ncity:%@", provice, city);
        
    }];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
