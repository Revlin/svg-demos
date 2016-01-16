/**
 * Our canvas
 */
var paper = Raphael('facebook-usage', 770, 450);

/**
 * Data usage
 */
var data = [
    {
        year: '2004',
        users: 1000000,
        text: 'Facebook was born in 2004 and by the end of the year\nhad 1,000,000 users'
    },
    {
        year: '2005',
        users: 5500000,
        text: 'By the end of 2005 Facebook had 5,500,000 users'
    },
    {
        year: '2006',
        users: 12000000,
        text: 'Facebook passed the 10,000,000 registered users\nmark in 2006'
    },
    {
        year: '2007',
        users: 50000000,
        text: 'By the end of 2007, there were 50,000,000\nregistered users on Facebook'
    },
    {
        year: '2008',
        users: 150000000,
        text: 'Facebook passed the 100,000,000 users mark in 2008\nwith 150,000,000 registered users by year end'
    },
    {
        year: '2009',
        users: 350000000,
        text: 'By the end of 2009, Facebook could boast having\n350,000,000 registered users'
    },
    {
        year: '2010',
        users: 608000000,
        text: 'By the end of 2010, Facebook had over 600,000,000\nregistered users'
    },
    {
        year: '2011',
        users: 845000000,
        text: 'By the end of 2011, Facebook had approached the\n1 billion users mark with 845,000,000 registered users'
    },
    {
        year: '2012',
        users: 1000000000,
        text: 'Facebook surpassed the 1 billion registered users mark in 2012\nholding an IPO in May 2012'
    }
];

var gutter_bottom = 100,
    point_radius = 5,
    gutter_top = 100,
    text_from_point = 50,
    gutter_left = 40,
    min_y_point = 1000000,
    max_y_point = 1100000000,
    num_data_points = data.length;

/**
 * Get the real y values based on a y=0 at the bottom co-ordinate system
 *
 * @param point
 * @return {Number}
 */
function getY(point) {
    var usable_height = paper.height - gutter_top - gutter_bottom;
    var y = usable_height
        * (point - min_y_point) / (max_y_point - min_y_point);
    var y = usable_height - y;
    return gutter_top + y;
}

function getX(index) {
    if(num_data_points <= 1) {
        return 0;
    }
    var spacing = getXSpacing(index);
    return gutter_left + (spacing * index);
}

function getXSpacing(index) {
    return 350;
}

/**
 * Draw our data points and build our graph
 */
var path = ['M'];
for(var i = 0; i < num_data_points; i+=1) {
    // Plot point as circle
    var x = getX(i);
    var y = getY(data[i].users);
    paper.circle(x, y, point_radius).attr({
        'stroke-width': 0,
        fill: '#3B5998'
    });

    path.push(x);
    path.push(y);
    if(i === 0) {
        path.push('R');
    }

    // Add associated text to the anchor point
    var txt = paper.text(x, paper.height - gutter_bottom + 20, data[i].year).attr({
        'font-size': 11
    });
    var description = paper.text(x, y - text_from_point, data[i].text).attr({
        'font-size': 11,
        'text-anchor': 'start'
    });
}

var curve = paper.path(path).attr({
    'stroke-width': 1,
    'stroke-dasharray': '- ',
    stroke: '#bbb'
});
curve.toBack();

var xOffset = 0;
$(paper.canvas).click(function(e) {
    var mouseX = e.pageX - this.offsetLeft,
        mouseY = e.pageY - this.offsetTop;

    var cx = $(this).width() / 2;

    var xSpacing = getXSpacing();

    var mouse_offset = (mouseX - cx) < 0 ? -xSpacing : xSpacing;

    if((xOffset + mouse_offset) >= 0 && (xOffset + mouse_offset) <= ((num_data_points - 1) * xSpacing)) {
        xOffset += mouse_offset;
        paper.setViewBox(xOffset, 0, paper.width, paper.height); // Set the view box
    }
});