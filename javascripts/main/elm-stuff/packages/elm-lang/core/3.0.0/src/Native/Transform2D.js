Elm.Native.Transform2D={},Elm.Native.Transform2D.make=function(t){function r(t,r,n,a,e,s){return new i([t,r,e,n,a,s])}function n(t){var r=Math.cos(t),n=Math.sin(t);return new i([r,-n,0,n,r,0])}function a(t,r){var n=t[0],a=t[1],e=t[3],s=t[4],o=t[2],v=t[5],f=r[0],u=r[1],m=r[3],h=r[4],l=r[2],N=r[5];return new i([n*f+a*m,n*u+a*h,n*l+a*N+o,e*f+s*m,e*u+s*h,e*l+s*N+v])}if(t.Native=t.Native||{},t.Native.Transform2D=t.Native.Transform2D||{},t.Native.Transform2D.values)return t.Native.Transform2D.values;var i;i="undefined"==typeof Float32Array?function(t){this.length=t.length,this[0]=t[0],this[1]=t[1],this[2]=t[2],this[3]=t[3],this[4]=t[4],this[5]=t[5]}:Float32Array;var e=new i([1,0,0,0,1,0]);return t.Native.Transform2D.values={identity:e,matrix:F6(r),rotation:n,multiply:F2(a)}};