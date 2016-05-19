function drawVisualization() {
   //get the rate from the html page
   var select = document.getElementById("rate");
   var rate = select.options[select.selectedIndex].value;

   //use jquerry to get data
   $.get("data/nyc_crime_rate.csv", function(csvString) {
      // change the file to 2d array
      var arrayData = $.csv.toArrays(csvString, 
         {onParseValue: $.csv.hooks.castToScalar});

      //use the google datatable
      var data = new google.visualization.arrayToDataTable(arrayData);
      var formatter = new google.visualization.NumberFormat(
         {groupingSymbol: '', fractionDigits: 0});
      formatter.format(data, 0);

      //filter the view for which crime to showcase
      var v_view = new google.visualization.DataView(data);
      var rows = v_view.getFilteredRows([{column: 6, value: rate}]);
      v_view.setColumns([0,1,2,3,4,5]);
      v_view.setRows(rows);

      //create the chart
      var crime_rates = new google.visualization.ChartWrapper({
         chartType: 'LineChart',
         containerId: 'chart',
         dataTable: v_view,
         options:{
            width: 640, height: 480,
            title: 'NYC Violent Crime Rates 1970-2014:\n' + rate,
            titleTextStyle : {color: 'red', fontSize: 16},
            vAxis: {title: "Incidents per 100,000 People"},
            hAxis: {title: "Year", format: "0000"},
         },

      });
      crime_rates.draw();
   });
}
google.setOnLoadCallback(drawVisualization)