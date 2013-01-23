/**
 * This module gives you three ways to interact with JIRA;
 *     1) Automated crash reporting. Simply set "allowCrashReporting" to true when you initialize the module.
 *     2) Create new issues, and add comments to existing ones.
 *     3) Get a list of issues this device has created. New comments can be shown on device.
 * I'll show you how.
 *
 * But first, to use this module with your own JIRA, you must:
 *     1) Install the JIRA Mobile Connect Plugin: https://plugins.atlassian.com/plugin/details/322837
 *     2) Replace the url, projectKey, and apiKey below with your own.
 */

// First, initialize the module.
var JIRA = require('ti.jira');
JIRA.initialize({
    url: 'https://connect.onjira.com/',
    projectKey: '<<YOUR PROJECT KEY HERE>>',
    apiKey: '<<YOUR API KEY HERE>>',
    allowCrashReporting: true, // When the app has crashed, ask the user (via an alert) to submit their logs.
    customFields: {} // Custom fields to include when issues are created.
});

// We'll define a pretty generic error handling function. We'll use this in a couple places.
function handleError(evt) {
    alert(evt);
}

// Second, we need to define our windows. We'll have three, each housed in their own "createYYY" function:
//    1) IssueList -- Shows a list of issues this device has created.
//    2) IssueCreation -- Lets the user create an issue.
//    3) IssueDetails -- Lets the user view an existing issue and add comments.

Ti.include(
    'issueList.js',
    'issueCreation.js',
    'issueDetails.js'
);

// Every 5 minutes, ping JIRA for updates.
setInterval(function () {
    // Ping checks the server for updates.
    // It automatically fires whenever the app is brought to the foreground.
    JIRA.ping();
}, 5 * 60 * 1000);

// Hold a reference variable for the "issueList" window. We'll use this to remember if the issue list is open or not.
var issueList;

// Listen for the "receivedComments" event. This happens after a ping, when the server notifies us of new data.
// Note that the module interacts with the server for us, and saves the comments locally. All we need to do is
// show the issue list to the user.
JIRA.addEventListener('receivedComments', function () {
    // Are we already showing the issue list to the user?
    if (issueList) {
        // Then refresh it!
        issueList.refresh();
        return;
    }
    // Otherwise, ask the user if they want to be brought to the issue list.
    var dialog = Ti.UI.createAlertDialog({
        title: 'Feedback Comments',
        message: 'Your feedback has new comments!',
        buttonNames: ['Open', 'Dismiss'],
        cancel: 1
    });
    dialog.addEventListener('click', function (evt) {
        if (evt.index == 0) {
            issueList = createIssueList();
            issueList.open();
        }
    });
    dialog.show();
});

// Now I want you to pretend that the following is a full, awesome app. We'll present the user the option to open up
// the list of issues.
var win = Ti.UI.createWindow({
    backgroundColor: '#fff'
});
var openIssueList = Ti.UI.createButton({
    title: 'Open Issue List',
    right: 0, top: 0, left: 0,
    height: 40,
    color: '#fff', backgroundColor: '#000',
    style: 0
});
openIssueList.addEventListener('click', function () {
    issueList = createIssueList();
    issueList.addEventListener('close', function () {
        issueList = null;
    });
    issueList.open();
});
win.add(openIssueList);
var crashTheApp = Ti.UI.createButton({
    title: 'Crash the App',
    right: 0, bottom: 0, left: 0,
    height: 40,
    color: '#fff', backgroundColor: '#000',
    style: 0
});
crashTheApp.addEventListener('click', function () {
    // Now let's cause a crash! This will demonstrate the automatic crash logging features.
    require('unnecessaryCrashModule').simulateCrash();
});
win.add(crashTheApp);
win.open();