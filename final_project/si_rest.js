//creates new chart based upon the borough that it is passed
function updateData(Bs){
   //remove previous chart
   d3.select("svg").remove();
   // the chart dimensions
   var margin = {top:30, right:100, bottom:100, left:100},
      width = 800 - margin.left - margin.right,
      height = 500 - margin.top - margin.bottom;

   // format percent
   var formatPercent = d3.format(".0%");

   // set the axis scales
   var x = d3.scale.ordinal().rangeRoundBands([0, width], .05);
   var y = d3.scale.linear().range([height, 0]);

   // create each axis
   var xAxis = d3.svg.axis().scale(x)
      .orient("bottom");
   var yAxis = d3.svg.axis().scale(y)
      .orient("left").ticks(3)
      .tickFormat(formatPercent);

   //attach the svg to our div - chart
   var svg = d3.select("#chart")
      .append("svg")
         .attr("width", width + margin.left + margin.right)
         .attr("height", height + margin.top + margin.bottom)
      .append("g")
         .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

   // open the csv and get going
   d3.csv("data/rest_group_wout_american.csv", function(error, csv) {
      //save the csv
      data = csv;
      //filter the data
      datafilter();
      //create the chart
      datadraw();
   });

   //takes the data, returns row based upon boro and proportion
   function datafilter(d){
      data = data.filter(function (d) {
         return d.BORO == Bs && d.Prop >= 0.05; });
      return data;}

   //creates a chart from the filtered data
   function datadraw(d){
      // set the domain and range
      x.domain(data.map(function(d) { return d["CUISINE DESCRIPTION"]; }));
      y.domain([0, .29]);

      //add the axis
      svg.append("g")
         .attr("class", "x axis")
         .attr("transform", "translate(0," + height + ")")
         .call(xAxis)
      .selectAll("text")
         .style("text-anchor", "end")
         .attr("dx", "-.8em")
         .attr("dy", "-.55em")
         .attr("transform", "rotate(-90)" );

      svg.append("g")
         .attr("class", "y axis")
         .call(yAxis)
      .append("text")
         .attr("transform", "rotate(-90)")
         .attr("y", 6)
         .attr("dy", ".71em")
         .style("text-anchor", "end");

      //add a title
      svg.append("text")
        .style("fill", "black")
        .attr("x", width / 2)
        .attr("y", 0)
        .attr("font-size", "16px")
        .attr("text-anchor", "middle")
        .text("Most Popular Non-American Cuisines - " + Bs)

      //add the bars to the chart
      svg.selectAll("bar").data(data)
         .enter().append("rect")
         .style("fill", "steelblue")
         .attr("x", function(d) { return x(d["CUISINE DESCRIPTION"]); })
         .attr("width", x.rangeBand())
         .attr("y", function(d) { return y(d.Prop); })
         .attr("height", function(d) { return height - y(d.Prop); });
}}

//keep a counter
var count = 0;
//start chart with SI
updateData("STATEN ISLAND");
//iterate through each boro
var inter = setInterval(function(){
   var Bs = ["STATEN ISLAND","BRONX","BROOKLYN","MANHATTAN","QUEENS"];
   count++;
   updateData(Bs[count%5]);
}, 4000);