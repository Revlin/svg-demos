/**
 * Social network users as a proportion of the world's population
 * @type {String}
 */

/**
 * Usage data, each key name will match the class name on a clickable attribute
 */
var usage = {
    facebook: 1000000000,
    twitter: 500000000,
    flickr: 50000000,
    linkedin: 150000000,
    myspace: 50000000,
    googleplus: 400000000,
    orkut: 100000000,
    lastfm: 50000000
};

/**
 * Our drawing canvas
 */
var paper = Raphael('world-population-usage', 770, 220);

/**
 * Icon path taken from http://raphaeljs.com/icons/
 */
var personPath = "M20.771,12.364c0,0,0.849-3.51,0-4.699c-0.85-1.189-1.189-1.981-3.058-2.548s-1.188-0.454-2.547-0.396c-1.359,0.057-2.492,0.792-2.492,1.188c0,0-0.849,0.057-1.188,0.397c-0.34,0.34-0.906,1.924-0.906,2.321s0.283,3.058,0.566,3.624l-0.337,0.113c-0.283,3.283,1.132,3.68,1.132,3.68c0.509,3.058,1.019,1.756,1.019,2.548s-0.51,0.51-0.51,0.51s-0.452,1.245-1.584,1.698c-1.132,0.452-7.416,2.886-7.927,3.396c-0.511,0.511-0.453,2.888-0.453,2.888h26.947c0,0,0.059-2.377-0.452-2.888c-0.512-0.511-6.796-2.944-7.928-3.396c-1.132-0.453-1.584-1.698-1.584-1.698s-0.51,0.282-0.51-0.51s0.51,0.51,1.02-2.548c0,0,1.414-0.397,1.132-3.68H20.771z"

/**
 * Draw people based on 6 rows of 20
 * 1 person = 50 million people
 * Total world population of 6 billion
 */
var people = paper.set();
for(var j = 0; j < 6; j+=1) {
    for(var i = 0; i < 20; i+=1) {
        var path = paper.path(personPath).attr({
            fill: '#666',
            'stroke-width': 0,
            opacity: 0.3
        });
        var bBox = path.getBBox(); // width/height of icon bounding box
        var xTranslation = (bBox.width + 4) * i;
        var yTranslation = (bBox.height + 4) * j;
        path.transform(['T', xTranslation, yTranslation]);
        people.push(path);
    }
}

/**
 * When a social media icon is clicked, animate the drawn people
 */
$('.networks img').click(function() {
    people.stop().attr({opacity: 0.3}); // Reset animation each time

    var className = $(this).attr('class'); // DOM element corresponding to usage data
    var numPeople = Math.ceil(people.length * (usage[className] / 6000000000));
    people.forEach(function(o) {
        if(o.id < numPeople) {
            o.animate({opacity: 1}, 500);
            return true;
        }
        return false;
    });
});

/**
 * Draw a key, a person icon and associated text
 */
var keyPerson = paper.path(personPath).attr({
    fill: '#666',
    'stroke-width': 0
});
var bBox = keyPerson.getBBox();
keyPerson.transform(['T', 0, bBox.height * 8]);
paper.text(bBox.width + 10, (bBox.height * 8) + 18, '= 50 million people').attr({
    'text-anchor': 'start',
    'font-size': 12
});
