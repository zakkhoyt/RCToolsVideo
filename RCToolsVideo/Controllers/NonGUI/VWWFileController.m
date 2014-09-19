//
//  APM Logger
//
//  Created by Zakk Hoyt 2014
//  Copyright (c) 2014 Zakk Hoyt.
//

#import "VWWFileController.h"
#import "VWW.h"
//#import "VWWSession.h"

@implementation VWWFileController
#pragma mark Public methods

+(NSString*)nameOfFileAtURL:(NSURL*)url{
    return [url lastPathComponent];
}
+(NSString*)sizeOfFileAtURL:(NSURL*)url{
    NSError *error;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:url.path error:&error];
    if(error){
        VWW_LOG_ERROR(@"Could not read size of file: %@", url.path);
        return 0;
    }
    UInt32 size = (UInt32)[attrs fileSize];
    return [NSString stringWithFormat:@"%ld", (long)size];
}
+(NSString*)dateOfFileAtURL:(NSURL*)url{
    NSError *error;
    NSDictionary* attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:url.path error:&error];
    
    if(error){
        VWW_LOG_ERROR(@"Could not read date of file: %@ with error: %@", url.path, error.description);
        return @"";
    }
    
    if (attrs == nil) {
        VWW_LOG_ERROR(@"Could not read date attributes of file: %@", url.path);
        return @"";
    }
    
    NSDate *date = (NSDate*)[attrs objectForKey: NSFileCreationDate];
    return [VWWUtilities stringFromDateAndTime:date];
}

+(NSURL*)urlForDocumentsDirectory{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSURL *url = [NSURL fileURLWithPath:documentsDirectory];
    return url;
}

+(NSString*)pathForDocumentsDirectory{
    NSURL *url = [VWWFileController urlForDocumentsDirectory];
    return url.path;
}


//+(BOOL)copyLogFileFromBundleToLogsDir{
//    NSArray *logFilePaths = [NSBundle pathsForResourcesOfType:@"log" inDirectory:[[NSBundle mainBundle] bundlePath]];
//    for(NSString *logFilePath in logFilePaths){
//        NSURL *logFileURL = [NSURL fileURLWithPath:logFilePath];
//        [VWWFileController copyFileAtURLToLogsDir:logFileURL];
//    }
//    return YES;
//}

+(BOOL)deleteFileAtURL:(NSURL*)url{
    NSError *error;
    if([[NSFileManager defaultManager] removeItemAtURL:url error:&error] == NO){
        return NO;
    }
    if(error){
        VWW_LOG_WARNING(@"Could not delete file: %@", url.path);
        return NO;
    }
    return YES;
}


+(BOOL)fileExistsAtURL:(NSURL*)url{
    return [[NSFileManager defaultManager] fileExistsAtPath:url.path];
}

#pragma mark Private methods
+(void)ensureDirectoryExistsAtURL:(NSURL*)url{
    if ([[NSFileManager defaultManager] fileExistsAtPath:url.path] == NO){
        NSError* error;
        if([[NSFileManager defaultManager]createDirectoryAtPath:url.path withIntermediateDirectories:YES attributes:nil error:&error]){
            VWW_LOG_DEBUG(@"Created dir at %@", url.path);
        } else {
            VWW_LOG_DEBUG(@"Failed to create dir :%@ with error: %@", url.path, error.description);
        }
    }
}


//+(void)writeSessionToDisk:(VWWSession*)session completionBlock:(VWWBoolBlock)completionBlock{
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//        // Convert session to JSON
//        NSDictionary *sessionDictionary = [session dictionaryRepresentation];
//        NSString *sessionString = [VWWUtilities jsonStringFromDictionary:sessionDictionary prettyPrint:YES];
////        VWW_LOG_INFO(@"Writing session to disk: \n%@", sessionString);
//        
//        
//        NSURL *documentsURL = [VWWFileController urlForDocumentsDirectory];
//        // Name the file [NSDate date].session
//        NSURL *sessionURL = [[documentsURL URLByAppendingPathComponent:[VWWUtilities stringFromDateAndTime:session.date]] URLByAppendingPathExtension:@"session"];
//        
//        
//        NSError *error = nil;
//        BOOL success = [sessionString writeToURL:sessionURL atomically:YES encoding:NSUTF8StringEncoding error:&error];
//    
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if(error || success == NO){
//                VWW_LOG_WARNING(@"Failed to write session to disk at url: %@", sessionURL.absoluteString);
//                return  completionBlock(NO);
//            }
//            
//            VWW_LOG_INFO(@"Wrote file to disk at URL: %@", sessionURL.absoluteString);
//            [[NSNotificationCenter defaultCenter] postNotificationName:VWWFileControllerSessionsChanged object:nil];
//            return completionBlock(YES);
//        });
//    });
//}
//
//
//+(NSArray*)urlsForSessions{
//    NSURL *documentsURL = [VWWFileController urlForDocumentsDirectory];
//    NSError *error;
//    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:documentsURL includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:&error];
//    NSMutableArray *logs = [@[] mutableCopy];
//    for(int index = 0; index < files.count; index++){
//        NSString * file = [files objectAtIndex:index];
//        if([[file pathExtension] compare:@"session"] == NSOrderedSame){
//            [logs addObject:file];
//        }
//    }
//    return logs;
//}
//
//
//
//+(void)sessionFromURL:(NSURL*)url completionBlock:(VWWSessionBlock)completionBlock{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//
//        // Read file:
//        NSError *error = nil;
//        NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:&error];
//        if(error || data == nil){
//            dispatch_async(dispatch_get_main_queue(), ^{
//                return completionBlock(nil);
//            });
//        }
//        
//
//        // Convert json string to dictionary
//        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
//        VWW_LOG_INFO(@"Read session: %@", dictionary);
//        
//        // Convert to session:
//        VWWSession *session = [[VWWSession alloc]initWithDictionary:dictionary];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            return completionBlock(session);
//        });
//
//    });
//}



@end
