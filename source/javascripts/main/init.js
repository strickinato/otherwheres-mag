var mount = document.getElementById("elm-main-mount")
var mountedApp = Elm.Main.embed(mount)

var pswpElement = document.querySelectorAll('.pswp')[0];

// build items array
var items = [
    {
        src: '/assets/featured/brunch1.jpg',
        w: 1224,
        h: 792
    },
    {
        src: '/assets/featured/brunch2.jpg',
        w: 1224,
        h: 792
    },
    {
        src: '/assets/featured/brunch3.jpg',
        w: 1224,
        h: 792
    },
    {
        src: '/assets/featured/brunch4.jpg',
        w: 1224,
        h: 792
    }
];

// define options (if needed)
var options = {
    index: 0,
    history: false,
    closeEl: true,
    captionEl: false,
    fullscreenEl: false,
    zoomEl: false,
    shareEl: false,
    counterEl: false,
    arrowEl: false,
    preloaderEl: false,
};

// Initializes and opens PhotoSwipe

mountedApp.ports.openGallery.subscribe(function() {
    let gallery = new PhotoSwipe( pswpElement, PhotoSwipeUI_Default, items, options);
    gallery.init();

    gallery.listen('close', function() {
        window.location = "#";
    });
});

mountedApp.ports.closeGallery.subscribe(function() {
    document.querySelector(".pswp").classList.remove("pswp--open");
});
