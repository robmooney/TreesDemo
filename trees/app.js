var pg = require("pg");
var app = require("express").createServer();
var executeQuery;

app.get("/search", function (req, res) {

	var tree = req.param("tree");
	var lat = req.param("lat");
	var lon = req.param("lon");
	var latSpan = req.param("latspan");
	var lonSpan = req.param("lonspan");
	
	if (tree && lat && lon) {
	
		lat = parseFloat(lat);
		lon = parseFloat(lon);
		latSpan = parseFloat(latSpan);
		lonSpan = parseFloat(lonSpan);
		
		executeQuery(tree, lat, lon, latSpan, lonSpan, function (results, error) {
			if (results) {
				res.send({results:results}, 200);
			} else {			
				res.send({error:error}, 500);
			}
		});
			
	} else {	
		res.send("", 400);
	}
});

app.get("*", function (req, res) {
	res.send("", 404);
});

app.listen(process.env.PORT || 3000);














// query implementation

executeQuery = function (tree, latitude, longitude, latSpan, lonSpan, callback) {
	pg.connect(process.env.DATABASE_URL || "postgres://localhost:5432/Trees", function (err, client) {	
	
		var query = client.query("SELECT commonname, species, sitename, latitude, longitude FROM trees WHERE (latitude BETWEEN $1 AND $2) AND (longitude BETWEEN $3 AND $4) AND (commonname LIKE $5)", 
			[latitude - (latSpan / 2), latitude + (latSpan / 2), longitude - (lonSpan / 2), longitude + (lonSpan / 2), "%" +tree]);
			
		var rows = [];
		query.on("row", function (row) {
			rows.push(row);
		});
		query.on("end", function () {  	
			callback(rows, null);	
		});
		query.on("error", function (error) {	
			callback(null, error);	
		});
	});	
};



