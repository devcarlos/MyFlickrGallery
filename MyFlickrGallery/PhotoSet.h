//
//  PhotoSet.h
//  MyFlickrGallery
//
//  Created by Carlos Alcala on 3/21/13.
//  Copyright (c) 2013 Carlos Alcala. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Three20/Three20.h"

@interface PhotoSet : TTURLRequestModel <TTPhotoSource> {
    NSString *_title;
    NSArray *_photos;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, retain) NSArray *photos;

+ (PhotoSet *)samplePhotoSet;

@end