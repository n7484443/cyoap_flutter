self.$__dart_deferred_initializers__=self.$__dart_deferred_initializers__||Object.create(null)
$__dart_deferred_initializers__.current=function(a,b,c,$){var A={
aLc(d,e){return new A.k8(d,!1,null,null,e.i("k8<0>"))},
aLd(d,e,f){return new A.jc(!1,!1,null,d,e,f.i("jc<0>"))},
IF(d){if(d.glM())return d.gm(d)
return null},
je:function je(){},
a_t:function a_t(d){this.a=d},
a_u:function a_u(d){this.a=d},
a_v:function a_v(d){this.a=d},
k8:function k8(d,e,f,g,h){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.$ti=h},
jd:function jd(d){this.$ti=d},
a_q:function a_q(d){this.a=d},
a_r:function a_r(d){this.a=d},
a_s:function a_s(d){this.a=d},
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
ak9(){var x=this
return x.xA(0,new A.a_t(x),new A.a_u(x),new A.a_v(x))},
j(d){var x,w=this,v=y.h,u=B.a([],v)
if(w.gnf())u.push("isLoading: "+w.gnf())
if(w.glM())u.push("value: "+B.o(w.gm(w)))
if(w.gn1(w)!=null)C.c.I(u,B.a(["error: "+B.o(w.gn1(w)),"stackTrace: "+B.o(w.gh9())],v))
x=C.c.b9(u,", ")
return B.F(w).j(0)+"("+x+")"},
l(d,e){var x=this
if(e==null)return!1
return B.F(x)===J.a4(e)&&B.l(x).i("je<1>").b(e)&&e.gnf()===x.gnf()&&e.glM()===x.glM()&&J.h(e.gn1(e),x.gn1(x))&&e.gh9()==x.gh9()&&J.h(A.IF(e),A.IF(x))},
gv(d){var x,w,v=this,u=B.F(v),t=v.gnf(),s=v.glM(),r=A.IF(v)
if(r==null)r=0
x=v.gn1(v)
if(x==null)x=0
w=v.gh9()
return B.a0(u,t,s,r,x,w==null?0:w,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a)}}
A.k8.prototype={
glM(){return!0},
t8(d,e,f,g){return e.$1(this)},
xA(d,e,f,g){return this.t8(d,e,f,g,y.b)},
D9(d){return this},
gm(d){return this.a},
gnf(){return this.b},
gn1(d){return this.c},
gh9(){return this.d}}
A.jd.prototype={
gnf(){return!0},
glM(){return!1},
gm(d){return null},
gn1(d){return null},
gh9(){return null},
t8(d,e,f,g){return g.$1(this)},
xA(d,e,f,g){return this.t8(d,e,f,g,y.b)},
D9(d){return d.xA(0,new A.a_q(this),new A.a_r(this),new A.a_s(this))},
j(d){return"AsyncLoading<"+B.bP(this.$ti.c).j(0)+">()"}}
A.jc.prototype={
gm(d){var x,w=this
if(!w.b){x=w.e
if(x==null)throw B.c(w.d)
D.aHI(w.d,x)}return w.c},
t8(d,e,f,g){return f.$1(this)},
xA(d,e,f,g){return this.t8(d,e,f,g,y.b)},
D9(d){var x=this,w=A.IF(d)
return new A.jc(x.a,d.glM(),w,x.d,x.e,x.$ti)},
gnf(){return this.a},
glM(){return this.b},
gn1(d){return this.d},
gh9(){return this.e}}
var z=a.updateTypes([])
A.a_t.prototype={
$1(d){if(d.b)return new A.jd(B.l(this.a).i("jd<1>"))
return A.aLc(d.a,B.l(this.a).c)},
$S(){return B.l(this.a).i("je<1>(k8<1>)")}}
A.a_u.prototype={
$1(d){if(d.a)return new A.jd(B.l(this.a).i("jd<1>"))
return A.aLd(d.d,d.e,B.l(this.a).c)},
$S(){return B.l(this.a).i("je<1>(jc<1>)")}}
A.a_v.prototype={
$1(d){return d},
$S(){return B.l(this.a).i("jd<1>(jd<1>)")}}
A.a_q.prototype={
$1(d){return new A.k8(d.a,!0,d.c,d.d,this.a.$ti.i("k8<1>"))},
$S(){return this.a.$ti.i("k8<1>(k8<1>)")}}
A.a_r.prototype={
$1(d){return new A.jc(!0,d.b,A.IF(d),d.d,d.e,this.a.$ti.i("jc<1>"))},
$S(){return this.a.$ti.i("jc<1>(jc<1>)")}}
A.a_s.prototype={
$1(d){return this.a},
$S(){return this.a.$ti.i("jd<1>(jd<1>)")}};(function inheritance(){var x=a.inherit,w=a.inheritMany
x(A.je,B.x)
w(B.cC,[A.a_t,A.a_u,A.a_v,A.a_q,A.a_r,A.a_s])
w(A.je,[A.k8,A.jd,A.jc])})()
B.Hb(b.typeUniverse,JSON.parse('{"k8":{"je":["1"]},"jd":{"je":["1"]},"jc":{"je":["1"]}}'))
var y={h:B.a6("t<i>"),b:B.a6("@")}}
$__dart_deferred_initializers__["ZYOrm0YIGYSGFpXHsbv5XfE9SZ4="] = $__dart_deferred_initializers__.current
