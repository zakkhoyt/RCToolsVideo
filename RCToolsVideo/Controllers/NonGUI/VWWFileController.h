//
//  APM Logger
//
//  Created by Zakk Hoyt 2014
//  Copyright (c) 2014 Zakk Hoyt.
//


#import <Foundation/Foundation.h>
#import "VWW.h"

//@class VWWSession;

static NSString *VWWFileControllerSessionsChanged = @"VWWFileControllerSessionsChanged";

@interface VWWFileController : NSObject
+(NSString*)nameOfFileAtURL:(NSURL*)url;
+(NSString*)sizeOfFileAtURL:(NSURL*)url;
+(NSString*)dateOfFileAtURL:(NSURL*)url;
+(NSURL*)urlForDocumentsDirectory;
+(NSString*)pathForDocumentsDirectory;
//+(BOOL)copyLogFileFromBundleToLogsDir;
+(BOOL)deleteFileAtURL:(NSURL*)url;
+(BOOL)fileExistsAtURL:(NSURL*)url;


//+(void)writeSessionToDisk:(VWWSession*)session completionBlock:(VWWBoolBlock)completionBlock;
//+(NSArray*)urlsForSessions;
//+(void)sessionFromURL:(NSURL*)url completionBlock:(VWWSessionBlock)completionBlock;
@end




//@interface VWWFileController (Videos)
//+(NSURL*)urlForVideosDirectory;
//+(void)printURLsForVideos;
//+(NSArray*)urlsForVideos;
//+(BOOL)deleteVideoAtURL:(NSURL*)url;
//+(BOOL)deleteAllVideos;
//@end
//
//@interface VWWFileController (Logs)
//+(NSURL*)urlForLogsDirectory;
//+(NSString*)pathForLogsDirectory;
//+(BOOL)copyFileAtURLToLogsDir:(NSURL*)url;
//+(void)printURLsForLogs;
//+(NSArray*)urlsForLogs;
//+(BOOL)deleteLogAtURL:(NSURL*)url;
//+(BOOL)deleteAllLogs;
//@end
//
//
//@interface VWWFileController (Databases)
//+(NSURL*)urlForDatabasesDirectory;
//+(NSString*)pathForDatabasesDirectory;
//+(BOOL)copyFileAtURLToDatabasesDir:(NSURL*)url;
//+(void)printURLsForDatabases;
//+(NSArray*)urlsForDatabases;
//+(BOOL)deleteDatabasesAtURL:(NSURL*)url;
//+(BOOL)deleteAllDatabases;
//@end
