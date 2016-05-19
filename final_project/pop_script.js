// the chart dimensions
var margin = {top:30, right:100, bottom:30, left:100},
    width = 800 - margin.left - margin.right,
    height = 400 - margin.top - margin.bottom;

// format percent
var formatPercent = d3.format(".0%");

// set min and max
var x = d3.scale.linear().range([0,width]);
var y = d3.scale.linear().range([height,0]);

// create each axis
var xAxis = d3.svg.axis().scale(x)
    .orient("bottom").ticks(5)
    .tickFormat(d3.format("d"));
var yAxis = d3.svg.axis().scale(y)
    .orient("left").ticks(5)
    .tickFormat(formatPercent);

// probably more elegant ways to do this but...
// create a function to get the data for each borough
var bx = d3.svg.line()
    .x(function(d) { return x(d.Year); })
    .y(function(d) { return y(d["Bronx County"]); });

var si = d3.svg.line()
    .x(function(d) { return x(d.Year); })
    .y(function(d) { return y(d["Richmond County"]); });

var mh = d3.svg.line()
    .x(function(d) { return x(d.Year); })
    .y(function(d) { return y(d["New York County"]); });

var qn = d3.svg.line()
    .x(function(d) { return x(d.Year); })
    .y(function(d) { return y(d["Queens County"]); });

var bk = d3.svg.line()
    .x(function(d) { return x(d.Year); })
    .y(function(d) { return y(d["Kings County"]); });

// select the body to insert the chart
var svg = d3.select("body")
    .append("svg")
        .attr("width", width + margin.left + margin.right)
        .attr("height", height + margin.top + margin.bottom)
    .append("g")
        .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

// open the csv and get going
d3.csv("data/nyc_pop.csv", function(error, data) {
    // return the year and population for each borough
    data.forEach(function(d) {
        d.Year = +d.Year;
        d.Pop = +d.Pop;
    });

    // set the domain and range
    x.domain(d3.extent(data, function(d) { return d.Year; }));
    y.domain([-.25, 1.25]);

    // add and customize a line for each B
    svg.append("path")
        .attr("class", "line")
        .style("stroke", "#d62728")
        .attr("d", si(data));

    svg.append("path")
        .attr("class", "line")
        .style("stroke", "#1f77b4")
        .attr("d", bx(data));

    svg.append("path")
        .attr("class", "line")
        .style("stroke", "ff7f0e")
        .attr("d", mh(data));

    svg.append("path")
        .attr("class", "line")
        .style("stroke", "#2ca02c")
        .attr("d", qn(data));

    svg.append("path")
        .attr("class", "line")
        .style("stroke", "#9467bd")
        .attr("d", bk(data));

    // add vertical line for V-bridge
    svg.append("line")
        .style("stroke", "black")
        .style("stroke-dasharray", ("1, 1"))
        .attr("x1", 40)
        .attr("y1", 115)
        .attr("x2", 40)
        .attr("y2", height);

    svg.append("text")
        .style("fill", "black")
        .attr("x", 45)
        .attr("y", 125)
        .text("1964: Verrazano Bridge Opens")

    // add vertical line for dump closing
    svg.append("line")
        .style("stroke", "black")
        .style("stroke-dasharray", ("1, 1"))
        .attr("x1", 460)
        .attr("y1", 53)
        .attr("x2", 460)
        .attr("y2", height);

    svg.append("text")
        .style("fill", "black")
        .attr("x", 465)
        .attr("y", 70)
        .text("2001: Dump Closes")

    // add on the axis
    svg.append("g")
        .attr("class", "x axis")
        .attr("transform", "translate(0," + height + ")")
        .call(xAxis);

    svg.append("g")
        .attr("class", "y axis")
        .call(yAxis);

    // add a title
    svg.append("text")
        .style("fill", "black")
        .attr("x", width / 2)
        .attr("y", 0)
        .attr("font-size", "16px")
        .attr("text-anchor", "middle")
        .text("% Change in NYC Population since 1960")

    // add a legend
    var B = ["Bronx","Brooklyn","Manhattan","Queens","Staten Island"];
    var C = ["#1f77b4","#9467bd","#ff7f0c","#2ca02c","#d62728"];

    for (i=0; i<B.length; i++) {
        svg.append("circle")
            .attr("cx", 15)
            .attr("cy", 10+i*12)
            .attr("r", 3)
            .style("fill", C[i])
        svg.append("text")
            .attr("x", 20)
            .attr("y", 14+i*12)
            .attr("class", "legend")
            .style("fill", C[i])
            .text(B[i]);
    }
});