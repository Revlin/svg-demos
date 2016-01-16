$('#start').click(function() {
    $(this).remove(); // Remove this start link

    /**
     * Draw our canvas
     */
    var paper = Raphael('golden-tweets', 770, 200);

    /**
     * User and number of retweets
     */
    var data = [
        {
            name: 'Barack Obama',
            username: '@BarackObama',
            rt: 810000
        },
        {
            name: 'Justin Bieber',
            username: '@justinbieber',
            rt: 220000
        },
        {
            name: 'TJ Lang',
            username: '@TJLang70',
            rt: 98000
        },
        {
            name: 'Kouichi Yamadera',
            username: '@yamachanoha',
            rt: 68000
        },
        {
            name: 'Team GB',
            username: '@TeamGB',
            rt: 67000
        }
    ];
    var maxValue = 810000;
    paper.customAttributes.barColor = function(val) {
        var saturation = val / maxValue;
        return {
            fill: 'hsb(0.55,' + saturation + ',0.77)'
        };
    };

    var barHeight = 40;
    var barMaxWidth = 600;
    var labels = Array();
    for(var i = 0, ii = data.length; i < ii; i+=1) {
        (function(i) {
            var o = data[i];

            /**
             * Draw our bar with 0 width to begin with
             */
            var bar = paper.rect(0, i * barHeight, 0, barHeight);
            bar.attr({
                'stroke-width': 0,
                barColor: o.rt
            });

            /**
             * Animate our bar to its full width
             */
            var barWidth = barMaxWidth * (o.rt / maxValue);
            bar.animate({width: barWidth}, 500, function() {
                /**
                 * Once the bar has been created, define hover event handler for displaying text
                 */
                bar.hover(function() {
                    var barText = paper.text(
                        bar.attr('width') + 12,
                        ((i + 1) * barHeight) - (barHeight / 2),
                        o.username + ' (' + o.rt + ')'
                    );
                    barText.attr('text-anchor', 'start');
                    labels[i] = barText; // Store reference in labels array
                }, function() {
                    labels[i].remove(); // remove the label from our canvas
                });
            });

        })(i);
    }
});
