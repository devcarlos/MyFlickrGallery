//
//  PhotoViewController.m
//  MyFlickrGallery
//
//  Created by Carlos Alcala on 3/21/13.
//  Copyright (c) 2013 Carlos Alcala. All rights reserved.
//

#import "PhotoViewController.h"
#import "PhotoSet.h"

@implementation PhotoViewController
@synthesize photoSet = _photoSet;

- (void) viewDidLoad {
    self.photoSource = [PhotoSet samplePhotoSet];
}

- (void) dealloc {
    self.photoSet = nil;
    //[super dealloc];
}

@end