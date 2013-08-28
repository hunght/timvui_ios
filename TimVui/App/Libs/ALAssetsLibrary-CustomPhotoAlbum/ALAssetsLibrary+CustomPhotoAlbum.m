//
//  ALAssetsLibrary category to handle a custom photo album
//
//  Created by Marin Todorov on 10/26/11.
//  Copyright (c) 2011 Marin Todorov. All rights reserved.
//

#import "ALAssetsLibrary+CustomPhotoAlbum.h"

@interface ALAssetsLibrary (Private)

/*! Write the asset to the assets library (camera roll). (Private)
 *
 * \param assetURL The asset URL
 * \param albumName Custom album name
 * \param failure Block to be executed when failed to add the asset to the custom photo album
 */
-(void)_addAssetURL:(NSURL *)assetURL
            toAlbum:(NSString *)albumName
            failure:(ALAssetsLibraryAccessFailureBlock)failure;

/*! A block wraper to be executed after asset adding process done. (Private)
 *
 * \param albumName Custom album name
 * \param completion Block to be executed when succeed to add the asset to the assets library (camera roll)
 * \param failure Block to be executed when failed to add the asset to the custom photo album
 */
- (ALAssetsLibraryWriteImageCompletionBlock)_resultBlockOfAddingToAlbum:(NSString *)albumName
                                                             completion:(ALAssetsLibraryWriteImageCompletionBlock)completion
                                                                failure:(ALAssetsLibraryAccessFailureBlock)failure;

@end


@implementation ALAssetsLibrary (CustomPhotoAlbum)

#pragma mark - Public Method

- (void)saveImage:(UIImage *)image
          toAlbum:(NSString *)albumName
       completion:(ALAssetsLibraryWriteImageCompletionBlock)completion
          failure:(ALAssetsLibraryAccessFailureBlock)failure
{
  [self writeImageToSavedPhotosAlbum:image.CGImage
                         orientation:(ALAssetOrientation)image.imageOrientation 
                     completionBlock:[self _resultBlockOfAddingToAlbum:albumName
                                                            completion:completion
                                                               failure:failure]];
}

- (void)saveVideo:(NSURL *)videoUrl
          toAlbum:(NSString *)albumName
       completion:(ALAssetsLibraryWriteImageCompletionBlock)completion
          failure:(ALAssetsLibraryAccessFailureBlock)failure
{
    [self writeVideoAtPathToSavedPhotosAlbum: videoUrl
                             completionBlock:[self _resultBlockOfAddingToAlbum:albumName
                                                                    completion:completion
                                                                       failure:failure]];
}

- (void)saveImageData:(NSData *)imageData
              toAlbum:(NSString *)albumName
             metadata:(NSDictionary *)metadata
           completion:(ALAssetsLibraryWriteImageCompletionBlock)completion
              failure:(ALAssetsLibraryAccessFailureBlock)failure
{
  [self writeImageDataToSavedPhotosAlbum:imageData
                                metadata:metadata
                         completionBlock:[self _resultBlockOfAddingToAlbum:albumName
                                                                completion:completion
                                                                   failure:failure]];
  
}

#pragma mark - Private Method

-(void)_addAssetURL:(NSURL *)assetURL
            toAlbum:(NSString *)albumName
            failure:(ALAssetsLibraryAccessFailureBlock)failure
{
  __block BOOL albumWasFound = NO;
  
  ALAssetsLibraryGroupsEnumerationResultsBlock enumerationBlock;
  enumerationBlock = ^(ALAssetsGroup *group, BOOL *stop) {
    // compare the names of the albums
    if ([albumName compare:[group valueForProperty:ALAssetsGroupPropertyName]] == NSOrderedSame) {
      // target album is found
      albumWasFound = YES;
      
      // get a hold of the photo's asset instance
      [self assetForURL:assetURL 
            resultBlock:^(ALAsset *asset) {
              // add photo to the target album
              [group addAsset:asset];
            }
           failureBlock:failure];
      
      // album was found, bail out of the method
      return;
    }
    
    if (group == nil && albumWasFound == NO) {
      // photo albums are over, target album does not exist, thus create it
      
      // Since you use the assets library inside the block,
      //   ARC will complain on compile time that there’s a retain cycle.
      //   When you have this – you just make a weak copy of your object.
      //
      //   __weak ALAssetsLibrary * weakSelf = self;
      //
      // by @Marin.
      //
      // I don't use ARC right now, and it leads a warning.
      // by @Kjuly
      ALAssetsLibrary * weakSelf = self;
      
      // if iOS version is lower than 5.0, throw a warning message
      if (! [self respondsToSelector:@selector(addAssetsGroupAlbumWithName:resultBlock:failureBlock:)])
        NSLog(@"![WARNING][LIB:ALAssetsLibrary+CustomPhotoAlbum]: \
              |-addAssetsGroupAlbumWithName:resultBlock:failureBlock:| \
              only available on iOS 5.0 or later. \
              ASSET cannot be saved to album!");
      // create new assets album
      else [self addAssetsGroupAlbumWithName:albumName
                                 resultBlock:^(ALAssetsGroup *group) {
                                   // get the photo's instance
                                   [weakSelf assetForURL:assetURL
                                             resultBlock:^(ALAsset *asset) {
                                               // add photo to the newly created album
                                               [group addAsset:asset];
                                             }
                                            failureBlock:failure];
                                 }
                                failureBlock:failure];
      
      // should be the last iteration anyway, but just in case
      return;
    }
  };
  
  // search all photo albums in the library
  [self enumerateGroupsWithTypes:ALAssetsGroupAlbum
                      usingBlock:enumerationBlock
                    failureBlock:failure];
}

- (ALAssetsLibraryWriteImageCompletionBlock)_resultBlockOfAddingToAlbum:(NSString *)albumName
                                                             completion:(ALAssetsLibraryWriteImageCompletionBlock)completion
                                                                failure:(ALAssetsLibraryAccessFailureBlock)failure
{
  ALAssetsLibraryWriteImageCompletionBlock result = ^(NSURL *assetURL, NSError *error) {
    // run the completion block for writing image to saved
    //   photos album
    if (completion) completion(assetURL, error);
    
    // if an error occured, do not try to add the asset to
    //   the custom photo album
    if (error != nil)
      return;
    
    // add the asset to the custom photo album
    [self _addAssetURL:assetURL
               toAlbum:albumName
               failure:failure];
  };
  return [result copy];
}

@end
