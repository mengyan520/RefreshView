//
//  pch.h
//  浮动刷新动画
//
//  Created by 马鸣 on 2017/11/22.
//  Copyright © 2017年 马鸣. All rights reserved.
//

#ifndef pch_h
#define pch_h
#ifdef DEBUG
#define DBLog(format, ...)     NSLog(format,##__VA_ARGS__)
#else
#define DBLog(...)
#endif
#endif /* pch_h */
