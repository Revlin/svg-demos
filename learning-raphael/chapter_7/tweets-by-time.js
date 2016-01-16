/**
 * Our drawing canvas
 */
var paper = Raphael('tweets-timed', 770, 450);

/**
 * Our timers and their positions, time intervals and total num tweets
 *
 * @type {Array}
 */
var timers = [
    {
        cx: 225,
        cy: 100,
        r: 50,
        interval: 1000,
        total: 3000,
        text: '~ 3,000 tweets per second'
    },
    {
        cx: 475,
        cy: 100,
        r: 50,
        interval: 3333,
        total: 10000,
        text: '~ 10,000 tweets per 3.33 seconds'
    },
    {
        cx: 225,
        cy: 300,
        r: 50,
        interval: 30000,
        total: 100000,
        text: '~ 100,000 tweets per 30 seconds'
    },
    {
        cx: 475,
        cy: 300,
        r: 50,
        interval: 300000,
        total: 1000000,
        text: '~ 1,000,000 tweets per 5 minutes'
    }
];

/**
 * How much our arc should be subtended
 *
 * @param angle
 * @param cx
 * @param cy
 * @param r
 * @return {Object}
 */
paper.customAttributes.subtend = function(angle, cx, cy, r) {
    var x = cx + r * Math.cos(Raphael.rad(90 - angle));
    var y = cy - r * Math.sin(Raphael.rad(90 - angle));
    var path = [
        'M', cx, cy - r,
        'A', r, r, 0, +(angle > 180), 1, x, y
    ];
    return {
        path: path
    };
};

/**
 * Number of tweets based on time elapsed during animation
 *
 * @param proportion
 * @param total
 * @return {Object}
 */
paper.customAttributes.counts = function(proportion, total) {
    return {
        text: Math.round(proportion * total)
    }
};

var paths = Array(),
    counts = Array();

/**
 * Iterate over our data and initialize animation
 */
for(var i = 0, ii = timers.length; i < ii; i+=1) {
    (function(i) {
        paper.text(timers[i].cx, timers[i].cy + timers[i].r + 30, timers[i].text);
        counts[i] = paper.text(timers[i].cx, timers[i].cy, '0').attr({
            'counts': [0, timers[i].total]
        });

        update(i);
    })(i);
}

/**
 * Initialise a new timer
 *
 * @param i    The index of the timer
 */
function update(i) {
    var cx = timers[i].cx, cy = timers[i].cy, radius = timers[i].r,
        interval = timers[i].interval;

    // Draw a new path for this particular timer
    paths[i] = paper.path().attr({
        subtend: [0, cx, cy, radius],
        'stroke-width': 20,
        stroke: '#009ec4'
    });
    animate(i, cx, cy, radius, timers[i].interval);
}

/**
 * Animate the path and the counts
 *
 * @param i
 * @param cx
 * @param cy
 * @param r
 * @param interval
 */
function animate(i, cx, cy, r, interval) {
    // Animate the path
    paths[i].animate({
        subtend: [360, cx, cy, r]
    }, interval, function() {
        paths[i].remove();
        setTimeout(function() {
            update(i);
        });
    });

    // Animate the counts
    counts[i].animate({
        counts: [1, timers[i].total]
    }, interval, function() {
        counts[i].attr({
            'counts': [0, timers[i].total]
        });
    });
}