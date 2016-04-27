Elm.Native=Elm.Native||{},Elm.Native.Graphics=Elm.Native.Graphics||{},Elm.Native.Graphics.Input=Elm.Native.Graphics.Input||{},Elm.Native.Graphics.Input.make=function(e){"use strict";function t(e){var t=F.createNode("select");t.style.border="0 solid",t.style.pointerEvents="auto",t.style.display="block",t.elm_values=b.toArray(e.values),t.elm_handler=e.handler;for(var n=t.elm_values,l=0;l<n.length;++l){var o=F.createNode("option"),r=n[l]._0;o.value=r,o.innerHTML=r,t.appendChild(o)}return t.addEventListener("change",function(){x.sendMessage(t.elm_handler(t.elm_values[t.selectedIndex]._1))}),t}function n(e,t,n){e.elm_values=b.toArray(n.values),e.elm_handler=n.handler;for(var l=e.elm_values,o=e.childNodes,r=o.length,a=0;r>a&&a<l.length;++a){var s=o[a],i=l[a]._0;s.value=i,s.innerHTML=i}for(;r>a;++a)e.removeChild(e.lastChild);for(;a<l.length;++a){var s=F.createNode("option"),i=l[a]._0;s.value=i,s.innerHTML=i,e.appendChild(s)}return e}function l(e,l){return A3(F.newElement,100,24,{ctor:"Custom",type:"DropDown",render:t,update:n,model:{values:l,handler:e}})}function o(e){function t(){x.sendMessage(n.elm_message)}var n=F.createNode("button");return n.style.display="block",n.style.pointerEvents="auto",n.elm_message=e.message,n.addEventListener("click",t),n.innerHTML=e.text,n}function r(e,t,n){e.elm_message=n.message;var l=n.text;return t.text!==l&&(e.innerHTML=l),e}function a(e,t){return A3(F.newElement,100,40,{ctor:"Custom",type:"Button",render:o,update:r,model:{message:e,text:t}})}function s(e){function t(e,t,n){e.style.display="block",t.style.display="none",n.style.display="none"}function n(e){s++>0||t(a.elm_hover,a.elm_down,a.elm_up)}function l(e){a.contains(e.toElement||e.relatedTarget)||(s=0,t(a.elm_up,a.elm_down,a.elm_hover))}function o(){t(a.elm_hover,a.elm_down,a.elm_up),x.sendMessage(a.elm_message)}function r(){t(a.elm_down,a.elm_hover,a.elm_up)}var a=F.createNode("div");a.style.pointerEvents="auto",a.elm_message=e.message,a.elm_up=F.render(e.up),a.elm_hover=F.render(e.hover),a.elm_down=F.render(e.down),a.elm_up.style.display="block",a.elm_hover.style.display="none",a.elm_down.style.display="none",a.appendChild(a.elm_up),a.appendChild(a.elm_hover),a.appendChild(a.elm_down);var s=0;return a.addEventListener("mouseover",n),a.addEventListener("mouseout",l),a.addEventListener("mousedown",r),a.addEventListener("mouseup",o),a}function i(e,t,n){e.elm_message=n.message;var l=e.childNodes,o=l[0].style.display,r=l[1].style.display,a=l[2].style.display;F.updateAndReplace(l[0],t.up,n.up),F.updateAndReplace(l[1],t.hover,n.hover),F.updateAndReplace(l[2],t.down,n.down);var l=e.childNodes;return l[0].style.display=o,l[1].style.display=r,l[2].style.display=a,e}function d(e,t,n){var l=e>t?e:t;return l>n?l:n}function u(e,t,n,l){return A3(F.newElement,d(t._0.props.width,n._0.props.width,l._0.props.width),d(t._0.props.height,n._0.props.height,l._0.props.height),{ctor:"Custom",type:"CustomButton",render:s,update:i,model:{message:e,up:t,hover:n,down:l}})}function c(e){function t(){x.sendMessage(n.elm_handler(n.checked))}var n=F.createNode("input");return n.type="checkbox",n.checked=e.checked,n.style.display="block",n.style.pointerEvents="auto",n.elm_handler=e.handler,n.addEventListener("change",t),n}function p(e,t,n){return e.elm_handler=n.handler,e.checked=n.checked,e}function m(e,t){return A3(F.newElement,13,13,{ctor:"Custom",type:"CheckBox",render:c,update:p,model:{handler:e,checked:t}})}function h(e,t,n,l){e.parentNode?e.setSelectionRange(t,n,l):setTimeout(function(){e.setSelectionRange(t,n,l)},0)}function v(e,t,n){e[t]!==n&&(e[t]=n)}function _(e){return e.top+"px "+e.right+"px "+e.bottom+"px "+e.left+"px"}function y(e,t){v(e,"padding",_(t.padding));var n=t.outline;v(e,"border-width",_(n.width)),v(e,"border-color",k.toCss(n.color)),v(e,"border-radius",n.radius+"px");var l=t.highlight;0===l.width?e.outline="none":(v(e,"outline-width",l.width+"px"),v(e,"outline-color",k.toCss(l.color)));var o=t.style;v(e,"color",k.toCss(o.color)),"[]"!==o.typeface.ctor&&v(e,"font-family",C.toTypefaces(o.typeface)),"Nothing"!==o.height.ctor&&v(e,"font-size",o.height._0+"px"),v(e,"font-weight",o.bold?"bold":"normal"),v(e,"font-style",o.italic?"italic":"normal"),"Nothing"!==o.line.ctor&&v(e,"text-decoration",C.toLine(o.line._0))}function f(e){function t(e){var t=n.elm_old_value,l=n.value;if(t!==l){var o="forward"===n.selectionDirection?"Forward":"Backward",r=n.selectionStart,a=n.selectionEnd;n.value=n.elm_old_value,x.sendMessage(n.elm_handler({string:l,selection:{start:r,end:a,direction:{ctor:o}}}))}}var n=F.createNode("input");return y(n.style,e.style),n.style.borderStyle="solid",n.style.pointerEvents="auto",n.type=e.type,n.placeholder=e.placeHolder,n.value=e.content.string,n.elm_handler=e.handler,n.elm_old_value=n.value,n.addEventListener("input",t),n.addEventListener("focus",function(){n.elm_hasFocus=!0}),n.addEventListener("blur",function(){n.elm_hasFocus=!1}),n}function g(e,t,n){t.style!==n.style&&y(e.style,n.style),e.elm_handler=n.handler,e.type=n.type,e.placeholder=n.placeHolder;var l=n.content.string;if(e.value=l,e.elm_old_value=l,e.elm_hasFocus){var o=n.content.selection,r="Forward"===o.direction.ctor?"forward":"backward";h(e,o.start,o.end,r)}return e}function E(e){function t(t,n,l,o){var r=t.padding,a=t.outline.width,s=r.left+r.right+a.left+a.right,i=r.top+r.bottom+a.top+a.bottom;return A3(F.newElement,200,30,{ctor:"Custom",type:e+"Field",adjustWidth:s,adjustHeight:i,render:f,update:g,model:{handler:n,placeHolder:l,content:o,style:t,type:e}})}return F4(t)}function w(e,t){function n(t){x.sendMessage(e(t))}var l=t._0,o=L.update(l.props,{hover:n});return{ctor:t.ctor,_0:{props:o,element:l.element}}}function N(e,t){function n(){x.sendMessage(e)}var l=t._0,o=L.update(l.props,{click:n});return{ctor:t.ctor,_0:{props:o,element:l.element}}}if("values"in Elm.Native.Graphics.Input)return Elm.Native.Graphics.Input.values;var k=Elm.Native.Color.make(e),b=Elm.Native.List.make(e),x=Elm.Native.Signal.make(e),C=Elm.Native.Text.make(e),L=Elm.Native.Utils.make(e),F=Elm.Native.Graphics.Element.make(e);return Elm.Native.Graphics.Input.values={button:F2(a),customButton:F4(u),checkbox:F2(m),dropDown:F2(l),field:E("text"),email:E("email"),password:E("password"),hoverable:F2(w),clickable:F2(N)}};