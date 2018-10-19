//
//  Tool.h
//  TestBlock
//
//  Created by evol on 2018/10/18.
//  Copyright © 2018 evol. All rights reserved.
//

#ifndef Tool_h
#define Tool_h


#define ELWeak(o)  __weak typeof(o) o##Weak = o
#define ELStrong(o) __strong typeof(o) o = o##Weak
#import "UIView+ELTool.h"
#import "UIButton+ELTool.h"

#endif /* Tool_h */
