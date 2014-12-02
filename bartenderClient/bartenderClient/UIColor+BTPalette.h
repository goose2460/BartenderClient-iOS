//
//  UIColor+BTPalette.h
//  toDoList
//
//  Created by Davis Gossage on 11/10/14.
//  MIT License
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@implementation UIColor (BTPalette)

+ (UIColor*) BTRed{
    //rgb(231, 76, 60)
    return [UIColor colorWithRed:.906 green:.298 blue:.235 alpha:1.0];
}

+ (UIColor*) BTBlue{
    //rgb(52, 152, 219)
    return [UIColor colorWithRed:.20 green:.596 blue:.859 alpha:1.0];
}

+ (UIColor*) BTGreen{
    //rgb(46, 204, 113)
    return [UIColor colorWithRed:.18 green:.80 blue:.44 alpha:1.0];
}

+ (UIColor*) BTOrange{
    //rgb(230, 126, 34)
    return [UIColor colorWithRed:.902 green:.494 blue:.133 alpha:1.0];
}

+ (UIColor*) BTYellow{
    //rgb(241, 196, 15)
    return [UIColor colorWithRed:.945 green:.787 blue:.059 alpha:1.0];
}


@end
