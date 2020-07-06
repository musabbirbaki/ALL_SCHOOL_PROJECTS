$(document).ready(function(){
  //these are the bg images to scroll through
  var images = ["https://i.imgur.com/boqIE2V.jpg",
  'https://i.imgur.com/FGY4TGr.jpg',
  'https://i.imgur.com/5cJjYeS.jpg', 'https://images.pexels.com/photos/233312/pexels-photo-233312.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260',
    'https://i.imgur.com/iVR1xN9.jpg',  'https://i.imgur.com/9iowgNR.jpg'];

  var i = 0;
  function nextImage(){

    $('#main').attr('src',images[i]);

    i++;
    if (i>=images.length) i=0;
  }

  //every 6 seconds change image
  window.setInterval(nextImage, 6000);
});
