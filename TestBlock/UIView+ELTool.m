//
//  UIView+ELTool.m
//  TestBlock
//
//  Created by evol on 2018/10/18.
//  Copyright © 2018 evol. All rights reserved.
//

#import "UIView+ELTool.h"
#import <objc/runtime.h>


@implementation ELLayoutItem

- (instancetype)initWithView:(UIView * __nullable)view type:(ELLayoutType)type
{
    self = [super init];
    if (self) {
        _view = view;
        _type = type;
    }
    return self;
}

@end

@interface ELLayout ()
{
    NSMutableDictionary * _layoutItems;    
    CGFloat _x;
    CGFloat _y;
    CGFloat _w;
    CGFloat _h;
}

@property (nonatomic, weak) UIView * view;

@property(nonatomic) ELLayoutType type;

@end



@implementation ELLayout

- (instancetype)initWithView:(UIView *)view
{
    self = [super init];
    if (self) {
        _view = view;
        [self _setUp];
    }
    return self;
}


- (void)_setUp
{
    _layoutItems = [NSMutableDictionary dictionary];
}


- (void)setItem:(ELLayoutItem *)item type:(ELLayoutType)type
{
    self.type |= type;
    [_layoutItems setObject:item forKey:@(type)];
}

- (ELLayout * (^)(id))equalTo {
    return ^ELLayout *(id obj) {
        return self;
    };
}

- (CGRect)frame
{
    // 顺序不能变
    [self _configWidth];
    [self _configHeight];
    [self _configX];
    [self _configY];
    return CGRectMake(_x, _y, _w, _h);
}


- (void)_configWidth
{
    if (self.type & ELLayoutWidth) { //设置过宽度
        _w = [self _valueWithType:ELLayoutWidth];
    }else if (self.type & ELLayoutLeftAndRight) { // 设置了左右 宽度也能确定
        CGFloat left = [self _valueWithType:ELLayoutLeft];
        CGFloat right = [self _valueWithType:ELLayoutRight];
        _w = - left + right;
    }
}

- (void)_configHeight
{
    if (self.type & ELLayoutHeight) { //设置过宽度
        _h = [self _valueWithType:ELLayoutHeight];
    }else if (self.type & ELLayoutTopAndBottom) { // 设置了左右 宽度也能确定
        CGFloat top = [self _valueWithType:ELLayoutTop];
        CGFloat bottom = [self _valueWithType:ELLayoutBottom];
        _h = bottom - top;
    }
}

- (void)_configX
{
    if (self.type & ELLayoutLeft) {
        _x = [self _valueWithType:ELLayoutLeft];
    }else if (self.type & ELLayoutRight) {
        _x = [self _valueWithType:ELLayoutRight] - _w;
    }
}

- (void)_configY
{
    if (self.type & ELLayoutTop) {
        _y = [self _valueWithType:ELLayoutTop];
    }else if (self.type & ELLayoutBottom){
        _y = [self _valueWithType:ELLayoutBottom] - _h;
    }
}


- (CGFloat)_valueWithType:(ELLayoutType)type
{
    ELLayoutItem * item = [_layoutItems objectForKey:@(type)];
    if (item.view == self.view.superview) { // 如果视图是父视图的话，left、top直接返回，width、height要相对于父视图便宜，right、bottom要相对于父视图的宽高
        switch (item.type) {
            case ELLayoutLeft:
                return item.offset;
            case ELLayoutRight:
                return CGRectGetWidth(item.view.frame) + item.offset;
            case ELLayoutTop:
                return item.offset;
            case ELLayoutBottom:
                return CGRectGetHeight(item.view.frame) + item.offset;
            case ELLayoutWidth:
                return CGRectGetWidth(item.view.frame) + item.offset;
            case ELLayoutHeight:
                return CGRectGetHeight(item.view.frame) + item.offset;
            default:
                break;
        }
    }else if (item.view == nil){ //如果直接设置的数字，top left width height可以直接返回，right 和 bottom 要相对于父视图的宽高
        switch (item.type) {
            case ELLayoutLeft:
            case ELLayoutTop:
            case ELLayoutWidth:
            case ELLayoutHeight:
                return item.offset;
            case ELLayoutRight:
                return CGRectGetWidth(self.view.superview.frame) + item.offset;
            case ELLayoutBottom:
                return CGRectGetHeight(self.view.superview.frame) + item.offset;
            default:
                break;
        }
    }else{// 如果设置的其他视图，该视图必须跟self是同一个父视图，然后对应便宜
        switch (item.type) {
            case ELLayoutLeft:
                return CGRectGetMinX(item.view.frame) + item.offset;
            case ELLayoutRight:
                return CGRectGetMaxX(item.view.frame) + item.offset;
            case ELLayoutTop:
                return CGRectGetMinY(item.view.frame) + item.offset;
            case ELLayoutBottom:
                return CGRectGetMaxY(item.view.frame) + item.offset;
            case ELLayoutWidth:
                return CGRectGetWidth(item.view.frame) + item.offset;
            case ELLayoutHeight:
                return CGRectGetHeight(item.view.frame) + item.offset;
            default:
                break;
        }
    }
    return 0;
}


@end

static const char key_view_tool_layout;

@implementation UIView (ELTool)

+ (void)load
{
    Method origMethod = class_getInstanceMethod([self class], @selector(layoutSubviews));
    Method swizMethod = class_getInstanceMethod([self class], @selector(_elLayoutSubViews));
    method_exchangeImplementations(origMethod, swizMethod);
}

#define quick_build_layout_method_m(o,x)- (UIView * (^)(id))f_##o {\
return ^UIView *(id obj) {\
    ELLayout * layout = [self _layoutFile];\
    [layout setItem:[self _itemWithObject:obj type:x] type:x];\
    return self;\
};\
}\
- (ELLayoutItem * _Nonnull (^)(CGFloat))f_##o##_offset\
{\
    return ^ELLayoutItem *(CGFloat value) {\
        ELLayoutItem * item = [[ELLayoutItem alloc] initWithView:self type:x];\
        item.offset = value;\
        return item;\
    };\
}

quick_build_layout_method_m(left, ELLayoutLeft)
quick_build_layout_method_m(right, ELLayoutRight)
quick_build_layout_method_m(top, ELLayoutTop)
quick_build_layout_method_m(bottom, ELLayoutBottom)
quick_build_layout_method_m(width, ELLayoutWidth)
quick_build_layout_method_m(height, ELLayoutHeight)

- (ELLayoutItem *)_itemWithObject:(id)obj type:(ELLayoutType)type
{
    ELLayoutItem * item = nil;
    if ([obj isKindOfClass:[NSNumber class]]) { // 直接设置的数值
        item = [[ELLayoutItem alloc] initWithView:nil type:type];
        item.offset = [obj floatValue];
    }else if ([obj isKindOfClass:[ELLayoutItem class]]){ //
        item = obj;
    }else{
        @throw [NSException exceptionWithName:@"设置视图" reason:@"弄啥嘞" userInfo:nil];
    }
    return item;
}


- (void)elLayout
{
    ELLayout * l = objc_getAssociatedObject(self, &key_view_tool_layout);
    if (l) {
        self.frame = l.frame;
    }
}

- (ELLayout *)_layoutFile
{
    ELLayout * l = objc_getAssociatedObject(self, &key_view_tool_layout);
    if (l == nil) {
        l = [[ELLayout alloc] initWithView:self];
        objc_setAssociatedObject(self, &key_view_tool_layout, l, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return l;
}

- (void)_elLayoutSubViews
{
    [self _elLayoutSubViews];
    for (UIView * v in self.subviews) {
        [v elLayout];
    }
}

@end
