//
//  ViewController.h
//  PanoramaGL library
//
//  Created by apple on 13-10-3.
//  Copyright (c) 2013年 apple. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "PLView.h"
#import "PLJSONLoader.h"

@interface ViewController : UIViewController <PLViewDelegate>
{
@private
    PLView *plView;
    UISegmentedControl *segmentedControl;
}

@property(nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;

-(void)selectPanorama:(NSInteger)index;

-(IBAction)segmentedControlIndexChanged:(id)sender;

@end
