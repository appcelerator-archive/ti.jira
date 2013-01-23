/**
   Copyright 2011 Atlassian Software

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
**/
#import "JMCCrashSender.h"

#define kJiraConnectAutoSubmitCrashes @"JiraConnectAutoSubmitCras"

@implementation JMCCrashSender

JMCCrashTransport *_transport;

- (id)init {
    self = [super init];
    if (self) {
        _transport = [[JMCCrashTransport alloc] init];
        _transport.delegate = [[[JMCCreateIssueDelegate alloc] init] autorelease];
    }
    return self;
}

- (void)dealloc {
    [_transport release];
    [super dealloc];
}


- (void)promptThenMaybeSendCrashReports {

    if (![[CrashReporter sharedCrashReporter] hasPendingCrashReport]) {
        return;
    }

    if (![[NSUserDefaults standardUserDefaults] boolForKey:kAutomaticallySendCrashReports]) {
        NSString *description = @"This App crashed the last time it ran. \n Help us improve %@ by reporting crashes?";

        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Crash Report"
                                                            message:[NSString stringWithFormat:description, [[JMC instance] getAppName]]
                                                           delegate:self
                                                  cancelButtonTitle:JMCLocalizedString(@"No", @"No") otherButtonTitles:JMCLocalizedString(@"Yes", @"Yes"), JMCLocalizedString(@"Always", @"Always"), nil];
        [alertView show];
        [alertView release];
    } else {
        [self sendCrashReports];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [[CrashReporter sharedCrashReporter] cleanCrashReports];
            break;
        case 1:
            [self sendCrashReports];
            break;
        case 2:
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kAutomaticallySendCrashReports];
            [self sendCrashReports];
            break;
    }
}


- (void)sendCrashReports {

    if ([CrashReporter sharedCrashReporter] == nil) {
        return;
    }

    NSArray *reports = [[CrashReporter sharedCrashReporter] crashReports];
    // queue all the reports
    for (NSString *report in reports) {
        u_int toIndex = [report length] > 500 ? 500 : [report length];
        [_transport send:@"Crash report"
             description:[[report substringToIndex:toIndex] stringByAppendingString:@"...\n(truncated)"]
             crashReport:report];
    }
    // clean the reports
    [[CrashReporter sharedCrashReporter] cleanCrashReports];
    // flush the queue to ensure they get sent
    [[JMC instance] flushRequestQueue];

}


@end
