//
//  PhotoSet.m
//  MyFlickrGallery
//
//  Created by Carlos Alcala on 3/21/13.
//  Copyright (c) 2013 Carlos Alcala. All rights reserved.
//

#import "PhotoSet.h"
#import "Photo.h"
#import "FlickrAPIKey.h"
#import <SBJson/SBJson.h>

@implementation PhotoSet

@synthesize title = _title;
@synthesize photos = _photos;

- (id) initWithTitle:(NSString *)title photos:(NSArray *)photos {
    if ((self = [super init])) {

        self.title = title;
        self.photos = photos;
        for(int i = 0; i < _photos.count; ++i) {
            Photo *photo = [_photos objectAtIndex:i];
            photo.photoSource = self;
            photo.index = i;
        }
    }
    return self;
}

- (void) dealloc {
    self.title = nil;
    self.photos = nil;
    //[super dealloc];
}

#pragma mark TTModel

- (BOOL)isLoading {
    return FALSE;
}

- (BOOL)isLoaded {
    return TRUE;
}

#pragma mark TTPhotoSource

- (NSInteger)numberOfPhotos {
    return _photos.count;
}

- (NSInteger)maxPhotoIndex {
    return _photos.count-1;
}

- (id<TTPhoto>)photoAtIndex:(NSInteger)photoIndex {
    if (photoIndex < _photos.count) {
        return [_photos objectAtIndex:photoIndex];
    } else {
        return nil;
    }
}

static PhotoSet *samplePhotoSet = nil;

+ (PhotoSet *) samplePhotoSet {
    @synchronized(self) {
        if (samplePhotoSet == nil) {
            
            //////////////////////
            //Flickr API logic  //
            //////////////////////
            
            //Build your Flickr API request w/Flickr API key in FlickrAPIKey.h andsearch for the "wedding" tag
            NSString *urlString = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&user_id=%@&tags=%@&per_page=20&format=json&nojsoncallback=1", FlickrAPIKey, FlickrUserID, @"wedding"];
            
            NSURL *url = [NSURL URLWithString:urlString];
            
            //Log URL API String generated
            NSLog(@"URL : %@", urlString);
            
            //Get URLResponse string & parse JSON to Foundation objects.
            NSString *jsonString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
            
            //NSDictionary *results = [jsonString JSONValue];
            
            //Fixed issue about ARC NSString not defined JSONValue
            NSError *error;
            NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *results = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
            
            //parse results and build our arrays
            NSArray *photos = [[results objectForKey:@"photos"] objectForKey:@"photo"];
            NSMutableArray *FlickrPhotos = [[NSMutableArray alloc] init];
            
            for (NSDictionary *photo in photos) {
                //Get title for e/ photo
                NSString *title = [photo objectForKey:@"title"];
                
                //Construct URL for e/ photo for each size avaiable (Large, Small, Thumbnail)
                //https://secure.flickr.com/services/api/misc.urls.html
                
                //Large
                NSString *photoURLStringLarge = [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_b.jpg", [photo objectForKey:@"farm"], [photo objectForKey:@"server"], [photo objectForKey:@"id"], [photo objectForKey:@"secret"]];

                //Small
                NSString *photoURLStringSmall = [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_s.jpg", [photo objectForKey:@"farm"], [photo objectForKey:@"server"], [photo objectForKey:@"id"], [photo objectForKey:@"secret"]];

                //Thumbnail
                NSString *photoURLStringThumb = [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_t.jpg", [photo objectForKey:@"farm"], [photo objectForKey:@"server"], [photo objectForKey:@"id"], [photo objectForKey:@"secret"]];
                
                //set up the URL string for each dimension photo (large, small, thumb)
                Photo *newPhoto = [[Photo alloc] initWithCaption:title
                                                         urlLarge:photoURLStringLarge
                                                         urlSmall:photoURLStringSmall
                                                         urlThumb:photoURLStringThumb
                                                             size:CGSizeMake(1024, 768)];
                //attach the new Photo object to the array
                [FlickrPhotos addObject:newPhoto];
                
            }
            
            //attach the Flickr Photos to the PhotoSet
            samplePhotoSet = [[self alloc] initWithTitle:@"My Flickr Gallery" photos:FlickrPhotos];
        }
    }
    return samplePhotoSet;
}

@end