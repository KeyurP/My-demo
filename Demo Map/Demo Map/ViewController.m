//
//  ViewController.m
//  Demo Map
//
//  Created by Keyur Prajapati on 07/11/13.
//  Copyright (c) 2013 macmini19. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    MKMapSnapshotter *obj=[[MKMapSnapshotter alloc] initWithOptions:nil];
//    [obj startWithCompletionHandler:^(MKMapSnapshot *snapshot, NSError *error) {
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *documentsDirectory = [paths objectAtIndex:0];
//        [documentsDirectory stringByAppendingPathComponent:@"xyz.png"];
//        NSData *imgData = UIImagePNGRepresentation(snapshot.image);
//        [imgData writeToFile:[documentsDirectory stringByAppendingPathComponent:@"xyz.png"] atomically:NO];
//    }];
    CLLocationCoordinate2D startCoord = CLLocationCoordinate2DMake (51.3727,0.1099);
    MKCoordinateRegion adjustedRegion = [mapV regionThatFits:MKCoordinateRegionMakeWithDistance(startCoord, 700, 700)];
    [mapV setRegion:adjustedRegion animated:YES];
    
    UIPanGestureRecognizer*pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture:)];
    
    pan.delegate=self;
    pathOverlay = [[UIView alloc] init];
    [self.view addSubview:pathOverlay];
    pathOverlay.frame = mapV.frame;
    [pathOverlay addGestureRecognizer:pan];
    
    
	// Do any additional setup after loading the view, typically from a nib.
}
-(IBAction)clickSearch:(id)sender
{
    CGFloat latitude = 51.372759;
    CGFloat longitude = 0.113544;
    for (MKPolygon *vi in [mapV overlays]) {
        if([vi isKindOfClass:[MKPolygon class]]){
            if ([[[UIDevice currentDevice] systemVersion] integerValue]<7) {
                MKPolygonView *view = [[MKPolygonView alloc] initWithOverlay:vi];
                //            view.lineWidth=1;
                //            view.strokeColor=[UIColor blueColor];
                //            view.fillColor=[[UIColor blueColor] colorWithAlphaComponent:0.5];
                
                CLLocationCoordinate2D mapCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
                
                MKMapPoint mapPoint = MKMapPointForCoordinate(mapCoordinate);
                if (CLLocationCoordinate2DIsValid(mapCoordinate)) {
                    NSLog(@"Coordinate valid");
                } else {
                    NSLog(@"Coordinate invalid");
                }
                
                CGPoint polygonViewPoint = [view pointForMapPoint:mapPoint];
                
                if ( CGPathContainsPoint(view.path, NULL, polygonViewPoint, NO) ) {
                    NSLog(@"TRUE");
                }
                else {
                    NSLog(@"FALSE");
                };
            }else {
                MKPolygonRenderer *view = [[MKPolygonRenderer alloc] initWithPolygon:vi];
                //            view.lineWidth=1;
                //            view.strokeColor=[UIColor blueColor];
                //            view.fillColor=[[UIColor blueColor] colorWithAlphaComponent:0.5];
                
                CLLocationCoordinate2D mapCoordinate= CLLocationCoordinate2DMake(latitude, longitude);
                
                MKMapPoint mapPoint = MKMapPointForCoordinate(mapCoordinate);
                if (CLLocationCoordinate2DIsValid(mapCoordinate)) {
                    NSLog(@"Coordinate valid");
                } else {
                    NSLog(@"Coordinate invalid");
                }
                
                CGPoint polygonViewPoint = [view pointForMapPoint:mapPoint];
                
                if ( CGPathContainsPoint(view.path, NULL, polygonViewPoint, NO) ) {
                    NSLog(@"TRUE");
                }
                else {
                    NSLog(@"FALSE");
                };
            }
            
        }
    }

}
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    //if annotation is the user location, return nil to get default blue-dot...
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    //create purple pin view for all other annotations...
    static NSString *reuseId = @"hello";
    
    MKPinAnnotationView *myPersonalView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
    if (myPersonalView == nil)
    {
        myPersonalView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
        myPersonalView.pinColor = MKPinAnnotationColorPurple;
        myPersonalView.canShowCallout = YES;
    }
    else
    {
        //if re-using view from another annotation, point view to current annotation...
        myPersonalView.annotation = annotation;
    }
    
//    MKCircle *circle = [MKCircle circleWithCenterCoordinate:myPersonalView.annotation.coordinate radius:500.0 * cos([myPersonalView.annotation coordinate].latitude * M_PI / 180.0)];
//    [circle setTitle:@"background"];
//    [mapView addOverlay:circle];
//    
//    MKCircle *circleLine = [MKCircle circleWithCenterCoordinate:myPersonalView.annotation.coordinate radius:500.0 * cos([myPersonalView.annotation coordinate].latitude * M_PI / 180.0)];
//    [circleLine setTitle:@"line"];
//    [mapView addOverlay:circleLine];
    
    return myPersonalView;
}
- (MKOverlayView *)mapView:(MKMapView *)mapView
            viewForOverlay:(id <MKOverlay>)overlay
{
    //    NSLog(@"in viewForOverlay!");
    
    if ([overlay isKindOfClass:[MKPolygon class]])
        //^^^^^^^^^^^^^^^^^^^^
    {
        //get the MKPolygon inside the ParkingRegionOverlay...
        
        
        MKPolygonView *aView = [[MKPolygonView alloc]
                                initWithPolygon:overlay];
        //^^^^^^^^^^
        
        // aView.fillColor = [[UIColor clearColor] colorWithAlphaComponent:1.0];
        aView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:1.0];
        aView.lineWidth = 3;
        
        return aView;
    }
    return nil;
}
- (void)handleGesture:(UIPanGestureRecognizer*)gesture
{
    CGPoint location = [gesture locationInView:pathOverlay];
    
    CLLocationCoordinate2D coordinate = [mapV convertPoint:location toCoordinateFromView:pathOverlay];
    
    //    [self.coordinates addObject:[NSValue valueWithMKCoordinate:coordinate]];
    
    NSLog(@"coordinate lat = %f lon =%f",coordinate.latitude,coordinate.longitude);
    
    //     NSLog(@"coordinate = %@",self.coordinates );
    //    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    //    [dic setObject:[NSString stringWithFormat:@"%f",coordinate.latitude] forKey:@"Latitude"];
    //   [dic setObject:[NSString stringWithFormat:@"%f",coordinate.longitude] forKey:@"Longitude"];
    //    NSLog(@"Dict = %@",dic);
    //    [self.coordinates addObject:dic];
    
    
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        if (!shapeLayer)
        {
            shapeLayer = [[CAShapeLayer alloc] init];
            shapeLayer.fillColor = [[UIColor clearColor] CGColor];
            shapeLayer.strokeColor = [[UIColor greenColor] CGColor];
            shapeLayer.lineWidth = 5.0;
            [pathOverlay.layer addSublayer:shapeLayer];   // <- change here !!!
        }
        path = [[UIBezierPath alloc] init];
        [path moveToPoint:location];
    }
    else if (gesture.state == UIGestureRecognizerStateChanged)
    {
        [path addLineToPoint:location];
        shapeLayer.path = [path CGPath];
        
        NSInteger numberOfPoints = [self.coordinates count];
        
        CLLocationCoordinate2D coordinate1 = [mapV convertPoint:location toCoordinateFromView:pathOverlay];
        
        MKPolyline *newPolyLine = [MKPolyline polylineWithCoordinates:&coordinate1 count:numberOfPoints];
        [mapV addOverlay:newPolyLine];
    }
    else if (gesture.state == UIGestureRecognizerStateEnded)
    {
        
        NSInteger numberOfPoints = [self.coordinates count];
        
        [mapV addOverlay:[MKPolygon polygonWithCoordinates:(__bridge CLLocationCoordinate2D *)(self.coordinates) count:numberOfPoints]];
        
        if (numberOfPoints > 1)
        {
            
            CLLocationCoordinate2D coordinate1 = [mapV convertPoint:location toCoordinateFromView:pathOverlay];
            
            MKPolyline *newPolyLine = [MKPolyline polylineWithCoordinates:&coordinate1 count:numberOfPoints];
            [mapV addOverlay:newPolyLine];
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
