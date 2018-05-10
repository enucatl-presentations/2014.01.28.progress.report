function visibility_plot(placeholder, json, title) {
    var margin = {top: 20, right: 40, bottom: 40, left: 50};
    var dim = 550;
    var w = dim - margin.left - margin.right;
    var h = 0.618 * dim - margin.top - margin.bottom;
    d3.json(json, function(error, json) {
            if (error) return console.warn(error);
            visualize_data(json);
            });
    
    function visualize_data(data) {
        var average_visibility = d3.mean(data, function(d) {return d.visibility;});
        var chart = d3.select(placeholder).append("svg")
            .attr("class", "chart")
            .attr("width", w + margin.left + margin.right)
            .attr("height", h + margin.left + margin.right)
            .append("g")
                .attr("transform", "translate(" + margin.left + "," + margin.top + ")")
        var x = d3.scale.linear()
            .domain(d3.extent(data, function(d) {return d.pixel;}))
            .nice()
            .range ([0, w]);
        var y = d3.scale.linear()
            .domain([0, 0.14])
            .range ([h, 0]);
        var line = d3.svg.line()
            .x(function(d) {return x(d.pixel);})
            .y(function(d) {return y(d.visibility);});
        var average_visibility = d3.svg.line()
            .x(function(d) {return x(d.pixel);})
            .y(y(average_visibility));
        var x_axis = d3.svg.axis()
            .scale(x);
        var y_axis = d3.svg.axis()
            .orient("left")
            .tickFormat(d3.format(".0%"))
            .scale(y);
        chart.append("g")
            .attr("class", "axis")
            .attr("transform", "translate(0, " + h + ")")
            .call(x_axis)
            .append("text")
                .attr("x", "0")
                .attr("dy", margin.bottom)
                .attr("dx", w)
                .attr("text-anchor", "end")
                .text("pixel");
        chart.append("g")
            .attr("class", "axis")
            .call(y_axis)
            .append("text")
                .attr("transform", "rotate(-90)")
                .attr("text-anchor", "end")
                .attr("y", margin.right)
                .attr("dy", 0)
                .text("visibility");
        chart.append("path")
            .datum(data)
            .attr("class", "line")
            .attr("d", line);
        //draw average visibility line
        chart.append("path")
            .datum(data)
            .attr("class", "line average")
            .attr("d", average_visibility);

        //draw title
        chart.append("svg:text")
            .attr("x", dim / 6)
            .attr("y", margin.top)
            .text(title);
    }
}
