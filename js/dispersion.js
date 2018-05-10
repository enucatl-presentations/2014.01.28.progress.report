function dispersion_plot(placeholder, json, title) {
    var margin = {top: 20, right: 100, bottom: 40, left: 100};
    var dim = 720;
    var w = dim - margin.left - margin.right;
    var h = 0.618 * dim - margin.top - margin.bottom;
    d3.json(json, function(error, json) {
            if (error) return console.warn(error);
            visualize_data(json);
            });
    
    function visualize_data(data) {
        var chart = d3.select(placeholder).append("svg")
            .attr("class", "chart")
            .attr("width", w + margin.left + margin.right)
            .attr("height", h + margin.left + margin.right)
            .append("g")
                .attr("transform", "translate(" + margin.left + "," + margin.top + ")")
        var x = d3.scale.linear()
            .domain(d3.extent(data, function(d) {return d.energy;}))
            .nice()
            .range ([0, w]);
        var y = d3.scale.log()
            .domain(d3.extent(data, function(d) {return d.angle;}))
            .range ([h, 0]);
        var line = d3.svg.line()
            .x(function(d) {return x(d.energy);})
            .y(function(d) {return y(d.angle);});
        var x_axis = d3.svg.axis()
            .scale(x);
        var y_format = d3.format(".1g");
        var y_axis = d3.svg.axis()
            .orient("left")
            .ticks(3, function(d, i) {
                return y_format(d);
            })
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
                .text("energy (keV)");
        chart.append("g")
            .attr("class", "axis")
            .call(y_axis)
            .append("text")
                .attr("transform", "rotate(-90)")
                .attr("text-anchor", "end")
                .attr("y", margin.right)
                .attr("dy", -150)
                .text("differential phase (rad)");
        chart.append("path")
            .datum(data)
            .attr("class", "line")
            .attr("id", "dispersion_plot")
            .attr("d", line);

        var marker = chart.append("g")
            .attr("class", "focus")
            .style("display", "none");
        marker.append("circle")
            .attr("r", 7);
        marker.append("text")
            .attr("x", 9)
            .attr("dy", ".35em");

        chart.on("mouseover", function() {
            marker.style("display", "inherit");
        })
            .on("mouseout", function() {
                marker.style("display", "none");
            })
            .on("mousemove", show_tooltip);
        //show tooltip with x, y
        function show_tooltip() {
            var mouse = d3.mouse(this);
            var x_value = x.invert(mouse[0]);
            var bisect = d3.bisector(function(datum) {
                return datum.energy;
            }).right;
            var index = bisect(data, x_value, 1);
            var min_datum = data[index - 1];
            var max_datum = data[index];
            d = x_value - min_datum.energy > min_datum.energy - x_value ? max_datum : min_datum;
            marker.attr("transform", "translate(" + x(d.energy) + ", " + y(d.angle) + ")");
            var angle_format = d3.format(".3f");
            marker.select("text")
                .html(d.energy + "keV, " + angle_format(d.angle) + "rad");
        }

        //draw title
        chart.append("svg:text")
            .attr("x", dim / 6)
            .attr("y", margin.top)
            .text(title);
    }
}
