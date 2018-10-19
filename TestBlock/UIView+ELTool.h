//
//  UIView+ELTool.h
//  TestBlock
//
//  Created by evol on 2018/10/18.
//  Copyright © 2018 evol. All rights reserved.
//

// 只是一个初级demo 边用边添加吧 例如添加宽高比

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSUInteger, ELLayoutType) {
    ELLayoutNone = 0,
    ELLayoutLeft = 1<<0,
    ELLayoutRight = 1<<1,
    ELLayoutTop = 1<<2,
    ELLayoutBottom = 1<<3,
    ELLayoutWidth = 1<<4,
    ELLayoutHeight = 1<<5,
    ELLayoutLeftAndRight = ELLayoutLeft | ELLayoutRight,
    ELLayoutTopAndBottom = ELLayoutTop | ELLayoutBottom,
};


static inline id _ELLayoutIdValue(const char *type, ...) {
    va_list v;
    va_start(v, type);
    id obj = nil;
    if (strcmp(type, @encode(id)) == 0) {
        id actual = va_arg(v, id);
        obj = actual;
    } else if (strcmp(type, @encode(CGPoint)) == 0) {
        CGPoint actual = (CGPoint)va_arg(v, CGPoint);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(CGSize)) == 0) {
        CGSize actual = (CGSize)va_arg(v, CGSize);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(double)) == 0) {
        double actual = (double)va_arg(v, double);
        obj = [NSNumber numberWithDouble:actual];
    } else if (strcmp(type, @encode(float)) == 0) {
        float actual = (float)va_arg(v, double);
        obj = [NSNumber numberWithFloat:actual];
    } else if (strcmp(type, @encode(int)) == 0) {
        int actual = (int)va_arg(v, int);
        obj = [NSNumber numberWithInt:actual];
    } else if (strcmp(type, @encode(long)) == 0) {
        long actual = (long)va_arg(v, long);
        obj = [NSNumber numberWithLong:actual];
    } else if (strcmp(type, @encode(long long)) == 0) {
        long long actual = (long long)va_arg(v, long long);
        obj = [NSNumber numberWithLongLong:actual];
    } else if (strcmp(type, @encode(short)) == 0) {
        short actual = (short)va_arg(v, int);
        obj = [NSNumber numberWithShort:actual];
    } else if (strcmp(type, @encode(char)) == 0) {
        char actual = (char)va_arg(v, int);
        obj = [NSNumber numberWithChar:actual];
    } else if (strcmp(type, @encode(bool)) == 0) {
        bool actual = (bool)va_arg(v, int);
        obj = [NSNumber numberWithBool:actual];
    } else if (strcmp(type, @encode(unsigned char)) == 0) {
        unsigned char actual = (unsigned char)va_arg(v, unsigned int);
        obj = [NSNumber numberWithUnsignedChar:actual];
    } else if (strcmp(type, @encode(unsigned int)) == 0) {
        unsigned int actual = (unsigned int)va_arg(v, unsigned int);
        obj = [NSNumber numberWithUnsignedInt:actual];
    } else if (strcmp(type, @encode(unsigned long)) == 0) {
        unsigned long actual = (unsigned long)va_arg(v, unsigned long);
        obj = [NSNumber numberWithUnsignedLong:actual];
    } else if (strcmp(type, @encode(unsigned long long)) == 0) {
        unsigned long long actual = (unsigned long long)va_arg(v, unsigned long long);
        obj = [NSNumber numberWithUnsignedLongLong:actual];
    } else if (strcmp(type, @encode(unsigned short)) == 0) {
        unsigned short actual = (unsigned short)va_arg(v, unsigned int);
        obj = [NSNumber numberWithUnsignedShort:actual];
    }
    va_end(v);
    return obj;
}

#define ELLayoutBlockValue(value) _ELLayoutIdValue(@encode(__typeof__((value))), (value))

@interface ELLayoutItem : NSObject

@property (nonatomic, weak) UIView * view;

@property (nonatomic) CGFloat offset;

@property (nonatomic) ELLayoutType type;

- (instancetype)initWithView:(UIView *__nullable)view type:(ELLayoutType)type;

@end



@interface ELLayout : NSObject

- (void)setItem:(ELLayoutItem *)item type:(ELLayoutType)type;

@end


#define f_left(...) f_left(ELLayoutBlockValue((__VA_ARGS__)))
#define f_right(...) f_right(ELLayoutBlockValue((__VA_ARGS__)))
#define f_top(...) f_top(ELLayoutBlockValue((__VA_ARGS__)))
#define f_bottom(...) f_bottom(ELLayoutBlockValue((__VA_ARGS__)))
#define f_width(...) f_width(ELLayoutBlockValue((__VA_ARGS__)))
#define f_height(...) f_height(ELLayoutBlockValue((__VA_ARGS__)))

@interface UIView (ELTool)

#define quick_build_layout_method(o) - (UIView * (^)(id))f_##o;\
- (ELLayoutItem * (^)(CGFloat))f_##o##_offset

quick_build_layout_method(left);
quick_build_layout_method(right);
quick_build_layout_method(top);
quick_build_layout_method(bottom);
quick_build_layout_method(width);
quick_build_layout_method(height);

//- (UIView * (^)(id))f_left;
//- (ELLayoutItem * (^)(CGFloat))f_left_offset;
//
//- (UIView * (^)(id))f_right;
//- (ELLayoutItem * (^)(CGFloat))f_right_offset;
//
//- (UIView * (^)(id))f_left;
//- (ELLayoutItem * (^)(CGFloat))f_left_offset;
//
//- (UIView * (^)(id))f_left;
//- (ELLayoutItem * (^)(CGFloat))f_left_offset;

@end

NS_ASSUME_NONNULL_END
