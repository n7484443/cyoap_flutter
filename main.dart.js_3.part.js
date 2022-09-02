self.$__dart_deferred_initializers__=self.$__dart_deferred_initializers__||Object.create(null)
$__dart_deferred_initializers__.current=function(a,b,c,$){var B={
bdz(){return $.U3()},
aBo:function aBo(){},
ax3:function ax3(){this.b=this.a=null},
aBp:function aBp(){},
YJ:function YJ(){},
aqF:function aqF(d,e){this.a=d
this.b=e},
aqD:function aqD(d,e){this.a=d
this.b=e},
a03:function a03(d,e){this.b=d
this.a=e},
aim:function aim(){},
aHy:function aHy(){},
ax1:function ax1(){},
bps(){var x,w=A.n4(new B.asZ(),new B.at_(),null,y.j,y.z),v=new A.aZ(new A.am($.at,y.x),y.a)
w=new B.Zs(w,v)
if(typeof window.Worker!="undefined"){x=new Worker("worker.js")
v.d9(0,x)
A.mu(x,"message",w.gaxl(),!1)}else v.d9(0,null)
return w},
Zs:function Zs(d,e){this.a=d
this.b=e
this.d=0},
asZ:function asZ(){},
at_:function at_(){},
bz:function bz(d,e,f){this.a=d
this.b=e
this.$ti=f},
bhB(d){if(!C.b.b_(d,"/"))return"/"+d
return d},
bCo(d){if(C.b.ct(d,"/"))return C.b.a5(d,0,d.length-1)
return d},
nL(d,e){d=d+e&536870911
d=d+((d&524287)<<10)&536870911
return d^d>>>6},
TI(d){d=d+((d&67108863)<<3)&536870911
d^=d>>>11
return d+((d&16383)<<15)&536870911}},A,J,C,D
B=a.updateHolder(c[7],B)
A=c[0]
J=c[1]
C=c[2]
D=c[15]
B.aBo.prototype={
Mu(d,e){return this.azK(d,e)},
azK(d,e){var x=0,w=A.I(y.f),v
var $async$Mu=A.C(function(f,g){if(f===1)return A.F(g,w)
while(true)switch(x){case 0:v=new B.bz(d,e,y.f)
x=1
break
case 1:return A.G(v,w)}})
return A.H($async$Mu,w)},
Ao(d){return this.a6x(d)},
a6x(d){var x=0,w=A.I(y.P),v,u=this,t,s,r,q,p,o,n,m,l,k,j,i
var $async$Ao=A.C(function(e,f){if(e===1)return A.F(f,w)
while(true)switch(x){case 0:j=J.a5(d)
i=j.h(d,"platform")
i=C.ae.gjN().cs(i)
t=C.ak.mr(j.h(d,"imageSource"),null)
s=y.z
r=A.a0(["platform.json",i,"imageSource.json",C.ae.gjN().cs(t)],y.N,s)
t=y.G
q=t.a(j.h(d,"imageMap"))
i=J.ad(q),p=J.aA(i.gc_(q))
case 3:if(!p.t()){x=4
break}o=p.gK(p)
n=i.h(q,o)
n.toString
x=5
return A.J(u.Mu(o,new Uint8Array(A.lm(new A.er(n)))),$async$Ao)
case 5:m=f
r.m(0,"images/"+A.m(m.a),m.b)
x=3
break
case 4:l=J.dh(0,s)
k=t.a(j.h(d,"lineSetting"))
for(j=J.ad(k),i=J.aA(j.gc_(k));i.t();){t=i.gK(i)
s=j.h(k,t)
s.toString
r.m(0,"nodes/"+t,C.ae.gjN().cs(s))
l.push(t)}j=C.ak.mr(l,null)
r.m(0,"nodes/list.json",C.ae.gjN().cs(j))
v=r
x=1
break
case 1:return A.G(v,w)}})
return A.H($async$Ao,w)},
H2(d,e){return this.a70(d,e)},
a70(d,e){var x=0,w=A.I(y.H)
var $async$H2=A.C(function(f,g){if(f===1)return A.F(g,w)
while(true)switch(x){case 0:return A.G(null,w)}})
return A.H($async$H2,w)}}
B.ax3.prototype={
mz(){var x=$.U3()
x.a=null
x.b=new B.aBp()},
aI3(){var x,w,v,u=$.bkA()
u=u==null?null:u.getAttribute("href")
if(u==null)A.a2(A.ej("Please add a <base> element to your index.html"))
if(!J.b3N(u,"/"))A.a2(A.ej('The base href has to end with a "/" to work correctly'))
x=$.blF()
x.href=u
w=x.pathname
if(w==null)w=""
u=new B.a03(B.bCo(w.length===0||w[0]==="/"?w:"/"+w),D.a6k)
v={getPath:A.b1(u.ga6I(u)),getState:A.b1(u.ga6T(u)),addPopStateListener:A.b1(u.gaxX(u)),prepareExternalUrl:A.b1(u.gaI7(u)),pushState:A.b1(u.gaIl(u)),replaceState:A.b1(u.gaIZ(u)),go:A.b1(u.ga6V(u))}
v=v
self._flutter_web_set_location_strategy.$1(v)}}
B.aBp.prototype={
t0(d,e){return this.a71(d,e)},
a71(d,e){var x=0,w=A.I(y.H),v=this,u,t,s
var $async$t0=A.C(function(f,g){if(f===1)return A.F(g,w)
while(true)switch(x){case 0:x=2
return A.J(v.Ao(e),$async$t0)
case 2:u=g
t=$.bj3()
x=3
return A.J(t.F9(0,A.a(["save_web.js","jszip.js"],y.s)),$async$t0)
case 3:s=d
x=4
return A.J(t.Gl(C.ak.mr(u,null),"_compressToZip"),$async$t0)
case 4:v.Nh(s,g)
return A.G(null,w)}})
return A.H($async$t0,w)},
Nh(d,e){return this.aBY(d,e)},
aBY(d,e){var x=0,w=A.I(y.H)
var $async$Nh=A.C(function(f,g){if(f===1)return A.F(g,w)
while(true)switch(x){case 0:self._exportRaw(d,e)
return A.G(null,w)}})
return A.H($async$Nh,w)}}
B.YJ.prototype={
qH(d,e){C.jV.LH(window,"popstate",e)
return new B.aqF(this,e)},
o6(d){return new A.Ob([],[]).Mv(window.history.state,!0)},
rD(d,e){var x,w
if(e.length===0){x=window.location.pathname
if(x==null)x=""
w=window.location.search
x+=w==null?"":w}else x="#"+e
return x},
zI(d,e,f,g){var x=this.rD(0,g)
window.history.pushState(new A.S7([],[]).mS(e),f,x)},
mN(d,e,f,g){var x=this.rD(0,g)
window.history.replaceState(new A.S7([],[]).mS(e),f,x)},
q3(d,e){window.history.go(e)
return this.ax8()},
ax8(){var x=new A.am($.at,y.D),w=A.br("unsubscribe")
w.b=this.qH(0,new B.aqD(w,new A.aZ(x,y.h)))
return x}}
B.a03.prototype={
Aq(d){var x,w,v=window.location.pathname
if(v==null)v=""
x=window.location.search
w=v+(x==null?"":x)
v=this.b
x=v.length
if(x!==0&&C.b.b_(w,v))return B.bhB(C.b.bw(w,x))
return B.bhB(w)},
rD(d,e){if(e.length!==0&&!C.b.b_(e,"/"))e="/"+e
return this.b+e}}
B.aim.prototype={}
B.aHy.prototype={}
B.ax1.prototype={}
B.Zs.prototype={
axm(d){var x=y.j.a(new A.Ob([],[]).Mv(d.data,!0)),w=y.b.a(this.a.E(0,x)),v=J.a5(x),u=A.b8(v.h(x,2)),t=v.h(x,3)
if(u==="result")w.d9(0,t)
else if(u==="error")w.iH(t==null?y.K.a(t):t)},
F9(d,e){return this.aF6(0,e)},
aF6(d,e){var x=0,w=A.I(y.y),v,u=this,t,s
var $async$F9=A.C(function(f,g){if(f===1)return A.F(g,w)
while(true)switch(x){case 0:x=3
return A.J(u.b.a,$async$F9)
case 3:s=g
if(s!=null){t=A.a(["$init_scripts"],y.s)
C.d.P(t,e)
C.a37.a4E(s,t)
v=!0
x=1
break}v=!1
x=1
break
case 1:return A.G(v,w)}})
return A.H($async$F9,w)},
Gl(d,e){var x=0,w=A.I(y.z),v,u=this,t,s,r,q
var $async$Gl=A.C(function(f,g){if(f===1)return A.F(g,w)
while(true)switch(x){case 0:x=3
return A.J(u.b.a,$async$Gl)
case 3:q=g
if(q==null){v=null
x=1
break}t=u.d
if(t===1000)t=u.d=0
s=new A.am($.at,y._)
u.d=t+1
r=[t,e,d]
u.a.m(0,r,new A.aZ(s,y.c))
C.a37.a4E(q,r)
v=s
x=1
break
case 1:return A.G(v,w)}})
return A.H($async$Gl,w)}}
B.bz.prototype={
j(d){return"["+A.m(this.a)+", "+A.m(this.b)+"]"},
l(d,e){if(e==null)return!1
return e instanceof B.bz&&J.j(e.a,this.a)&&J.j(e.b,this.b)},
gC(d){var x=J.N(this.a),w=J.N(this.b)
return B.TI(B.nL(B.nL(0,C.c.gC(x)),C.c.gC(w)))}}
var z=a.updateTypes(["~(A?,i,i)","~()(@(A))","A?()","ab<~>(l)","i()","i(i)","~(xw)"])
B.aqF.prototype={
$0(){C.jV.a56(window,"popstate",this.b)
return null},
$S:0}
B.aqD.prototype={
$1(d){this.a.aF().$0()
this.b.hp(0)},
$S:111}
B.asZ.prototype={
$2(d,e){return J.j(J.aU(d,0),J.aU(e,0))},
$S:552}
B.at_.prototype={
$1(d){return J.N(J.aU(d,0))},
$S:553};(function installTearOffs(){var x=a._instance_1i,w=a._instance_0i,v=a.installInstanceTearOff,u=a._instance_1u
var t
x(t=B.YJ.prototype,"gaxX","qH",1)
w(t,"ga6T","o6",2)
v(t,"gaIl",1,3,null,["$3"],["zI"],0,0,0)
v(t,"gaIZ",1,3,null,["$3"],["mN"],0,0,0)
x(t,"ga6V","q3",3)
w(t=B.a03.prototype,"ga6I","Aq",4)
x(t,"gaI7","rD",5)
u(B.Zs.prototype,"gaxl","axm",6)})();(function inheritance(){var x=a.inheritMany,w=a.inherit
x(A.A,[B.aBo,B.ax3,B.aHy,B.ax1,B.Zs,B.bz])
w(B.aBp,B.aBo)
w(B.YJ,B.aHy)
w(B.aqF,A.mK)
x(A.e3,[B.aqD,B.at_])
w(B.a03,B.YJ)
w(B.aim,B.ax1)
w(B.asZ,A.o2)})()
A.zz(b.typeUniverse,JSON.parse("{}"))
var y=(function rtii(){var x=A.Z
return{b:x("Wz<@>"),s:x("r<i>"),j:x("q<@>"),G:x("as<i,i>"),P:x("as<i,@>"),K:x("A"),N:x("i"),f:x("bz<i,bA>"),c:x("aZ<@>"),a:x("aZ<v8?>"),h:x("aZ<~>"),_:x("am<@>"),x:x("am<v8?>"),D:x("am<~>"),y:x("v"),z:x("@"),H:x("~")}})();(function constants(){D.a6k=new B.aim()})();(function lazyInitializers(){var x=a.lazyFinal
x($,"bEY","U3",()=>new B.ax3())
x($,"bJ5","blF",()=>{var w=A.bhz().createElement("a")
return w})
x($,"bHu","bkA",()=>A.bhz().querySelector("base"))
x($,"bEE","bj3",()=>B.bps())})()}
$__dart_deferred_initializers__["l/YhY/vTuPHB7Sy64ArXD/SxyBA="] = $__dart_deferred_initializers__.current
