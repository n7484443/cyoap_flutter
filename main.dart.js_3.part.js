self.$__dart_deferred_initializers__=self.$__dart_deferred_initializers__||Object.create(null)
$__dart_deferred_initializers__.current=function(a,b,c,$){var B={
bcj(){return $.Ty()},
axV:function axV(){},
atY:function atY(){this.b=this.a=null},
axW:function axW(){},
XI:function XI(){},
anA:function anA(d,e){this.a=d
this.b=e},
any:function any(d,e){this.a=d
this.b=e},
a_1:function a_1(d,e){this.b=d
this.a=e},
agf:function agf(){},
aDL:function aDL(){},
atW:function atW(){},
bnx(){var x,w=A.mL(new B.apU(),new B.apV(),null,y.j,y.z),v=new A.aY(new A.al($.as,y.x),y.a)
w=new B.Yq(w,v)
if(typeof window.Worker!="undefined"){x=new Worker("worker.js")
v.d_(0,x)
A.ce(x,"message",w.gaxJ(),!1,y._)}else v.d_(0,null)
return w},
Yq:function Yq(d,e){this.a=d
this.b=e
this.d=0},
apU:function apU(){},
apV:function apV(){},
bJ:function bJ(d,e,f){this.a=d
this.b=e
this.$ti=f},
bg4(d){if(!C.c.aV(d,"/"))return"/"+d
return d},
bA9(d){if(C.c.co(d,"/"))return C.c.a0(d,0,d.length-1)
return d},
nx(d,e){d=d+e&536870911
d=d+((d&524287)<<10)&536870911
return d^d>>>6},
Td(d){d=d+((d&67108863)<<3)&536870911
d^=d>>>11
return d+((d&16383)<<15)&536870911}},A,J,C,D
B=a.updateHolder(c[6],B)
A=c[0]
J=c[1]
C=c[2]
D=c[15]
B.axV.prototype={
LD(d,e){return this.aA3(d,e)},
aA3(d,e){var x=0,w=A.H(y.f),v
var $async$LD=A.D(function(f,g){if(f===1)return A.E(g,w)
while(true)switch(x){case 0:v=new B.bJ(d,e,y.f)
x=1
break
case 1:return A.F(v,w)}})
return A.G($async$LD,w)},
zZ(d){return this.a8a(d)},
a8a(d){var x=0,w=A.H(y.P),v,u=this,t,s,r,q,p,o,n,m,l,k,j,i
var $async$zZ=A.D(function(e,f){if(e===1)return A.E(f,w)
while(true)switch(x){case 0:j=J.Y(d)
i=j.h(d,"platform")
i=C.ae.gjD().cn(i)
t=C.ad.mc(j.h(d,"imageSource"),null)
s=y.z
r=A.a_(["platform.json",i,"imageSource.json",C.ae.gjD().cn(t)],y.N,s)
t=y.G
q=t.a(j.h(d,"imageMap"))
i=J.f(q),p=J.az(i.gbZ(q))
case 3:if(!p.v()){x=4
break}o=p.gK(p)
n=i.h(q,o)
n.toString
x=5
return A.I(u.LD(o,new Uint8Array(A.l2(new A.ed(n)))),$async$zZ)
case 5:m=f
r.m(0,"images/"+A.n(m.a),m.b)
x=3
break
case 4:l=J.d7(0,s)
k=t.a(j.h(d,"lineSetting"))
for(j=J.f(k),i=J.az(j.gbZ(k));i.v();){t=i.gK(i)
s=j.h(k,t)
s.toString
r.m(0,"nodes/"+t,C.ae.gjD().cn(s))
l.push(t)}j=C.ad.mc(l,null)
r.m(0,"nodes/list.json",C.ae.gjD().cn(j))
v=r
x=1
break
case 1:return A.F(v,w)}})
return A.G($async$zZ,w)},
G8(d,e){return this.a8y(d,e)},
a8y(d,e){var x=0,w=A.H(y.H)
var $async$G8=A.D(function(f,g){if(f===1)return A.E(g,w)
while(true)switch(x){case 0:return A.F(null,w)}})
return A.G($async$G8,w)}}
B.atY.prototype={
mj(){var x=$.Ty()
x.a=null
x.b=new B.axW()},
aHS(){var x,w,v,u=$.biX()
u=u==null?null:u.getAttribute("href")
if(u==null)A.a6(A.e0("Please add a <base> element to your index.html"))
if(!J.b_m(u,"/"))A.a6(A.e0('The base href has to end with a "/" to work correctly'))
x=$.bk1()
x.href=u
w=x.pathname
if(w==null)w=""
u=new B.a_1(B.bA9(w.length===0||w[0]==="/"?w:"/"+w),D.a4P)
v={getPath:A.fQ(u.gPW(u)),getState:A.fQ(u.gQ4(u)),addPopStateListener:A.fQ(u.ga1A(u)),prepareExternalUrl:A.fQ(u.gaHW(u)),pushState:A.fQ(u.ga6l(u)),replaceState:A.fQ(u.ga6J(u)),go:A.fQ(u.gQ6(u))}
v=v
self._flutter_web_set_location_strategy.$1(v)}}
B.axW.prototype={
rE(d,e){return this.a8z(d,e)},
a8z(d,e){var x=0,w=A.H(y.H),v=this,u,t,s
var $async$rE=A.D(function(f,g){if(f===1)return A.E(g,w)
while(true)switch(x){case 0:x=2
return A.I(v.zZ(e),$async$rE)
case 2:u=g
t=$.bhv()
x=3
return A.I(t.Et(0,A.b(["save_web.js","jszip.js"],y.s)),$async$rE)
case 3:s=d
x=4
return A.I(t.Fq(C.ad.mc(u,null),"_compressToZip"),$async$rE)
case 4:v.Mp(s,g)
return A.F(null,w)}})
return A.G($async$rE,w)},
Mp(d,e){return this.aCd(d,e)},
aCd(d,e){var x=0,w=A.H(y.H)
var $async$Mp=A.D(function(f,g){if(f===1)return A.E(g,w)
while(true)switch(x){case 0:self._exportRaw(d,e)
return A.F(null,w)}})
return A.G($async$Mp,w)}}
B.XI.prototype={
n_(d,e){C.bW.km(window,"popstate",e)
return new B.anA(this,e)},
mB(d){return new A.lZ([],[]).m6(window.history.state,!0)},
rd(d,e){var x,w
if(e.length===0){x=window.location.pathname
if(x==null)x=""
w=window.location.search
x+=w==null?"":w}else x="#"+e
return x},
p9(d,e,f,g){var x=this.rd(0,g)
window.history.pushState(new A.z1([],[]).kP(e),f,x)},
jR(d,e,f,g){var x=this.rd(0,g)
window.history.replaceState(new A.z1([],[]).kP(e),f,x)},
lE(d,e){window.history.go(e)
return this.axx()},
axx(){var x=new A.al($.as,y.D),w=A.bx("unsubscribe")
w.b=this.n_(0,new B.any(w,new A.aY(x,y.h)))
return x}}
B.a_1.prototype={
py(d){var x,w,v=window.location.pathname
if(v==null)v=""
x=window.location.search
w=v+(x==null?"":x)
v=this.b
x=v.length
if(x!==0&&C.c.aV(w,v))return B.bg4(C.c.bw(w,x))
return B.bg4(w)},
rd(d,e){if(e.length!==0&&!C.c.aV(e,"/"))e="/"+e
return this.b+e}}
B.agf.prototype={}
B.aDL.prototype={}
B.atW.prototype={}
B.Yq.prototype={
axK(d){var x=y.j.a(new A.lZ([],[]).m6(d.data,!0)),w=y.b.a(this.a.F(0,x)),v=J.Y(x),u=A.b6(v.h(x,2)),t=v.h(x,3)
if(u==="result")w.d_(0,t)
else if(u==="error")w.j6(t==null?y.K.a(t):t)},
Et(d,e){return this.aF3(0,e)},
aF3(d,e){var x=0,w=A.H(y.y),v,u=this,t,s
var $async$Et=A.D(function(f,g){if(f===1)return A.E(g,w)
while(true)switch(x){case 0:x=3
return A.I(u.b.a,$async$Et)
case 3:s=g
if(s!=null){t=A.b(["$init_scripts"],y.s)
C.d.T(t,e)
C.a1G.a6b(s,t)
v=!0
x=1
break}v=!1
x=1
break
case 1:return A.F(v,w)}})
return A.G($async$Et,w)},
Fq(d,e){var x=0,w=A.H(y.z),v,u=this,t,s,r,q
var $async$Fq=A.D(function(f,g){if(f===1)return A.E(g,w)
while(true)switch(x){case 0:x=3
return A.I(u.b.a,$async$Fq)
case 3:q=g
if(q==null){v=null
x=1
break}t=u.d
if(t===1000)t=u.d=0
s=new A.al($.as,y.d)
u.d=t+1
r=[t,e,d]
u.a.m(0,r,new A.aY(s,y.c))
C.a1G.a6b(q,r)
v=s
x=1
break
case 1:return A.F(v,w)}})
return A.G($async$Fq,w)}}
B.bJ.prototype={
j(d){return"["+A.n(this.a)+", "+A.n(this.b)+"]"},
l(d,e){if(e==null)return!1
return e instanceof B.bJ&&J.k(e.a,this.a)&&J.k(e.b,this.b)},
gC(d){var x=J.J(this.a),w=J.J(this.b)
return B.Td(B.nx(B.nx(0,C.b.gC(x)),C.b.gC(w)))}}
var z=a.updateTypes(["~(B?,i,i)","~()(@(B))","B?()","aa<~>(m)","i()","i(i)","~(tv)"])
B.anA.prototype={
$0(){C.bW.rh(window,"popstate",this.b)
return null},
$S:0}
B.any.prototype={
$1(d){this.a.aW().$0()
this.b.hk(0)},
$S:156}
B.apU.prototype={
$2(d,e){return J.k(J.a1(d,0),J.a1(e,0))},
$S:533}
B.apV.prototype={
$1(d){return J.J(J.a1(d,0))},
$S:534};(function installTearOffs(){var x=a._instance_1i,w=a._instance_0i,v=a.installInstanceTearOff,u=a._instance_1u
var t
x(t=B.XI.prototype,"ga1A","n_",1)
w(t,"gQ4","mB",2)
v(t,"ga6l",1,3,null,["$3"],["p9"],0,0,0)
v(t,"ga6J",1,3,null,["$3"],["jR"],0,0,0)
x(t,"gQ6","lE",3)
w(t=B.a_1.prototype,"gPW","py",4)
x(t,"gaHW","rd",5)
u(B.Yq.prototype,"gaxJ","axK",6)})();(function inheritance(){var x=a.inheritMany,w=a.inherit
x(A.B,[B.axV,B.atY,B.aDL,B.atW,B.Yq,B.bJ])
w(B.axW,B.axV)
w(B.XI,B.aDL)
w(B.anA,A.mn)
x(A.dN,[B.any,B.apV])
w(B.a_1,B.XI)
w(B.agf,B.atW)
w(B.apU,A.nN)})()
A.z2(b.typeUniverse,JSON.parse("{}"))
var y=(function rtii(){var x=A.R
return{b:x("VW<@>"),s:x("r<i>"),j:x("q<@>"),G:x("aq<i,i>"),P:x("aq<i,@>"),_:x("tv"),K:x("B"),N:x("i"),f:x("bJ<i,bk>"),c:x("aY<@>"),a:x("aY<yk?>"),h:x("aY<~>"),d:x("al<@>"),x:x("al<yk?>"),D:x("al<~>"),y:x("y"),z:x("@"),H:x("~")}})();(function constants(){D.a4P=new B.agf()})();(function lazyInitializers(){var x=a.lazyFinal
x($,"bCq","Ty",()=>new B.atY())
x($,"bGn","bk1",()=>A.bkN())
x($,"bEP","biX",()=>A.bxm().querySelector("base"))
x($,"bC9","bhv",()=>B.bnx())})()}
$__dart_deferred_initializers__["B+LPkfePQjfrbTk1hWEDiFjBqng="] = $__dart_deferred_initializers__.current
