self.$__dart_deferred_initializers__=self.$__dart_deferred_initializers__||Object.create(null)
$__dart_deferred_initializers__.current=function(a,b,c,$){var A={
aKT(d,e){return new A.k8(d,!1,null,null,e.i("k8<0>"))},
aKU(d,e,f){return new A.jc(!1,!1,null,d,e,f.i("jc<0>"))},
IF(d){if(d.glJ())return d.gm(d)
return null},
je:function je(){},
a_i:function a_i(d){this.a=d},
a_j:function a_j(d){this.a=d},
a_k:function a_k(d){this.a=d},
k8:function k8(d,e,f,g,h){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.$ti=h},
jd:function jd(d){this.$ti=d},
a_f:function a_f(d){this.a=d},
a_g:function a_g(d){this.a=d},
a_h:function a_h(d){this.a=d},
jc:function jc(d,e,f,g,h,i){var _=this
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
A.je.prototype={
ak4(){var x=this
return x.xw(0,new A.a_i(x),new A.a_j(x),new A.a_k(x))},
j(d){var x,w=this,v=y.h,u=B.a([],v)
if(w.gnc())u.push("isLoading: "+w.gnc())
if(w.glJ())u.push("value: "+B.o(w.gm(w)))
if(w.gmZ(w)!=null)C.c.I(u,B.a(["error: "+B.o(w.gmZ(w)),"stackTrace: "+B.o(w.gh8())],v))
x=C.c.b9(u,", ")
return B.F(w).j(0)+"("+x+")"},
l(d,e){var x=this
if(e==null)return!1
return B.F(x)===J.a3(e)&&B.l(x).i("je<1>").b(e)&&e.gnc()===x.gnc()&&e.glJ()===x.glJ()&&J.h(e.gmZ(e),x.gmZ(x))&&e.gh8()==x.gh8()&&J.h(A.IF(e),A.IF(x))},
gv(d){var x,w,v=this,u=B.F(v),t=v.gnc(),s=v.glJ(),r=A.IF(v)
if(r==null)r=0
x=v.gmZ(v)
if(x==null)x=0
w=v.gh8()
return B.a0(u,t,s,r,x,w==null?0:w,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a)}}
A.k8.prototype={
glJ(){return!0},
t7(d,e,f,g){return e.$1(this)},
xw(d,e,f,g){return this.t7(d,e,f,g,y.b)},
D5(d){return this},
gm(d){return this.a},
gnc(){return this.b},
gmZ(d){return this.c},
gh8(){return this.d}}
A.jd.prototype={
gnc(){return!0},
glJ(){return!1},
gm(d){return null},
gmZ(d){return null},
gh8(){return null},
t7(d,e,f,g){return g.$1(this)},
xw(d,e,f,g){return this.t7(d,e,f,g,y.b)},
D5(d){return d.xw(0,new A.a_f(this),new A.a_g(this),new A.a_h(this))},
j(d){return"AsyncLoading<"+B.bO(this.$ti.c).j(0)+">()"}}
A.jc.prototype={
gm(d){var x,w=this
if(!w.b){x=w.e
if(x==null)throw B.c(w.d)
D.aHo(w.d,x)}return w.c},
t7(d,e,f,g){return f.$1(this)},
xw(d,e,f,g){return this.t7(d,e,f,g,y.b)},
D5(d){var x=this,w=A.IF(d)
return new A.jc(x.a,d.glJ(),w,x.d,x.e,x.$ti)},
gnc(){return this.a},
glJ(){return this.b},
gmZ(d){return this.d},
gh8(){return this.e}}
var z=a.updateTypes([])
A.a_i.prototype={
$1(d){if(d.b)return new A.jd(B.l(this.a).i("jd<1>"))
return A.aKT(d.a,B.l(this.a).c)},
$S(){return B.l(this.a).i("je<1>(k8<1>)")}}
A.a_j.prototype={
$1(d){if(d.a)return new A.jd(B.l(this.a).i("jd<1>"))
return A.aKU(d.d,d.e,B.l(this.a).c)},
$S(){return B.l(this.a).i("je<1>(jc<1>)")}}
A.a_k.prototype={
$1(d){return d},
$S(){return B.l(this.a).i("jd<1>(jd<1>)")}}
A.a_f.prototype={
$1(d){return new A.k8(d.a,!0,d.c,d.d,this.a.$ti.i("k8<1>"))},
$S(){return this.a.$ti.i("k8<1>(k8<1>)")}}
A.a_g.prototype={
$1(d){return new A.jc(!0,d.b,A.IF(d),d.d,d.e,this.a.$ti.i("jc<1>"))},
$S(){return this.a.$ti.i("jc<1>(jc<1>)")}}
A.a_h.prototype={
$1(d){return this.a},
$S(){return this.a.$ti.i("jd<1>(jd<1>)")}};(function inheritance(){var x=a.inherit,w=a.inheritMany
x(A.je,B.x)
w(B.cB,[A.a_i,A.a_j,A.a_k,A.a_f,A.a_g,A.a_h])
w(A.je,[A.k8,A.jd,A.jc])})()
B.Ha(b.typeUniverse,JSON.parse('{"k8":{"je":["1"]},"jd":{"je":["1"]},"jc":{"je":["1"]}}'))
var y={h:B.a6("t<i>"),b:B.a6("@")}}
$__dart_deferred_initializers__["T2vhsyIotQf4Y+D4q93FHJoYg40="] = $__dart_deferred_initializers__.current
