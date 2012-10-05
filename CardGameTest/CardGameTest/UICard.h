//
//  UICard.h
//  CardGameTest
//
//  Created by Anlab JSC on 10/4/12.
//  Copyright (c) 2012 Anlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIFont+SnapAdditions.h"

@interface UICard : UIImageView

- (id)initCardWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor*)textColor backgroundColor:(UIColor*)bgColor withShader:(BOOL)shader;

@end
