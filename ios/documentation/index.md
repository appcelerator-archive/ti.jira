# Ti.JIRA Module

## Description

This module can be embedded into any Titanium app to provide the following extra functionality:

* **Real Time Crash Reporting** have users or testers submit crash reports directly to your JIRA instance
* **User or Tester Feedback** views for allowing users or testers to create a bug report within your app.
* **Rich Data Input** users can attach and annotate screenshots, leave a voice message, have their location sent
* **2-way Communication with Users** thank your users or testers for providing feedback on your App!

## Installation
Before you can use this module with your JIRA instance, you must install the [JIRA Mobile Connect Plugin][].

## Getting Started

View the [Using Titanium Modules](http://docs.appcelerator.com/titanium/latest/#!/guide/Using_Titanium_Modules) document for instructions on getting
started with using this module in your application.

## Accessing the Ti.JIRA Module
To access this module from JavaScript, you would do the following:

	var JIRA = require('ti.jira');

## Methods

### void initialize(dictionary args)
Gets the module ready to interact with your JIRA instance.

Takes a dictionary with the following keys:

* string url [required]: The URL to your JIRA instance. It is highly recommended you use "https" (not "http") to ensure a secure communication between your users and JIRA.
* string projectKey [required]: The name of the project in to which you would like to collect user feedback.
* string apiKey [required]: The API Key taken from your JIRA settings.
* bool allowCrashReporting [defaults to true]: Whether or not users will be asked to submit their crash reports.
* dictionary customFields [optional]: Additional fields to set with issues; these map to fields in your JIRA instance.

### void ping()
Pings your server, if it is reachable, for updates. The local database of issues and comments will be updated as a 
result. You can use the events on this module to detect when new data is being received.

### void submitIssue(dictionary args)
Submits a new issue.

Takes a dictionary with the following keys:

* string description: A description of the issue your user is having.
* object[] attachments: An array of objects to attach to the issue. These can be any mixture of blobs, local URLs, or TiFiles.

### void commentOnIssue(dictionary args)
Adds a comment to an existing issue.

Takes a dictionary with the following keys:

* string key: The issue key to which the comment should be added.
* string description: A new comment.
* object[] attachments: An array of objects to attach to the issue. These can be any mixture of blobs, local URLs, or TiFiles.

### [Ti.Box.Issue][][] retrieveIssues()
Retrieves all of the issues that the current device has reported.

## Events

### issueStarted
Fired when we start sending a new issue to the server.

### issueFinished
Fired when we receive an updated issue from the server, or finish sending a new issue to the server.

### issueErrored
Fired when an error occurs during issue related communication with the server.

### replyStarted
Fired when we start sending a new comment to the server.

### replyFinished
Fired when we receive an updated comment from the server, or finish sending a new comment to the server.

### replyErrored
Fired when an error occurs during comment related communication with the server.

### receivedComments
Fired when new comments are received from the server. Look for the "newUpdates" property on each issue to see which have
been updated.

## Usage
See example.

## Author
Dawson Toth

## Module History

View the [change log](changelog.html) for this module.

## Feedback and Support
Please direct all questions, feedback, and concerns to [info@appcelerator.com](mailto:info@appcelerator.com?subject=iOS%20JIRA%20Module).

## License
Copyright(c) 2011-2013 by Appcelerator, Inc. All Rights Reserved. Please see the LICENSE file included in the distribution for further details.


[Ti.Box.Issue]: issue.html
[JIRA Mobile Connect Plugin]: https://plugins.atlassian.com/plugin/details/322837