self.$__dart_deferred_initializers__=self.$__dart_deferred_initializers__||Object.create(null)
$__dart_deferred_initializers__.current=function(a,b,c,$){var A={
aOG(d,e){return new A.kD(d,!1,null,null,e.i("kD<0>"))},
aOH(d,e,f){return new A.jE(!1,!1,null,d,e,f.i("jE<0>"))},
K0(d){if(d.gmG())return d.gm(d)
return null},
jG:function jG(){},
a1q:function a1q(d){this.a=d},
a1r:function a1r(d){this.a=d},
a1s:function a1s(d){this.a=d},
kD:function kD(d,e,f,g,h){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.$ti=h},
jF:function jF(d){this.$ti=d},
a1n:function a1n(d){this.a=d},
a1o:function a1o(d){this.a=d},
a1p:function a1p(d){this.a=d},
jE:function jE(d,e,f,g,h,i){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.$ti=i}},B,C,J,D
A=a.updateHolder(c[7],A)
B=c[0]
C=c[2]
J=c[1]
D=c[8]
A.jG.prototype={
aq1(){var x=this
return x.zk(0,new A.a1q(x),new A.a1r(x),new A.a1s(x))},
j(d){var x,w=this,v=y.h,u=B.a([],v)
if(w.gof())u.push("isLoading: "+w.gof())
if(w.gmG())u.push("value: "+B.o(w.gm(w)))
if(w.go1(w)!=null)C.c.M(u,B.a(["error: "+B.o(w.go1(w)),"stackTrace: "+B.o(w.ghJ())],v))
x=C.c.bp(u,", ")
return B.F(w).j(0)+"("+x+")"},
l(d,e){var x=this
if(e==null)return!1
return B.F(x)===J.a2(e)&&B.k(x).i("jG<1>").b(e)&&e.gof()===x.gof()&&e.gmG()===x.gmG()&&J.f(e.go1(e),x.go1(x))&&e.ghJ()==x.ghJ()&&J.f(A.K0(e),A.K0(x))},
gA(d){var x,w,v=this,u=B.F(v),t=v.gof(),s=v.gmG(),r=A.K0(v)
if(r==null)r=0
x=v.go1(v)
if(x==null)x=0
w=v.ghJ()
return B.Z(u,t,s,r,x,w==null?0:w,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a)}}
A.kD.prototype={
gmG(){return!0},
uo(d,e,f,g){return e.$1(this)},
zk(d,e,f,g){return this.uo(d,e,f,g,y.b)},
Fh(d){return this},
gm(d){return this.a},
gof(){return this.b},
go1(d){return this.c},
ghJ(){return this.d}}
A.jF.prototype={
gof(){return!0},
gmG(){return!1},
gm(d){return null},
go1(d){return null},
ghJ(){return null},
uo(d,e,f,g){return g.$1(this)},
zk(d,e,f,g){return this.uo(d,e,f,g,y.b)},
Fh(d){return d.zk(0,new A.a1n(this),new A.a1o(this),new A.a1p(this))},
j(d){return"AsyncLoading<"+B.bV(this.$ti.c).j(0)+">()"}}
A.jE.prototype={
gm(d){var x,w=this
if(!w.b){x=w.e
if(x==null)throw B.c(w.d)
D.aL9(w.d,x)}return w.c},
uo(d,e,f,g){return f.$1(this)},
zk(d,e,f,g){return this.uo(d,e,f,g,y.b)},
Fh(d){var x=this,w=A.K0(d)
return new A.jE(x.a,d.gmG(),w,x.d,x.e,x.$ti)},
gof(){return this.a},
gmG(){return this.b},
go1(d){return this.d},
ghJ(){return this.e}}
var z=a.updateTypes([])
A.a1q.prototype={
$1(d){if(d.b)return new A.jF(B.k(this.a).i("jF<1>"))
return A.aOG(d.a,B.k(this.a).c)},
$S(){return B.k(this.a).i("jG<1>(kD<1>)")}}
A.a1r.prototype={
$1(d){if(d.a)return new A.jF(B.k(this.a).i("jF<1>"))
return A.aOH(d.d,d.e,B.k(this.a).c)},
$S(){return B.k(this.a).i("jG<1>(jE<1>)")}}
A.a1s.prototype={
$1(d){return d},
$S(){return B.k(this.a).i("jF<1>(jF<1>)")}}
A.a1n.prototype={
$1(d){return new A.kD(d.a,!0,d.c,d.d,this.a.$ti.i("kD<1>"))},
$S(){return this.a.$ti.i("kD<1>(kD<1>)")}}
A.a1o.prototype={
$1(d){return new A.jE(!0,d.b,A.K0(d),d.d,d.e,this.a.$ti.i("jE<1>"))},
$S(){return this.a.$ti.i("jE<1>(jE<1>)")}}
A.a1p.prototype={
$1(d){return this.a},
$S(){return this.a.$ti.i("jF<1>(jF<1>)")}};(function inheritance(){var x=a.inherit,w=a.inheritMany
x(A.jG,B.x)
w(B.cQ,[A.a1q,A.a1r,A.a1s,A.a1n,A.a1o,A.a1p])
w(A.jG,[A.kD,A.jF,A.jE])})()
B.Ir(b.typeUniverse,JSON.parse('{"kD":{"jG":["1"]},"jF":{"jG":["1"]},"jE":{"jG":["1"]}}'))
var y={h:B.a7("p<i>"),b:B.a7("@")}}
$__dart_deferred_initializers__["1TbH4pJoTjjksMiTL/OmJLw/A8Y="] = $__dart_deferred_initializers__.current
