//
//  PieChartViewController.m
//  GoodDecisions
//
//  Created by Abigail Fritz on 3/18/15.
//  Copyright (c) 2015 Brian Cauble. All rights reserved.
//

#import "PieChartViewController.h"
#import "CorePlot-CocoaTouch.h"
#import "UIView+Constraints.h"
#import "Decision.h"
#import "DataManager.h"

@interface PieChartViewController () <CPTPlotDataSource, CPTPieChartDataSource, CPTPieChartDelegate, CPTLegendDelegate>
@property (nonatomic, strong) IBOutlet CPTGraphHostingView *hostView;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentControl;

@property (nonatomic, strong) CPTPieChart *pieChart;
@property (nonatomic, strong) NSArray *pieData;
@property (nonatomic, strong) NSArray *pieKeys;
@property (nonatomic, strong) NSArray *decisionData;
@property (nonatomic, strong) NSString *graphBy;
@property (nonatomic, strong) NSArray *graphByOptionStrings;
@property (nonatomic, assign) NSUInteger selectedIndex;

@end

@implementation PieChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.graphByOptionStrings = @[@"influence", @"outcome", @"score"];
    self.graphBy =self.graphByOptionStrings[self.segmentControl.selectedSegmentIndex];
    for (int i =0; i < self.graphByOptionStrings.count; i++) {
        [self.segmentControl setTitle:self.graphByOptionStrings[i] forSegmentAtIndex:i];
    }
    [self.segmentControl setBackgroundImage:[[UIImage alloc] init] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.segmentControl setBackgroundImage:[UIImage imageNamed:@"rectangle"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [self.segmentControl setDividerImage:[[UIImage alloc] init]
                forLeftSegmentState:UIControlStateNormal
                  rightSegmentState:UIControlStateNormal
                         barMetrics:UIBarMetricsDefault];
    
    [Decision findAllDecisionsWithResult:^(NSArray *objects, NSError *error) {
        self.decisionData = objects;
        
        [self pieDataForGroupBy:self.graphBy];

        
        // 1 - Create and initialize graph
        CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
        
        self.hostView.hostedGraph = graph;
        //    graph.paddingLeft = 0.0f;
//            graph.paddingTop = 0.0f;
        //    graph.paddingRight = 0.0f;
        //    graph.paddingBottom = 0.0f;
        graph.axisSet = nil;
        
        // 2 - Set up text style
//        CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
//        textStyle.color = [CPTColor brownColor];
//        textStyle.fontName = @"Helvetica-Bold";
//        textStyle.fontSize = 13.0f;
        // 3 - Configure title
//        NSString *title = [[[DataManager sharedManager].decisionTypes[0] name] capitalizedString];
//        graph.title = title;
//        graph.titleTextStyle = textStyle;
        // 4 - Set theme
//        [graph applyTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme]];
        // Do any additional setup after loading the view.
        // 1 - Get reference to graph
        //    CPTGraph *graph = self.hostView.hostedGraph;
        // 2 - Create chart
        self.pieChart = [[CPTPieChart alloc] init];
        self.pieChart.dataSource = self;
        self.pieChart.delegate = self;
        self.pieChart.pieRadius = (self.hostView.bounds.size.width * 0.8) / 2;
        self.pieChart.pieInnerRadius = (self.hostView.bounds.size.width * 0.55) / 2;

//        self.pieChart.identifier = graph.title;
        self.pieChart.attributedTitle = [[NSAttributedString alloc] initWithString:@"test"];
        self.pieChart.startAngle = M_PI_4;
        self.pieChart.sliceDirection = CPTPieDirectionClockwise;
        
//        self.pieChart.labelRotationRelativeToRadius = YES;
//        CPTMutableLineStyle *line=[CPTMutableLineStyle lineStyle];
//        line.lineColor=[CPTColor whiteColor];
//        line.lineWidth = 3.;
//        self.pieChart.borderLineStyle=line;
//
        self.pieChart.labelOffset = 0;
        self.pieChart.centerAnchor = CGPointMake(0.5, 0.68);
//        // 3 - Create gradient
//        CPTGradient *overlayGradient = [[CPTGradient alloc] init];
//        overlayGradient.gradientType = CPTGradientTypeRadial;
//        overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.0] atPosition:0.9];
//        overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.4] atPosition:1.0];
//        self.pieChart.overlayFill = [CPTFill fillWithGradient:overlayGradient];
        // 4 - Add chart to graph
        [graph addPlot:self.pieChart];
        
        CPTLegend *theLegend = [CPTLegend legendWithGraph:graph];
        theLegend.delegate = self;
        // 3 - Configure legend
        theLegend.numberOfColumns = 2;
        theLegend.equalRows = @YES;
        theLegend.rowMargin = 5.;
        theLegend.fill = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:1. green:1. blue:1. alpha:.5]];
        theLegend.borderLineStyle = nil;
        theLegend.cornerRadius = 5.0;
        // 4 - Add legend to graph
        graph.legend = theLegend;
        graph.legendAnchor = CPTRectAnchorBottom;
//        CGFloat legendPadding = -(self.view.bounds.size.width);
        graph.legendDisplacement = CGPointMake(0., 25.);

    }];
    }

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)didSelectSegment:(id)sender{
    self.graphBy =self.graphByOptionStrings[self.segmentControl.selectedSegmentIndex];
    [self pieDataForGroupBy:self.graphBy];
    [self.pieChart reloadData];

}

-(void)pieDataForGroupBy:(NSString *)groupBy{
    //TODO:: use the groupBy string
    NSString *path = [NSString stringWithFormat:@"@distinctUnionOfObjects.%@", groupBy];
    self.pieKeys = [self.decisionData valueForKeyPath:path];
    
    NSString *predicateString = [NSString stringWithFormat:@"%@ = $object", groupBy];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
    
    NSMutableArray *mArray= [@[] mutableCopy];
    for (id obj in self.pieKeys) {
        NSArray *array = [self.decisionData filteredArrayUsingPredicate:[predicate predicateWithSubstitutionVariables:@{@"object":obj}]];
        [mArray addObject:array];
    }

    if([self.pieKeys[0] isKindOfClass:NSNumber.class]){
        self.pieData= [mArray sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"@max.score"
                                                                                      ascending:NO]]];

        id obj = [[mArray sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"@count"
                                                                                      ascending:NO]]] firstObject];
        self.selectedIndex = [self.pieData indexOfObject:obj];

        
    }else{
        self.pieData= [mArray sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"@count"
                                                                                      ascending:NO]]];
        self.selectedIndex = 0;

    }
    

   
    //get sorted pieKeys
    NSMutableArray *sortedKeys = [@[] mutableCopy];
    for (NSArray *array in self.pieData) {
        [sortedKeys addObject:[array lastObject][groupBy]];
    }
    self.pieKeys = sortedKeys;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - CPTPlotDataSource methods
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return self.pieData.count;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    if (CPTPieChartFieldSliceWidth == fieldEnum)
    {
        return @([self.pieData[index] count]);
    }
    return [NSDecimalNumber zero];
}

//-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index {
//    // 1 - Define label text style
//    static CPTMutableTextStyle *labelText = nil;
//    if (!labelText) {
//        labelText= [[CPTMutableTextStyle alloc] init];
//        labelText.color = [CPTColor brownColor];
//    }
//    
//    // 4 - Set up display label
//    NSString *labelValue = [NSString stringWithFormat:@"%@ %@", @([self.pieData[index] count]), [self.pieKeys[index] name]];
//    // 5 - Create and return layer with label text
//    return [[CPTTextLayer alloc] initWithText:labelValue style:labelText];
//}

//-(NSString *)legendTitleForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index {
//    if (index < self.pieData.count) {
//        if([self.pieKeys[index] respondsToSelector:@selector(name)]){
//            return [NSString stringWithFormat:@"%@ : %@", @([self.pieData[index] count]), [self.pieKeys[index] name]];
//        }
//        else{
//            return [NSString stringWithFormat:@"%@ : %@", @([self.pieData[index] count]), self.pieKeys[index]];
//        }
//    }
//    return @"N/A";
//}

-(NSAttributedString *)attributedLegendTitleForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)idx{
    
    if (idx < self.pieData.count) {

    
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ : ", @([self.pieData[idx] count])]];
        
            if([self.pieKeys[idx] respondsToSelector:@selector(name)]){
                 [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:[self.pieKeys[idx] name]]];
            }else if ([self.pieKeys[idx] isKindOfClass:NSNumber.class]){
                NSNumber *value = self.pieKeys[idx];
                NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
                NSNumber *imageOffset = nil;
                if ([value isGreaterThan:@0]) {
                    textAttachment.image = [[UIImage imageNamed:@"thumbs_up_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                    imageOffset = @-2;
                }else if ([value isLessThan:@0]){
                    textAttachment.image = [[UIImage imageNamed:@"thumbs_down_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                    imageOffset = @-6;
                }else{
                    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"none"]];
                }
                
                if (textAttachment.image) {
                    NSMutableAttributedString *attrStringWithImage = [[NSAttributedString attributedStringWithAttachment:textAttachment] mutableCopy];
                    [attrStringWithImage
                     addAttribute: NSBaselineOffsetAttributeName
                     value: imageOffset
                     range: NSMakeRange(0, 1)];
                    
                    for (int i=0; i< abs([value intValue]); i++) {
                        [attributedString appendAttributedString:attrStringWithImage];
                    }
                }
                
            }

        if (idx == self.selectedIndex) {
            [attributedString addAttribute:NSForegroundColorAttributeName value:[[self colorForIndex:idx].uiColor colorWithAlphaComponent:.9] range:NSMakeRange(0, [attributedString length])];
        }else{
            [attributedString addAttribute:NSForegroundColorAttributeName value:[CPTColor brownColor].uiColor range:NSMakeRange(0, [attributedString length])];
        }
        [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15.] range:NSMakeRange(0, [attributedString length])];
        return attributedString;
    }
    
    return [[NSAttributedString alloc] initWithString:@"N/A"];
}

-(CGFloat)radialOffsetForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)idx{

    if (idx == self.selectedIndex) {
        return 12.0;
    }

    return 3.0;
}

-(CPTFill *)sliceFillForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)idx{
       return [CPTFill fillWithColor:[self colorForIndex:idx]];
 }

-(CPTColor *)colorForIndex:(NSUInteger)idx{
    NSArray *array = self.pieData[idx];
    CGFloat offset = (float)array.count/(float)self.decisionData.count;
    CGFloat alphaValue = offset+((self.pieData.count -(float)idx)/15);
    
    if ([self.pieKeys[idx] isKindOfClass:NSNumber.class]) {
        
        NSNumber *value = self.pieKeys[idx];
        alphaValue = .15* MAX(fabsf([value floatValue]), 1.0);

        if ([value isGreaterThan:@0]) {
            return [CPTColor colorWithComponentRed:30./255. green:179./255. blue:23./255. alpha:alphaValue];
            
        }else if ([value isLessThan:@0]){
            return [CPTColor colorWithComponentRed:255/255. green:87/255. blue:59/255. alpha:alphaValue];
        }else{
            return [CPTColor colorWithComponentRed:80/255. green:80/255. blue:50/255. alpha:alphaValue];
        }
        
    }else{
        if (idx == self.selectedIndex) {
            return [CPTColor colorWithComponentRed:255/255. green:87/255. blue:59/255. alpha:alphaValue+.1];
        }
        return [CPTColor colorWithComponentRed:80/255. green:80/255. blue:50/255. alpha:alphaValue];
    }

}

-(void)pieChart:(CPTPieChart *)plot sliceWasSelectedAtRecordIndex:(NSUInteger)idx{
    self.selectedIndex = idx;
    [plot reloadData];
    DDLogDebug(@"selected slice");
}

-(void)legend:(CPTLegend *)legend legendEntryForPlot:(CPTPlot *)plot wasSelectedAtIndex:(NSUInteger)idx{
    self.selectedIndex = idx;
    [plot reloadData];

}

//-(CPTLineStyle *)legend:(CPTLegend *)legend lineStyleForEntryAtIndex:(NSUInteger)idx forPlot:(CPTPlot *)plot{
//    if (idx == self.selectedIndex) {
//        CPTMutableLineStyle *lineStyle = [CPTLineStyle lineStyle];
//        lineStyle.lineWidth = 1.0;
//        lineStyle.lineColor = [CPTColor brownColor];
//        return lineStyle;
//    }else{
//        return nil;
//    }
//    
//}

//-(CPTLineStyle *)legend:(CPTLegend *)legend lineStyleForSwatchAtIndex:(NSUInteger)idx forPlot:(CPTPlot *)plot{
//    if (idx == self.selectedIndex) {
//        CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
//        lineStyle.lineWidth = 2.0;
//        lineStyle.lineColor = [CPTColor brownColor];
//        return lineStyle;
//    }else{
//        return nil;
//    }}

@end
