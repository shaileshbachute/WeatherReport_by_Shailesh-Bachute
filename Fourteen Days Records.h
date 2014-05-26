//
//  Fourteen Days Records.h
//  WeatherInfoApp_by_Shailesh_Bachute
//
//  Created by Alet Viegas on 23/05/14.
//  Copyright (c) 2014 Alet Viegas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface Fourteen_Days_Records : UIViewController
{
    NSMutableArray *listArray,*tempratureArray,*rainArray,*humidityArray,*cloudArray;
    NSMutableArray *dayTempArray,*nightTempArray,*eveningTempArray,*morningTempArray;
    NSMutableArray *minTempArray,*maxTempArray;
    NSMutableString *strCityName,*strCurrentTemp;
    int selectedIndex;
    AppDelegate *objOfAppDelegate;
}

@property(nonatomic,retain) IBOutlet UIActivityIndicatorView *actLoad;

@end
