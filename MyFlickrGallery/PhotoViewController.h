//
//  PhotoViewController.h
//  MyFlickrGallery
//
//  Created by Carlos Alcala on 3/21/13.
//  Copyright (c) 2013 Carlos Alcala. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>

@class PhotoSet;

@interface PhotoViewController : TTPhotoViewController {
    PhotoSet *_photoSet;
}

@property (nonatomic, retain) PhotoSet *photoSet;

@end