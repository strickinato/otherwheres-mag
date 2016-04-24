var handler = StripeCheckout.configure({
  key: 'pk_test_CDafpjNwda98sK1dXBiBDu0W',
  locale: 'auto',
  token: function(token) {
   
  }
});

var mount = document.getElementById("elm-main-mount")
var mountedApp = Elm.embed(Elm.Main, mount)

mountedApp.ports.requestOpenStripe.subscribe(function(){
  handler.open({
    name: 'Stripe.com',
    description: '2 widgets',
    amount: 2000
  });
  e.preventDefault();
});
