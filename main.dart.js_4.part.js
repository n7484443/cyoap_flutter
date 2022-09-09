self.$__dart_deferred_initializers__=self.$__dart_deferred_initializers__||Object.create(null)
$__dart_deferred_initializers__.current=function(a,b,c,$){var A={a2u:function a2u(){},a2v:function a2v(){},
aDS(){return $.Zs()},
a2t:function a2t(){},
abf:function abf(){this.b=this.a=null},
LR:function LR(){},
a72:function a72(d,e){this.a=d
this.b=e},
a70:function a70(d,e){this.a=d
this.b=e},
Nq:function Nq(d,e){this.b=d
this.a=e},
a07:function a07(){},
aky:function aky(){},
abd:function abd(){},
dE:function dE(d,e,f){this.a=d
this.b=e
this.$ti=f},
aH6(d){if(!C.b.av(d,"/"))return"/"+d
return d},
aWj(d){if(C.b.e6(d,"/"))return C.b.V(d,0,d.length-1)
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
A.a2u.prototype={
tO(){var x=0,w=B.K(y.B),v,u=this,t,s,r
var $async$tO=B.G(function(d,e){if(d===1)return B.H(e,w)
while(true)switch(x){case 0:t=J
s=y.i
r=C.ak
x=3
return B.L(u.mg("nodes/list.json"),$async$tO)
case 3:v=t.ip(s.a(r.lr(0,e,null)),new A.a2v(),y.w).d8(0)
x=1
break
case 1:return B.I(v,w)}})
return B.J($async$tO,w)},
tN(d){return this.Te(d)},
Te(d){var x=0,w=B.K(y.o),v,u
var $async$tN=B.G(function(e,f){if(e===1)return B.H(f,w)
while(true)switch(x){case 0:u=B.QO()
x=3
return B.L(B.aHa(B.eC(u.glY(u)+"/dist/"+d,0,null)),$async$tN)
case 3:v=f.w
x=1
break
case 1:return B.I(v,w)}})
return B.J($async$tN,w)},
mg(d){return this.Td(d)},
Td(d){var x=0,w=B.K(y.w),v,u=this,t
var $async$mg=B.G(function(e,f){if(e===1)return B.H(f,w)
while(true)switch(x){case 0:t=C.J
x=3
return B.L(u.tN(d),$async$mg)
case 3:v=t.e5(0,f)
x=1
break
case 1:return B.I(v,w)}})
return B.J($async$mg,w)}}
A.a2t.prototype={}
A.abf.prototype={
t3(){var x=$.Zs()
x.a=new A.a2u()
x.b=null},
aiO(){var x,w,v,u=$.aJu()
u=u==null?null:u.getAttribute("href")
if(u==null)B.U(B.dT("Please add a <base> element to your index.html"))
if(!J.awq(u,"/"))B.U(B.dT('The base href has to end with a "/" to work correctly'))
x=$.aKl()
x.href=u
w=x.pathname
if(w==null)w=""
u=new A.Nq(A.aWj(w.length===0||w[0]==="/"?w:"/"+w),D.yV)
v={getPath:B.au(u.gTq(u)),getState:B.au(u.gTz(u)),addPopStateListener:B.au(u.gab5(u)),prepareExternalUrl:B.au(u.gaiR(u)),pushState:B.au(u.gaj1(u)),replaceState:B.au(u.gajA(u)),go:B.au(u.gTB(u))}
v=v
self._flutter_web_set_location_strategy.$1(v)}}
A.LR.prototype={
mL(d,e){C.lE.aaX(window,"popstate",e)
return new A.a72(this,e)},
kO(d){return new B.DW([],[]).D2(window.history.state,!0)},
ny(d,e){var x,w
if(e.length===0){x=window.location.pathname
if(x==null)x=""
w=window.location.search
x+=w==null?"":w}else x="#"+e
return x},
tr(d,e,f,g){var x=this.ny(0,g)
window.history.pushState(new B.GQ([],[]).jW(e),f,x)},
jQ(d,e,f,g){var x=this.ny(0,g)
window.history.replaceState(new B.GQ([],[]).jW(e),f,x)},
mn(d,e){window.history.go(e)
return this.aal()},
aal(){var x=new B.aj($.W,y.E),w=B.bi("unsubscribe")
w.b=this.mL(0,new A.a70(w,new B.aX(x,y.D)))
return x}}
A.Nq.prototype={
tP(d){var x,w,v=window.location.pathname
if(v==null)v=""
x=window.location.search
w=v+(x==null?"":x)
v=this.b
x=v.length
if(x!==0&&C.b.av(w,v))return A.aH6(C.b.bU(w,x))
return A.aH6(w)},
ny(d,e){if(e.length!==0&&!C.b.av(e,"/"))e="/"+e
return this.b+e}}
A.a07.prototype={}
A.aky.prototype={}
A.abd.prototype={}
A.dE.prototype={
j(d){return"["+B.o(this.a)+", "+B.o(this.b)+"]"},
l(d,e){if(e==null)return!1
return e instanceof A.dE&&J.h(e.a,this.a)&&J.h(e.b,this.b)},
gv(d){var x=J.z(this.a),w=J.z(this.b)
return A.HP(A.k4(A.k4(0,C.f.gv(x)),C.f.gv(w)))}}
var z=a.updateTypes(["~(x?,i,i)","~()(@(x))","x?()","a_<~>(m)","i()","i(i)"])
A.a2v.prototype={
$1(d){return J.ct(d)},
$S:139}
A.a72.prototype={
$0(){C.lE.ajp(window,"popstate",this.b)
return null},
$S:0}
A.a70.prototype={
$1(d){this.a.aR().$0()
this.b.eJ(0)},
$S:131};(function installTearOffs(){var x=a._instance_1i,w=a._instance_0i,v=a.installInstanceTearOff
var u
x(u=A.LR.prototype,"gab5","mL",1)
w(u,"gTz","kO",2)
v(u,"gaj1",1,3,null,["$3"],["tr"],0,0,0)
v(u,"gajA",1,3,null,["$3"],["jQ"],0,0,0)
x(u,"gTB","mn",3)
w(u=A.Nq.prototype,"gTq","tP",4)
x(u,"gaiR","ny",5)})();(function inheritance(){var x=a.inheritMany,w=a.inherit
x(B.x,[A.a2t,A.abf,A.aky,A.abd,A.dE])
w(A.a2u,A.a2t)
x(B.cC,[A.a2v,A.a70])
w(A.LR,A.aky)
w(A.a72,B.no)
w(A.Nq,A.LR)
w(A.a07,A.abd)})()
B.Hb(b.typeUniverse,JSON.parse("{}"))
var y={B:B.a6("y<i>"),i:B.a6("y<@>"),w:B.a6("i"),o:B.a6("cd"),D:B.a6("aX<~>"),E:B.a6("aj<~>")};(function constants(){D.yV=new A.a07()})();(function lazyInitializers(){var x=a.lazyFinal
x($,"aY7","Zs",()=>new A.abf())
x($,"b0m","aKl",()=>{var w=B.aH3().createElement("a")
return w})
x($,"b_4","aJu",()=>B.aH3().querySelector("base"))})()}
$__dart_deferred_initializers__["+GkT9yH9fSFNhL+bODROyfJLYN8="] = $__dart_deferred_initializers__.current
