//
//  KZCityPickerView.h
//  KZCityPicker
//
//  Created by Khazan Gu on 2020/5/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KZCityPickerView : UIView

- (void)selected:(void(^)(NSDictionary *provice, NSDictionary *city))handler;

@end

NS_ASSUME_NONNULL_END
