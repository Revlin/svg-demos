/* beta.js:
 * This is a Raphael canvas with a viewport 
 * and some basic content
 */
var betaPaper = Raphael('beta', 640, 360);

betaPaper.canvas.attributes.style.value += "background: #FFF;";

//<line x1="0" y1="180" x2="640" y2="180" />

//<rect x="0" y="0" width="144" height="144" />
betaPaper.rect(0, 0, 144, 144);
//<rect x="0" y="0" width="72" height="72" />
betaPaper.rect(0, 0, 72, 72);

//<rect x="0" y="0" width="640" height="360" rx="72" ry="72" />
betaPaper.rect(0, 0, 640, 360, 72);

//<circle cx="480" cy="90" r="30" />
betaPaper.circle(480, 90, 30);

//<ellipse cx="480" cy="90" rx="90" ry="60" />
betaPaper.ellipse(480, 90, 90, 60);
//<ellipse cx="480" cy="270" rx="90" ry="60" />
betaPaper.ellipse(480, 270, 90, 60);

//<polygon points=" 135, 237.5
//                137.9, 246.1
//                146.9, 246.1
//                139.7, 251.5
//                142.3, 260.1
//                135, 255
//                127.7, 260.1
//                130.3, 251.5
//                123.1, 246.1
//                132.1, 246.1" />
