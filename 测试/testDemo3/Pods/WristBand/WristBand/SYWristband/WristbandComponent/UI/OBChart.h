//
//  OBChart.h
//  OBChart
//
//  Created by Obally on 16/4/10.
//  Copyright © 2016年 Obally. All rights reserved.
//  柱状图


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define P_M(x,y) CGPointMake(x, y)

#define weakSelf(weakSelf)  __weak typeof(self) weakself = self;
#define XORYLINEMAXSIZE CGSizeMake(CGFLOAT_MAX,30)
@interface OBChart : UIView


/**
 *  The margin value of the content view chart view
 *  图表的边界值
 */
@property (nonatomic, assign) UIEdgeInsets contentInsets;


/**
 *  The origin of the chart is different from the meaning of the origin of the chart. 
    As a pie chart and graph center ring. The line graph represents the origin.
 *  图表的原点值（如果需要）
 */
@property (assign, nonatomic)  CGPoint chartOrigin;


/**
 *  Name of chart. The name is generally not displayed, just reserved fields
 *  图表名称
 */
@property (copy, nonatomic) NSString * chartTitle;


/**
 *  The fontsize of Y line text.Default id 8;
 */
@property (nonatomic,assign) CGFloat yDescTextFontSize;



/**
 *  The fontsize of X line text.Default id 8;
 */
@property (nonatomic,assign) CGFloat xDescTextFontSize;


/**
 *  X, Y axis line color
 */
@property (nonatomic, strong) UIColor * xAndYLineColor;


/**
 *  Start drawing chart.
 */
- (void)showAnimation;

/**
 *  Clear current chart when refresh
 */
- (void)clear;


/**
 *  Draw a line according to the conditions
 *  start：Draw Starting Point
 *  end：Draw Ending Point
 *  isDotted：Is the dotted line
 *  color：Line color
 */
- (void)drawLineWithContext:(CGContextRef )context
               andStarPoint:(CGPoint )start
                andEndPoint:(CGPoint)end
            andIsDottedLine:(BOOL)isDotted
                   andColor:(UIColor *)color;


/**
 *  Draw a piece of text at a point
 *  point：Draw position
 * color：TextColor
 *   fontSize：Text font size
 */
- (void)drawText:(NSString *)text
      andContext:(CGContextRef )context
         atPoint:(CGPoint )point
       WithColor:(UIColor *)color
     andFontSize:(CGFloat)fontSize;



/**
 *  Similar to the above method
 *
 */
- (void)drawText:(NSString *)text
         context:(CGContextRef )context
         atPoint:(CGRect )rect
       WithColor:(UIColor *)color
            font:(UIFont*)font;



/**
 *  Determine the width of a certain segment of text in the default font.
 */
- (CGFloat)getTextWithWhenDrawWithText:(NSString *)text;



/**
 *  Draw a rectangle at a point
 *  p:Draw position
 *
 */
- (void)drawQuartWithColor:(UIColor *)color
             andBeginPoint:(CGPoint)p
                andContext:(CGContextRef)contex;


/**
 *  Draw a circle at a point
 *  redius：Circle redius
 *  p:Draw position
 *
 */
- (void)drawPointWithRedius:(CGFloat)redius
                   andColor:(UIColor *)color
                   andPoint:(CGPoint)p
                 andContext:(CGContextRef)contex;


/**
 *  According to the relevant conditions to determine the width of the text
 *   maxSize：Maximum range of text
 *   textFont：Text font
 *  aimString:Text that needs to be measured
 */
- (CGSize)sizeOfStringWithMaxSize:(CGSize)maxSize
                         textFont:(CGFloat)fontSize
                        aimString:(NSString *)aimString;
@end
