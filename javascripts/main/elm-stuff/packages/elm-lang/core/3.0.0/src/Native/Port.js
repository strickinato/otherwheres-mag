Elm.Native.Port={},Elm.Native.Port.make=function(n){function t(t,r,o){if(!n.argsTracker[t])throw new Error("Port Error:\nNo argument was given for the port named '"+t+"' with type:\n\n    "+r.split("\n").join("\n        ")+"\n\nYou need to provide an initial value!\n\nFind out more about ports here <http://elm-lang.org/learn/Ports.elm>");var i=n.argsTracker[t];return i.used=!0,e(t,r,o,i.value)}function r(r,o,i){function u(t){var a=e(r,o,i,t);setTimeout(function(){n.notify(v.id,a)},0)}var s=t(r,o,i);a||(a=Elm.Native.Signal.make(n));var v=a.input("inbound-port-"+r,s);return n.ports[r]={send:u},v}function e(n,t,r,e){try{return r(e)}catch(o){throw new Error("Port Error:\nRegarding the port named '"+n+"' with type:\n\n    "+t.split("\n").join("\n        ")+"\n\nYou just sent the value:\n\n    "+JSON.stringify(e)+"\n\nbut it cannot be converted to the necessary type.\n"+o.message)}}function o(t,r,e){n.ports[t]=r(e)}function i(t,r,e){function o(n){s.push(n)}function i(n){s.pop(s.indexOf(n))}function u(n){for(var t=r(n),e=s.length,o=0;e>o;++o)s[o](t)}var s=[];return a||(a=Elm.Native.Signal.make(n)),a.output("outbound-port-"+t,u,e),n.ports[t]={subscribe:o,unsubscribe:i},e}if(n.Native=n.Native||{},n.Native.Port=n.Native.Port||{},n.Native.Port.values)return n.Native.Port.values;var a;return n.Native.Port.values={inbound:t,outbound:o,inboundSignal:r,outboundSignal:i}};