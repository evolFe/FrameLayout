//
//  UIButton+ELTool.h
//  TestBlock
//
//  Created by evol on 2018/10/18.
//  Copyright © 2018 evol. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (ELTool)

- (void)addTouchBlock:(void(^)(id sender))block;
- (void)removeAllBlocks;

@end

NS_ASSUME_NONNULL_END
