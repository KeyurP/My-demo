//
//  ViewController.h
//  Demo Map
//
//  Created by Keyur Prajapati on 07/11/13.
//  Copyright (c) 2013 macmini19. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface ViewController : UIViewController<MKMapViewDelegate,UIGestureRecognizerDelegate> {
    IBOutlet MKMapView *mapV;
    UIView *pathOverlay;
    CAShapeLayer *shapeLayer;
    UIBezierPath *path;
    CLLocationCoordinate2D coordinate2;
    
}
@property (nonatomic, strong) NSMutableArray *coordinates;
@end
