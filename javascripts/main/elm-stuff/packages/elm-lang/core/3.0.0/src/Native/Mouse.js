Elm.Native=Elm.Native||{},Elm.Native.Mouse={},Elm.Native.Mouse.make=function(e){if(e.Native=e.Native||{},e.Native.Mouse=e.Native.Mouse||{},e.Native.Mouse.values)return e.Native.Mouse.values;var i=Elm.Native.Signal.make(e),t=Elm.Native.Utils.make(e),n=i.input("Mouse.position",t.Tuple2(0,0)),o=i.input("Mouse.isDown",!1),u=i.input("Mouse.clicks",t.Tuple0),s=e.isFullscreen()?document:e.node;return e.addListener([u.id],s,"click",function(){e.notify(u.id,t.Tuple0)}),e.addListener([o.id],s,"mousedown",function(){e.notify(o.id,!0)}),e.addListener([o.id],s,"mouseup",function(){e.notify(o.id,!1)}),e.addListener([n.id],s,"mousemove",function(i){e.notify(n.id,t.getXY(i))}),e.Native.Mouse.values={position:n,isDown:o,clicks:u}};