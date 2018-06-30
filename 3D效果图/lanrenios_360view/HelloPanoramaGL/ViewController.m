/*
 * PanoramaGL library
 * Version 0.1
 * Copyright (c) 2010 Javier Baez <javbaezga@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#define kIdMin 1
#define kIdMax 1000

#import "ViewController.h"

@implementation ViewController

@synthesize segmentedControl;

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void)viewDidLoad
{
    [super viewDidLoad];
    plView = (PLView *)self.view;
    plView.delegate = self;
    [self selectPanorama:0];
    //JSON loader example (see json.data, json_s2.data and json_cubic.data)
    //[plView load:[PLJSONLoader loaderWithPath:[[NSBundle mainBundle] pathForResource:@"json_cubic" ofType:@"data"]]];
}

-(void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(IBAction)segmentedControlIndexChanged:(id)sender
{
    [self selectPanorama:segmentedControl.selectedSegmentIndex];
}

-(void)selectPanorama:(NSInteger)index
{
    NSObject<PLIPanorama> *panorama = nil;
    //Spherical2 panorama example (supports up 2048x1024 texture)
    if(index == 0)
    {
        panorama = [PLSpherical2Panorama panorama];
        [(PLSpherical2Panorama *)panorama setImage:[PLImage imageWithPath:[[NSBundle mainBundle] pathForResource:@"pano_sphere2" ofType:@"jpg"]]];
    }
    //Spherical panorama example (supports up 1024x512 texture)
    else if(index == 1)
    {
        panorama = [PLSphericalPanorama panorama];
        [(PLSphericalPanorama *)panorama setTexture:[PLTexture textureWithImage:[PLImage imageWithPath:[[NSBundle mainBundle] pathForResource:@"pano_sphere" ofType:@"jpg"]]]];
    }
    //Cubic panorama example (supports up 1024x1024 texture per face)
    else if(index == 2)
    {
        PLCubicPanorama *cubicPanorama = [PLCubicPanorama panorama];
        [cubicPanorama setTexture:[PLTexture textureWithImage:[PLImage imageWithPath:[[NSBundle mainBundle] pathForResource:@"pano_f" ofType:@"jpg"]]] face:PLCubeFaceOrientationFront];
        [cubicPanorama setTexture:[PLTexture textureWithImage:[PLImage imageWithPath:[[NSBundle mainBundle] pathForResource:@"pano_b" ofType:@"jpg"]]] face:PLCubeFaceOrientationBack];
        [cubicPanorama setTexture:[PLTexture textureWithImage:[PLImage imageWithPath:[[NSBundle mainBundle] pathForResource:@"pano_l" ofType:@"jpg"]]] face:PLCubeFaceOrientationLeft];
        [cubicPanorama setTexture:[PLTexture textureWithImage:[PLImage imageWithPath:[[NSBundle mainBundle] pathForResource:@"pano_r" ofType:@"jpg"]]] face:PLCubeFaceOrientationRight];
        [cubicPanorama setTexture:[PLTexture textureWithImage:[PLImage imageWithPath:[[NSBundle mainBundle] pathForResource:@"pano_u" ofType:@"jpg"]]] face:PLCubeFaceOrientationUp];
        [cubicPanorama setTexture:[PLTexture textureWithImage:[PLImage imageWithPath:[[NSBundle mainBundle] pathForResource:@"pano_d" ofType:@"jpg"]]] face:PLCubeFaceOrientationDown];
        panorama = cubicPanorama;
    }
    //Cylindrical panorama example (supports up 1024x1024 texture)
    else if(index == 3)
    {
        panorama = [PLCylindricalPanorama panorama];
        ((PLCylindricalPanorama *)panorama).isHeightCalculated = NO;
        [(PLCylindricalPanorama *)panorama setTexture:[PLTexture textureWithImage:[PLImage imageWithPath:[[NSBundle mainBundle] pathForResource:@"pano_sphere" ofType:@"jpg"]]]];
    }
    //Add a hotspot
    PLTexture *hotspotTexture = [PLTexture textureWithImage:[PLImage imageWithPath:[[NSBundle mainBundle] pathForResource:@"hotspot" ofType:@"png"]]];
    PLHotspot *hotspot = [PLHotspot hotspotWithId:(kIdMin + random() % ((kIdMax + 1) - kIdMin)) texture:hotspotTexture atv:0.0f ath:0.0f width:0.08f height:0.08f];
    [panorama addHotspot:hotspot];
    [plView setPanorama:panorama];
}

//Hotspot event
-(void)view:(UIView<PLIView> *)pView didClickHotspot:(PLHotspot *)hotspot screenPoint:(CGPoint)point scene3DPoint:(PLPosition)position
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Hotspot" message:[NSString stringWithFormat:@"You select the hotspot with ID %d", hotspot.identifier] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
    [alertView release];
    //You can load a panorama view
    /*
    PLSpherical2Panorama *panorama = [PLSpherical2Panorama panorama];
    [panorama setImage:[PLImage imageWithPath:[[NSBundle mainBundle] pathForResource:@"pano_sphere2" ofType:@"jpg"]]];
    [pView setPanorama:panorama];
    */
}

-(void)dealloc
{
    if(segmentedControl)
        [segmentedControl release];
    [super dealloc];
}

@end
