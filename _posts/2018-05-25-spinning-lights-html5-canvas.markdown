---
layout: post
title:  "Spinning lights with canvas and HTML5"
date:   2018-05-25 10:00:00 -0800
categories: HTML5 canvas
---

## Spinning lights. Full example [here](/examples/spinning_lights)

<canvas id="myCanvas" width="500" height="500"></canvas>
<script>
  function rotateLine(x1, y1, x2, y2, angle) {
    var x3 = Math.cos(angle) * (x2 - x1) - Math.sin(angle) * (y2 - y1) + x1;
    var y3 = Math.sin(angle) * (x2 - x1) + Math.cos(angle) * (y2 - y1) + y1;
    return [x3, y3];
  }

  var canvas = document.getElementById('myCanvas');
  var ctx = canvas.getContext('2d');
  var centerX = canvas.width / 2;
  var centerY = canvas.height / 2;

  function drawCircle() {
    var radius = 50;
    // Draw "Lighthouse"
    ctx.strokeStyle = "#000000"
    ctx.globalAlpha = 1;
    ctx.beginPath();
    ctx.arc(centerX, centerY, radius, 0, 2 * Math.PI, false);
    ctx.fillStyle = '#d3d3d3';
    ctx.fill();
    ctx.lineWidth = 5;
    ctx.stroke();
  }

  function drawLine(startX, startY, radians) {
    ctx.strokeStyle = "#FF4500";
    ctx.lineWidth = 1;
    ctx.fillStyle = "#ffff00";
    ctx.beginPath();
    ctx.globalAlpha = 0.6;
    ctx.moveTo(centerX, centerY);

    var line1 = rotateLine(centerX, centerY, startX, startY, radians);
    var line2 = rotateLine(centerX, centerY, canvas.width - startX, startY, radians);

    // Draw 2 lines for the light beam
    ctx.lineTo(line1[0], line1[1]);
    ctx.lineTo(line2[0], line2[1]);
    ctx.lineTo(centerX, centerY);
    ctx.fill();
    ctx.stroke();
  }

  var degrees = 0;
  setInterval(function() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    degrees += 1;
    var radians = (degrees % 360) * Math.PI / 180
    drawLine(200, 25, radians);
    drawCircle();
  }, 50)
</script>

{% highlight html %}
<!DOCTYPE HTML>
<html>
  <head>
    <style>
      body {
        margin: 0px;
        padding: 0px;
      }
    </style>
  </head>
  <body>
    <canvas id="myCanvas" width="500" height="500"></canvas>
    <script>
      function rotateLine(x1, y1, x2, y2, angle) {
        var x3 = Math.cos(angle) * (x2 - x1) - Math.sin(angle) * (y2 - y1) + x1;
        var y3 = Math.sin(angle) * (x2 - x1) + Math.cos(angle) * (y2 - y1) + y1;
        return [x3, y3];
      }

      var canvas = document.getElementById('myCanvas');
      var ctx = canvas.getContext('2d');
      var centerX = canvas.width / 2;
      var centerY = canvas.height / 2;

      function drawCircle() {
        var radius = 50;
        // Draw "Lighthouse"
        ctx.strokeStyle = "#000000"
        ctx.globalAlpha = 1;
        ctx.beginPath();
        ctx.arc(centerX, centerY, radius, 0, 2 * Math.PI, false);
        ctx.fillStyle = '#d3d3d3';
        ctx.fill();
        ctx.lineWidth = 5;
        ctx.stroke();
      }

      function drawLine(startX, startY, radians) {
        ctx.strokeStyle = "#FF4500";
        ctx.lineWidth = 1;
        ctx.fillStyle = "#ffff00";
        ctx.beginPath();
        ctx.globalAlpha = 0.6;
        ctx.moveTo(centerX, centerY);

        var line1 = rotateLine(centerX, centerY, startX, startY, radians);
        var line2 = rotateLine(centerX, centerY, canvas.width - startX, startY, radians);

        // Draw 2 lines for the light beam
        ctx.lineTo(line1[0], line1[1]);
        ctx.lineTo(line2[0], line2[1]);
        ctx.lineTo(centerX, centerY);
        ctx.fill();
        ctx.stroke();
      }

      var degrees = 0;
      setInterval(function() {
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        degrees += 1;
        var radians = (degrees % 360) * Math.PI / 180
        drawLine(200, 25, radians);
        drawCircle();
      }, 50)

    </script>
  </body>
</html>
{% endhighlight %}
