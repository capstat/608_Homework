var w=960,h=0,
svg=d3.select("#display")
.append("svg")
.attr("width",w)
.attr("height",h);

d3.csv("/data/pres_data.csv", function(data) {
    var select = d3.select("#display")
      .append("select")
        .attr("class","select")

    select
      .on("change", function(d) {
        var selectedIndex = select.property("selectedIndex"),
                     data = option[0][selectedIndex].__data__;
        var output = document.getElementById("output");
        var h      = JSON.parse(data.Height);
        var w      = JSON.parse(data.Weight);
        output.innerHTML = ("Height = " + h + ", Weight = " + w);
      });

    var option = select.selectAll("option")
      .data(data)
      .enter()
        .append("option")
        .attr("Name", function (d) { return d.Name; })
        .text(function (d) { return d.Name; });

    var columns = ["Name", "Height", "Weight"];

    var table = d3.select("body").append("table"),
        thead = table.append("thead"),
        tbody = table.append("tbody");

    thead.append("tr")
        .selectAll("th")
        .data(columns)
        .enter()
        .append("th")
            .text(function(column) { return column; });

    var rows = tbody.selectAll("tr")
        .data(data)
        .enter()
        .append("tr");

    var cells = rows.selectAll("td")
        .data(function(row) {
            return columns.map(function(column) {
                return {column: column, value: row[column]};
            });
        })
        .enter()
        .append("td")
            .text(function(d) { return d.value; });
});

function match(p) {
  return(p)
}