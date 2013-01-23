/**
 * Ti.Jira Module
 * Copyright (c) 2011-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiProxy.h"
#import "JMCIssue.h"
#import "TiJiraCommentProxy.h"
#import "JMCIssueStore.h"

@interface TiJiraIssueProxy : TiProxy {
    JMCIssue* _issue;
    NSString*_requestId;
    NSString* _key;
    NSString* _status;
    NSString* _summary;
    NSString* _description;
    NSDate* _dateUpdated;
    NSDate* _dateCreated;
    NSNumber* _hasUpdates;
}

@property (nonatomic, retain) NSDate* dateCreated;
@property (nonatomic, retain) NSDate* dateUpdated;
@property (nonatomic, retain) NSString* requestId;
@property (nonatomic, retain) NSString* key;
@property (nonatomic, retain) NSString* status;
@property (nonatomic, retain) NSString* summary;
@property (nonatomic, retain) NSString* description;
@property (nonatomic, retain) NSMutableArray* comments;
@property (nonatomic, assign) NSNumber* hasUpdates;

+(TiJiraIssueProxy*)issueWithIssue:(JMCIssue*)issue;
-(id)initWithIssue:(JMCIssue*)issue;

-(void)markAsRead:(id)args;

@end
