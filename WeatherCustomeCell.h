//
//  WeatherCustomeCell.h
//  WeatherInfoApp_by_Shailesh_Bachute
//
//  Created by Alet Viegas on 23/05/14.
//  Copyright (c) 2014 Alet Viegas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherCustomeCell : UITableViewCell



@property (weak, nonatomic) IBOutlet UILabel *lblMaxTemp;
@property (weak, nonatomic) IBOutlet UILabel *lblLowTemp;
@property (weak, nonatomic) IBOutlet UILabel *lblCityName;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrentTemp;
@property (weak, nonatomic) IBOutlet UILabel *lblHumidity;
@property (weak, nonatomic) IBOutlet UILabel *lblCloud;
@property (weak, nonatomic) IBOutlet UILabel *lblRain;
@property (weak, nonatomic) IBOutlet UILabel *lblDays;



@end
