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

In the iOS app change the SERVER_HOST #define if you want to use something other than localhost. You'll need to do this if you intend to run on a iOS device.