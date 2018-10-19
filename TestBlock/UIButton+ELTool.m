//
//  UIButton+ELTool.m
//  TestBlock
//
//  Created by evol on 2018/10/18.
//  Copyright © 2018 evol. All rights reserved.
//

#import "UIButton+ELTool.h"
#import <objc/runtime.h>

static const char key_button_tool_blocks;

@interface _ELButtonToolBlockModal : NSObject

@property( nonatomic, copy) void(^block)(id sender);

- (instancetype)initWithBlock:(void (^)(id sender))block;

- (void)action:(id)sender;

@end

@implementation _ELButtonToolBlockModal

- (instancetype)initWithBlock:(void (^)(id sender))block
{
    self = [super init];
    if (self) {
        self.block = block;
    }
    return self;
}
    
- (void)action:(id)sender
{
    if (_block) {
        _block(sender);
    }
}

@end

@implementation UIButton (ELTool)

- (void)addTouchBlock:(void (^)(id _Nonnull))block
{
    _ELButtonToolBlockModal * blockModal = [[_ELButtonToolBlockModal alloc] initWithBlock:block];
    [self addTarget:blockModal action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    NSMutableArray * blocks = [self _blocks];
    [blocks addObject:blockModal];
}

- (void)removeAllBlocks
{
    NSMutableArray *targets = [self _blocks];
    [targets enumerateObjectsUsingBlock:^(id target, NSUInteger idx, BOOL *stop) {
        [self removeTarget:target action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    }];
    [targets removeAllObjects];
}

- (NSMutableArray *)_blocks
{
    NSMutableArray * blocks = objc_getAssociatedObject(self, &key_button_tool_blocks);
    if (blocks == nil) {
        blocks = [NSMutableArray array];
        objc_setAssociatedObject(self, &key_button_tool_blocks, blocks, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return blocks;
}

@end
