// JavaScript Document

var ref = new Firebase("https://mydogspot.firebaseio.com/posts")

ref.on("value", function(snapshot) {
  console.log(snapshot.val());
}, function (errorObject) {
  console.log("The read failed: " + errorObject.code);
});

