Elm.Native=Elm.Native||{},Elm.Native.Graphics=Elm.Native.Graphics||{},Elm.Native.Graphics.Collage=Elm.Native.Graphics.Collage||{},Elm.Native.Graphics.Collage.make=function(t){"use strict";function e(t,e){t.lineWidth=e.width;var r=e.cap.ctor;t.lineCap="Flat"===r?"butt":"Round"===r?"round":"square";var a=e.join.ctor;t.lineJoin="Smooth"===a?"round":"Sharp"===a?"miter":"bevel",t.miterLimit=e.join._0||10,t.strokeStyle=G.toCss(e.color)}function r(t,e,r){var a=r.ctor;e.fillStyle="Solid"===a?G.toCss(r._0):"Texture"===a?l(t,e,r._0):s(e,r._0)}function a(t,e){var r=b.toArray(e),a=r.length-1;if(!(0>=a)){for(t.moveTo(r[a]._0,r[a]._1);a--;)t.lineTo(r[a]._0,r[a]._1);e.closed&&(a=r.length-1,t.lineTo(r[a]._0,r[a]._1))}}function n(t,e,r){"[]"===e.dashing.ctor?a(t,r):o(t,e,r),t.scale(1,-1),t.stroke()}function o(t,e,r){var a=b.toArray(r);r.closed&&a.push(a[0]);var n=b.toArray(e.dashing),o=a.length-1;if(!(0>=o)){var i=a[o]._0,l=a[o]._1,s=0,f=0,c=0,h=0,u=0,v=0,m=n.length,p=!0,d=n[0];for(t.moveTo(i,l);o--;){for(s=a[o]._0,f=a[o]._1,c=s-i,h=f-l,u=Math.sqrt(c*c+h*h);u>=d;)i+=c*d/u,l+=h*d/u,t[p?"lineTo":"moveTo"](i,l),c=s-i,h=f-l,u=Math.sqrt(c*c+h*h),p=!p,v=(v+1)%m,d=n[v];u>0&&(t[p?"lineTo":"moveTo"](s,f),d-=u),i=s,l=f}}}function i(t,r,a){return e(t,r),n(t,r,a)}function l(t,e,r){var a=new Image;return a.src=r,a.onload=t,e.createPattern(a,"repeat")}function s(t,e){var r,a=[];if("Linear"===e.ctor){var n=e._0,o=e._1;r=t.createLinearGradient(n._0,-n._1,o._0,-o._1),a=b.toArray(e._2)}else{var n=e._0,i=e._2;r=t.createRadialGradient(n._0,-n._1,e._1,i._0,-i._1,e._3),a=b.toArray(e._4)}for(var l=a.length,s=0;l>s;++s){var f=a[s];r.addColorStop(f._0,G.toCss(f._1))}return r}function f(t,e,n,o){a(e,o),r(t,e,n),e.scale(1,-1),e.fill()}function c(t,e,r){u(e,r,e.fillText)}function h(t,r,a,n){if(e(r,a),"[]"!==a.dashing.ctor&&r.setLineDash){var o=b.toArray(a.dashing);r.setLineDash(o)}u(r,n,r.strokeText)}function u(t,e,r){var a=m(L,e),n=0,o=0,i=a.length;t.scale(1,-1);for(var l=i;l--;){var s=a[l];t.font=s.font;var f=t.measureText(s.text);s.width=f.width,n+=s.width,s.height>o&&(o=s.height)}for(var c=-n/2,l=0;i>l;++l){var s=a[l];t.font=s.font,t.fillStyle=s.color,r.call(t,s.text,c,o/2),c+=s.width}}function v(t){return[t["font-style"],t["font-variant"],t["font-weight"],t["font-size"],t["font-family"]].join(" ")}function m(t,e){var r=e.ctor;if("Text:Append"===r){var a=m(t,e._0),n=m(t,e._1);return a.concat(n)}if("Text:Text"===r)return[{text:e._0,color:t.color,height:0|t["font-size"].slice(0,-2),font:v(t)}];if("Text:Meta"===r){var o=p(e._0,t);return m(o,e._1)}}function p(t,e){return{"font-style":t["font-style"]||e["font-style"],"font-variant":t["font-variant"]||e["font-variant"],"font-weight":t["font-weight"]||e["font-weight"],"font-size":t["font-size"]||e["font-size"],"font-family":t["font-family"]||e["font-family"],color:t.color||e.color}}function d(t,e,r){var a=new Image;a.onload=t,a.src=r._3;var n=r._0,o=r._1,i=r._2,l=i._0,s=i._1,f=n,c=o,h=-n/2,u=-o/2,v=n,m=o;e.scale(1,-1),e.drawImage(a,l,s,f,c,h,u,v,m)}function _(t,e,r){e.save();var a=r.x,n=r.y,o=r.theta,l=r.scale;(0!==a||0!==n)&&e.translate(a,n),0!==o&&e.rotate(o%(2*Math.PI)),1!==l&&e.scale(l,l),1!==r.alpha&&(e.globalAlpha=e.globalAlpha*r.alpha),e.beginPath();var s=r.form;switch(s.ctor){case"FPath":i(e,s._0,s._1);break;case"FImage":d(t,e,s);break;case"FShape":"Line"===s._0.ctor?(s._1.closed=!0,i(e,s._0._0,s._1)):f(t,e,s._0._0,s._1);break;case"FText":c(t,e,s._0);break;case"FOutlinedText":h(t,e,s._0,s._1)}e.restore()}function g(t){var e=t.scale,r=A6(S.matrix,e,0,0,e,t.x,t.y),a=t.theta;return 0!==a&&(r=A2(S.multiply,r,S.rotation(a))),r}function x(t){return 1e-5>t&&t>-1e-5?0:t}function y(t,e,r,a){for(var n=r.form._0._0.props,o=A6(S.matrix,1,0,0,-1,(t-n.width)/2,(e-n.height)/2),i=a.length,l=0;i>l;++l)o=A2(S.multiply,o,a[l]);return o=A2(S.multiply,o,g(r)),"matrix("+x(o[0])+", "+x(o[3])+", "+x(-o[1])+", "+x(-o[4])+", "+x(o[2])+", "+x(o[5])+")"}function N(t){function e(){return n<a.length?a[n]._0.form.ctor:""}function r(){var t=a[n]._0;return++n,t}var a=b.toArray(t),n=0;return{peekNext:e,next:r}}function w(t){function e(){for(var t=o.length,e="",r=0;t>r;++r)if(e=o[r].peekNext())return e;return""}function r(t){for(;!o[0].peekNext();)o.shift(),i.pop(),l.shift(),t&&t.restore();var e=o[0].next(),r=e.form;if("FGroup"===r.ctor){o.unshift(N(r._1));var a=A2(S.multiply,r._0,g(e));t.save(),t.transform(a[0],a[3],a[1],a[4],a[2],a[5]),i.push(a);var n=(l[0]||1)*e.alpha;l.unshift(n),t.globalAlpha=n}return e}function a(){return i}function n(){return l[0]||1}var o=[N(t)],i=[],l=[];return{peekNext:e,next:r,transforms:a,alpha:n}}function C(t,e){var r=F.createNode("canvas");r.style.width=t+"px",r.style.height=e+"px",r.style.display="block",r.style.position="absolute";var a=window.devicePixelRatio||1;return r.width=t*a,r.height=e*a,r}function k(t){var e=F.createNode("div");return e.style.overflow="hidden",e.style.position="relative",T(e,t,t),e}function E(t,e,r){function a(r,a){a.translate(t/2*f,e/2*f),a.scale(f,-f);for(var n=r.length,o=0;n>o;++o){var i=r[o];a.save(),a.transform(i[0],i[3],i[1],i[4],i[2],i[5])}return a}function n(n){for(;s<l.length;){var o=l[s];if(o.getContext)return o.width=t*f,o.height=e*f,o.style.width=t+"px",o.style.height=e+"px",++s,a(n,o.getContext("2d"));r.removeChild(o)}var i=C(t,e);return r.appendChild(i),++s,a(n,i.getContext("2d"))}function o(a,n,o){var i=l[s],f=o.form._0,c=!i||i.getContext?F.render(f):F.update(i,i.oldElement,f);c.style.position="absolute",c.style.opacity=n*o.alpha*f._0.props.opacity,F.addTransform(c.style,y(t,e,o,a)),c.oldElement=f,++s,i?r.insertBefore(c,i):r.appendChild(c)}function i(){for(;s<l.length;)r.removeChild(l[s])}var l=r.childNodes,s=0,f=window.devicePixelRatio||1;return{nextContext:n,addElement:o,clearRest:i}}function T(t,e,r){for(var a=r.w,n=r.h,o=w(r.forms),i=E(a,n,t),l=null,s="";s=o.peekNext();){null===l&&"FElement"!==s&&(l=i.nextContext(o.transforms()),l.globalAlpha=o.alpha());var f=o.next(l);"FElement"===s?(i.addElement(o.transforms(),o.alpha(),f),l=null):"FGroup"!==s&&_(function(){T(t,r,r)},l,f)}return i.clearRest(),t}function A(t,e,r){return A3(F.newElement,t,e,{ctor:"Custom",type:"Collage",render:k,update:T,model:{w:t,h:e,forms:r}})}if(t.Native=t.Native||{},t.Native.Graphics=t.Native.Graphics||{},t.Native.Graphics.Collage=t.Native.Graphics.Collage||{},"values"in t.Native.Graphics.Collage)return t.Native.Graphics.Collage.values;var G=Elm.Native.Color.make(t),b=Elm.Native.List.make(t),F=Elm.Native.Graphics.Element.make(t),S=Elm.Transform2D.make(t),L=(Elm.Native.Utils.make(t),{"font-style":"normal","font-variant":"normal","font-weight":"normal","font-size":"12px","font-family":"sans-serif",color:"black"});return t.Native.Graphics.Collage.values={collage:F3(A)}};