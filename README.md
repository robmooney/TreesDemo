TreesDemo
=========

Demo iOS app which uses Node.js for its API. The trees database is from [Fingal Open Data](http://data.fingal.ie/ViewDataSets/Details/default.aspx?datasetID=427). I slightly modified it by removing some bogus data. 

This code was created for a demo so it assumes everything is running on one machine - Node.js, PostgreSQL, the iOS app in the iPhone simulator, etc.

Installation
------------

You can install node from the [nodejs website](http://nodejs.org/#download) or use [homebrew](http://mxcl.github.com/homebrew/):

	brew install node

The node app uses a PostgreSQL database. Mac OS X has PostgreSQL built in, but I had trouble with that so I used [homebrew](http://mxcl.github.com/homebrew/) to install the latest version:

	brew install postgresql

To set up the db:

	createdb Trees
	psql Trees < Trees.sql

You should now be able to run the app:

	node trees.js

The iOS app is set up to look for the server at localhost. To run on a device you will need to change this to the actual address of your server. Edit #define SERVER_HOST in RMListViewController.m and RMSearchViewController.m to do this.