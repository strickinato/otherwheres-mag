var mount = document.getElementById("katie-story-mount");

var mountedApp = Elm.embed(Elm.Main, mount, { sendStoryHeight: 0 });

getStoryHeight = function() {
  var story = document.getElementById("katie-story-story-section");
  if (typeof story !== "undefined" && story !== null) {
    mountedApp.ports.sendStoryHeight.send(story.scrollHeight);
  }
};

mountedApp.ports.requestStoryHeight.subscribe(getStoryHeight);
