/* beta.js:
 * This is a Raphael canvas with a viewport 
 * and some basic content
 */
var betaPaper = Raphael('beta', 640, 360),
    M='M', m='m', 
    L='L', l='l', 
    H='H', h='h', 
    V='V', v='v',
    Z='Z', z='z';

betaPaper.canvas.attributes.style.value += "background: #FFF;";

betaPaper.path([ M, 0, 180, L, 640, 180 ]);

betaPaper.rect(0, 0, 144, 144);
betaPaper.rect(0, 0, 72, 72);

betaPaper.rect(0, 0, 640, 360, 72);

betaPaper.circle(480, 90, 30);

betaPaper.ellipse(480, 90, 90, 60);
betaPaper.ellipse(480, 270, 90, 60);

betaPaper.path([ 
    M, 135, 237.5,
    L, 137.9, 246.1,
    L, 146.9, 246.1,
    L, 139.7, 251.5,
    L, 142.3, 260.1,
    L, 135, 255,
    L, 127.7, 260.1,
    L, 130.3, 251.5,
    L, 123.1, 246.1,
    L, 132.1, 246.1,
    Z
])
    .attr({ fill: "red"  });
