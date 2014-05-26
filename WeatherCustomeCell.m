//
//  WeatherCustomeCell.m
//  WeatherInfoApp_by_Shailesh_Bachute
//
//  Created by Alet Viegas on 23/05/14.
//  Copyright (c) 2014 Alet Viegas. All rights reserved.
//

#import "WeatherCustomeCell.h"

@implementation WeatherCustomeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
