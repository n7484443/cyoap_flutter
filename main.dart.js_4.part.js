self.$__dart_deferred_initializers__=self.$__dart_deferred_initializers__||Object.create(null)
$__dart_deferred_initializers__.current=function(a,b,c,$){var A={a2k:function a2k(){},a2l:function a2l(){},
aDz(){return $.Zh()},
a2j:function a2j(){},
ab3:function ab3(){this.b=this.a=null},
LP:function LP(){},
a6T:function a6T(d,e){this.a=d
this.b=e},
a6R:function a6R(d,e){this.a=d
this.b=e},
No:function No(d,e){this.b=d
this.a=e},
a_X:function a_X(){},
akm:function akm(){},
ab1:function ab1(){},
dE:function dE(d,e,f){this.a=d
this.b=e
this.$ti=f},
aGM(d){if(!C.b.av(d,"/"))return"/"+d
return d},
aVW(d){if(C.b.e5(d,"/"))return C.b.U(d,0,d.length-1)
return d},
k4(d,e){d=d+e&536870911
d=d+((d&524287)<<10)&536870911
return d^d>>>6},
HP(d){d=d+((d&67108863)<<3)&536870911
d^=d>>>11
return d+((d&16383)<<15)&536870911}},B,J,C,D
A=a.updateHolder(c[5],A)
B=c[0]
J=c[1]
C=c[2]
D=c[11]
A.a2k.prototype={
tN(){var x=0,w=B.K(y.B),v,u=this,t,s,r
var $async$tN=B.G(function(d,e){if(d===1)return B.H(e,w)
while(true)switch(x){case 0:t=J
s=y.i
r=C.aj
x=3
return B.L(u.mf("nodes/list.json"),$async$tN)
case 3:v=t.ip(s.a(r.lp(0,e,null)),new A.a2l(),y.w).d7(0)
x=1
break
case 1:return B.I(v,w)}})
return B.J($async$tN,w)},
tM(d){return this.Td(d)},
Td(d){var x=0,w=B.K(y.o),v,u
var $async$tM=B.G(function(e,f){if(e===1)return B.H(f,w)
while(true)switch(x){case 0:u=B.QM()
x=3
return B.L(B.aGQ(B.eC(u.glW(u)+"/dist/"+d,0,null)),$async$tM)
case 3:v=f.w
x=1
break
case 1:return B.I(v,w)}})
return B.J($async$tM,w)},
mf(d){return this.Tc(d)},
Tc(d){var x=0,w=B.K(y.w),v,u=this,t
var $async$mf=B.G(function(e,f){if(e===1)return B.H(f,w)
while(true)switch(x){case 0:t=C.H
x=3
return B.L(u.tM(d),$async$mf)
case 3:v=t.e4(0,f)
x=1
break
case 1:return B.I(v,w)}})
return B.J($async$mf,w)}}
A.a2j.prototype={}
A.ab3.prototype={
t2(){var x=$.Zh()
x.a=new A.a2k()
x.b=null},
aiN(){var x,w,v,u=$.aJ9()
u=u==null?null:u.getAttribute("href")
if(u==null)B.U(B.dT("Please add a <base> element to your index.html"))
if(!J.aw8(u,"/"))B.U(B.dT('The base href has to end with a "/" to work correctly'))
x=$.aK0()
x.href=u
w=x.pathname
if(w==null)w=""
u=new A.No(A.aVW(w.length===0||w[0]==="/"?w:"/"+w),D.yT)
v={getPath:B.au(u.gTp(u)),getState:B.au(u.gTy(u)),addPopStateListener:B.au(u.gab4(u)),prepareExternalUrl:B.au(u.gaiQ(u)),pushState:B.au(u.gaj0(u)),replaceState:B.au(u.gajz(u)),go:B.au(u.gTA(u))}
v=v
self._flutter_web_set_location_strategy.$1(v)}}
A.LP.prototype={
mJ(d,e){C.lz.aaW(window,"popstate",e)
return new A.a6T(this,e)},
kM(d){return new B.DX([],[]).D1(window.history.state,!0)},
ns(d,e){var x,w
if(e.length===0){x=window.location.pathname
if(x==null)x=""
w=window.location.search
x+=w==null?"":w}else x="#"+e
return x},
tq(d,e,f,g){var x=this.ns(0,g)
window.history.pushState(new B.GQ([],[]).jV(e),f,x)},
jQ(d,e,f,g){var x=this.ns(0,g)
window.history.replaceState(new B.GQ([],[]).jV(e),f,x)},
mm(d,e){window.history.go(e)
return this.aak()},
aak(){var x=new B.aj($.W,y.E),w=B.bi("unsubscribe")
w.b=this.mJ(0,new A.a6R(w,new B.aW(x,y.D)))
return x}}
A.No.prototype={
tO(d){var x,w,v=window.location.pathname
if(v==null)v=""
x=window.location.search
w=v+(x==null?"":x)
v=this.b
x=v.length
if(x!==0&&C.b.av(w,v))return A.aGM(C.b.bT(w,x))
return A.aGM(w)},
ns(d,e){if(e.length!==0&&!C.b.av(e,"/"))e="/"+e
return this.b+e}}
A.a_X.prototype={}
A.akm.prototype={}
A.ab1.prototype={}
A.dE.prototype={
j(d){return"["+B.o(this.a)+", "+B.o(this.b)+"]"},
l(d,e){if(e==null)return!1
return e instanceof A.dE&&J.h(e.a,this.a)&&J.h(e.b,this.b)},
gv(d){var x=J.z(this.a),w=J.z(this.b)
return A.HP(A.k4(A.k4(0,C.f.gv(x)),C.f.gv(w)))}}
var z=a.updateTypes(["~(x?,i,i)","~()(@(x))","x?()","a_<~>(m)","i()","i(i)"])
A.a2l.prototype={
$1(d){return J.cs(d)},
$S:127}
A.a6T.prototype={
$0(){C.lz.ajo(window,"popstate",this.b)
return null},
$S:0}
A.a6R.prototype={
$1(d){this.a.aR().$0()
this.b.eI(0)},
$S:160};(function installTearOffs(){var x=a._instance_1i,w=a._instance_0i,v=a.installInstanceTearOff
var u
x(u=A.LP.prototype,"gab4","mJ",1)
w(u,"gTy","kM",2)
v(u,"gaj0",1,3,null,["$3"],["tq"],0,0,0)
v(u,"gajz",1,3,null,["$3"],["jQ"],0,0,0)
x(u,"gTA","mm",3)
w(u=A.No.prototype,"gTp","tO",4)
x(u,"gaiQ","ns",5)})();(function inheritance(){var x=a.inheritMany,w=a.inherit
x(B.x,[A.a2j,A.ab3,A.akm,A.ab1,A.dE])
w(A.a2k,A.a2j)
x(B.cB,[A.a2l,A.a6R])
w(A.LP,A.akm)
w(A.a6T,B.no)
w(A.No,A.LP)
w(A.a_X,A.ab1)})()
B.Hb(b.typeUniverse,JSON.parse("{}"))
var y={B:B.a6("y<i>"),i:B.a6("y<@>"),w:B.a6("i"),o:B.a6("cc"),D:B.a6("aW<~>"),E:B.a6("aj<~>")};(function constants(){D.yT=new A.a_X()})();(function lazyInitializers(){var x=a.lazyFinal
x($,"aXK","Zh",()=>new A.ab3())
x($,"b_Z","aK0",()=>{var w=B.aGJ().createElement("a")
return w})
x($,"aZH","aJ9",()=>B.aGJ().querySelector("base"))})()}
$__dart_deferred_initializers__["jIryOJ/dBwPSUPyqbxUe1lFsZxk="] = $__dart_deferred_initializers__.current
