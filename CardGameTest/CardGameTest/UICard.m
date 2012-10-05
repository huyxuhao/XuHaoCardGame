//
//  UICard.m
//  CardGameTest
//
//  Created by Anlab JSC on 10/4/12.
//  Copyright (c) 2012 Anlab. All rights reserved.
//

#import "UICard.h"
#import <QuartzCore/QuartzCore.h>

#define kTitleFrame CGRectMake(21, 41, 47, 50)

@implementation UICard

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark Public methods
- (id)initCardWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor*)textColor backgroundColor:(UIColor*)bgColor withShader:(BOOL)shader{
    self = [super initWithFrame:frame];
    if (self) {
        
        //set background color
        [self setBackgroundColor:bgColor];
        
        //create border for card
        self.layer.borderWidth = 2.0f;
        self.layer.cornerRadius = 8;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        if(shader){
            self.layer.shadowOffset = CGSizeMake(-5, 6);
            self.layer.shadowRadius = 2;
            self.layer.shadowOpacity = 0.5;
        }                
        //create card title
        UILabel *lb = [[UILabel alloc] initWithFrame:kTitleFrame];
        [lb setBackgroundColor:[UIColor clearColor]];
        lb.font = [UIFont systemFontOfSize:60.0f];
        lb.textAlignment = UITextAlignmentCenter;
        lb.textColor = textColor;
        lb.text = text;
        [self addSubview:lb];
    }
    return self;
}
@end
