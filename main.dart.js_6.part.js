self.$__dart_deferred_initializers__=self.$__dart_deferred_initializers__||Object.create(null)
$__dart_deferred_initializers__.current=function(a,b,c,$){var A={
aKR(d,e){return new A.k8(d,!1,null,null,e.i("k8<0>"))},
aKS(d,e,f){return new A.jd(!1,!1,null,d,e,f.i("jd<0>"))},
ID(d){if(d.glK())return d.gm(d)
return null},
jf:function jf(){},
a_i:function a_i(d){this.a=d},
a_j:function a_j(d){this.a=d},
a_k:function a_k(d){this.a=d},
k8:function k8(d,e,f,g,h){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.$ti=h},
je:function je(d){this.$ti=d},
a_f:function a_f(d){this.a=d},
a_g:function a_g(d){this.a=d},
a_h:function a_h(d){this.a=d},
jd:function jd(d,e,f,g,h,i){var _=this
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
A.jf.prototype={
ak4(){var x=this
return x.xx(0,new A.a_i(x),new A.a_j(x),new A.a_k(x))},
j(d){var x,w=this,v=y.h,u=B.a([],v)
if(w.gnd())u.push("isLoading: "+w.gnd())
if(w.glK())u.push("value: "+B.o(w.gm(w)))
if(w.gn_(w)!=null)C.c.I(u,B.a(["error: "+B.o(w.gn_(w)),"stackTrace: "+B.o(w.gh8())],v))
x=C.c.b9(u,", ")
return B.F(w).j(0)+"("+x+")"},
l(d,e){var x=this
if(e==null)return!1
return B.F(x)===J.a3(e)&&B.l(x).i("jf<1>").b(e)&&e.gnd()===x.gnd()&&e.glK()===x.glK()&&J.h(e.gn_(e),x.gn_(x))&&e.gh8()==x.gh8()&&J.h(A.ID(e),A.ID(x))},
gv(d){var x,w,v=this,u=B.F(v),t=v.gnd(),s=v.glK(),r=A.ID(v)
if(r==null)r=0
x=v.gn_(v)
if(x==null)x=0
w=v.gh8()
return B.a0(u,t,s,r,x,w==null?0:w,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a)}}
A.k8.prototype={
glK(){return!0},
t8(d,e,f,g){return e.$1(this)},
xx(d,e,f,g){return this.t8(d,e,f,g,y.b)},
D6(d){return this},
gm(d){return this.a},
gnd(){return this.b},
gn_(d){return this.c},
gh8(){return this.d}}
A.je.prototype={
gnd(){return!0},
glK(){return!1},
gm(d){return null},
gn_(d){return null},
gh8(){return null},
t8(d,e,f,g){return g.$1(this)},
xx(d,e,f,g){return this.t8(d,e,f,g,y.b)},
D6(d){return d.xx(0,new A.a_f(this),new A.a_g(this),new A.a_h(this))},
j(d){return"AsyncLoading<"+B.bO(this.$ti.c).j(0)+">()"}}
A.jd.prototype={
gm(d){var x,w=this
if(!w.b){x=w.e
if(x==null)throw B.c(w.d)
D.aHm(w.d,x)}return w.c},
t8(d,e,f,g){return f.$1(this)},
xx(d,e,f,g){return this.t8(d,e,f,g,y.b)},
D6(d){var x=this,w=A.ID(d)
return new A.jd(x.a,d.glK(),w,x.d,x.e,x.$ti)},
gnd(){return this.a},
glK(){return this.b},
gn_(d){return this.d},
gh8(){return this.e}}
var z=a.updateTypes([])
A.a_i.prototype={
$1(d){if(d.b)return new A.je(B.l(this.a).i("je<1>"))
return A.aKR(d.a,B.l(this.a).c)},
$S(){return B.l(this.a).i("jf<1>(k8<1>)")}}
A.a_j.prototype={
$1(d){if(d.a)return new A.je(B.l(this.a).i("je<1>"))
return A.aKS(d.d,d.e,B.l(this.a).c)},
$S(){return B.l(this.a).i("jf<1>(jd<1>)")}}
A.a_k.prototype={
$1(d){return d},
$S(){return B.l(this.a).i("je<1>(je<1>)")}}
A.a_f.prototype={
$1(d){return new A.k8(d.a,!0,d.c,d.d,this.a.$ti.i("k8<1>"))},
$S(){return this.a.$ti.i("k8<1>(k8<1>)")}}
A.a_g.prototype={
$1(d){return new A.jd(!0,d.b,A.ID(d),d.d,d.e,this.a.$ti.i("jd<1>"))},
$S(){return this.a.$ti.i("jd<1>(jd<1>)")}}
A.a_h.prototype={
$1(d){return this.a},
$S(){return this.a.$ti.i("je<1>(je<1>)")}};(function inheritance(){var x=a.inherit,w=a.inheritMany
x(A.jf,B.x)
w(B.cB,[A.a_i,A.a_j,A.a_k,A.a_f,A.a_g,A.a_h])
w(A.jf,[A.k8,A.je,A.jd])})()
B.H8(b.typeUniverse,JSON.parse('{"k8":{"jf":["1"]},"je":{"jf":["1"]},"jd":{"jf":["1"]}}'))
var y={h:B.a6("t<i>"),b:B.a6("@")}}
$__dart_deferred_initializers__["bdLRH8gGqBWAswB/gisR+xdqXp0="] = $__dart_deferred_initializers__.current
