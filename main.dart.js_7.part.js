self.$__dart_deferred_initializers__=self.$__dart_deferred_initializers__||Object.create(null)
$__dart_deferred_initializers__.current=function(a,b,c,$){var A={
aS2(d,e){return new A.le(d,!1,null,null,e.i("le<0>"))},
aS3(d,e,f){return new A.kd(!1,!1,null,d,e,f.i("kd<0>"))},
PY(d){if(d.gmK())return d.gl(d)
return null},
dk:function dk(){},
aaa:function aaa(d){this.a=d},
aab:function aab(d){this.a=d},
aac:function aac(d){this.a=d},
le:function le(d,e,f,g,h){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.$ti=h},
h3:function h3(d){this.$ti=d},
aa7:function aa7(d){this.a=d},
aa8:function aa8(d){this.a=d},
aa9:function aa9(d){this.a=d},
kd:function kd(d,e,f,g,h,i){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.$ti=i},
Bo:function Bo(){},
aFj:function aFj(d){this.a=d},
aFk:function aFk(d,e){this.a=d
this.b=e},
aFl:function aFl(d,e){this.a=d
this.b=e}},B,C,J,E,D
A=a.updateHolder(c[9],A)
B=c[0]
C=c[2]
J=c[1]
E=c[10]
D=c[13]
A.dk.prototype={
aCL(){var x=this
return x.xq(0,new A.aaa(x),new A.aab(x),new A.aac(x))},
j(d){var x,w=this,v=y.h,u=B.a([],v)
if(w.gmP())u.push("isLoading: "+w.gmP())
if(w.gmK())u.push("value: "+B.o(w.gl(w)))
if(w.go1(w)!=null)C.c.V(u,B.a(["error: "+B.o(w.go1(w)),"stackTrace: "+B.o(w.giQ())],v))
x=C.c.by(u,", ")
return B.M(w).j(0)+"("+x+")"},
m(d,e){var x=this
if(e==null)return!1
return B.M(x)===J.ae(e)&&B.m(x).i("dk<1>").b(e)&&e.gmP()===x.gmP()&&e.gmK()===x.gmK()&&J.h(e.go1(e),x.go1(x))&&e.giQ()==x.giQ()&&J.h(A.PY(e),A.PY(x))},
gD(d){var x,w,v=this,u=B.M(v),t=v.gmP(),s=v.gmK(),r=A.PY(v)
if(r==null)r=0
x=v.go1(v)
if(x==null)x=0
w=v.giQ()
return B.ad(u,t,s,r,x,w==null?0:w,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a)}}
A.le.prototype={
gmK(){return!0},
xp(d,e,f,g){return e.$1(this)},
xq(d,e,f,g){return this.xp(d,e,f,g,y.b)},
K5(d){return this},
gl(d){return this.a},
gmP(){return this.b},
go1(d){return this.c},
giQ(){return this.d}}
A.h3.prototype={
gmP(){return!0},
gmK(){return!1},
gl(d){return null},
go1(d){return null},
giQ(){return null},
xp(d,e,f,g){return g.$1(this)},
xq(d,e,f,g){return this.xp(d,e,f,g,y.b)},
K5(d){return d.xq(0,new A.aa7(this),new A.aa8(this),new A.aa9(this))},
j(d){return"AsyncLoading<"+B.ce(this.$ti.c).j(0)+">()"}}
A.kd.prototype={
gl(d){var x,w=this
if(!w.b){x=w.e
if(x==null)throw B.c(w.d)
E.b4_(w.d,x)}return w.c},
xp(d,e,f,g){return f.$1(this)},
xq(d,e,f,g){return this.xp(d,e,f,g,y.b)},
K5(d){var x=this,w=A.PY(d)
return new A.kd(x.a,d.gmK(),w,x.d,x.e,x.$ti)},
gmP(){return this.a},
gmK(){return this.b},
go1(d){return this.d},
giQ(){return this.e}}
A.Bo.prototype={
Tq(d){var x,w,v,u,t,s=this,r={}
r.a=!0
s.eS(new A.aFj(r))
try{x=d.$0()
u=B.m(s)
if(u.i("a2<1>").b(x)){s.a4(new A.h3(u.i("h3<1>")))
x.hk(new A.aFk(r,s),new A.aFl(r,s),y.p)}else{r=A.aS2(x,u.c)
return r}r=s.gic()
return r}catch(t){w=B.ac(t)
v=B.ap(t)
r=A.aS3(w,v,B.m(s).c)
return r}}}
var z=a.updateTypes([])
A.aaa.prototype={
$1(d){if(d.b)return new A.h3(B.m(this.a).i("h3<1>"))
return A.aS2(d.a,B.m(this.a).c)},
$S(){return B.m(this.a).i("dk<1>(le<1>)")}}
A.aab.prototype={
$1(d){if(d.a)return new A.h3(B.m(this.a).i("h3<1>"))
return A.aS3(d.d,d.e,B.m(this.a).c)},
$S(){return B.m(this.a).i("dk<1>(kd<1>)")}}
A.aac.prototype={
$1(d){return d},
$S(){return B.m(this.a).i("h3<1>(h3<1>)")}}
A.aa7.prototype={
$1(d){return new A.le(d.a,!0,d.c,d.d,this.a.$ti.i("le<1>"))},
$S(){return this.a.$ti.i("le<1>(le<1>)")}}
A.aa8.prototype={
$1(d){return new A.kd(!0,d.b,A.PY(d),d.d,d.e,this.a.$ti.i("kd<1>"))},
$S(){return this.a.$ti.i("kd<1>(kd<1>)")}}
A.aa9.prototype={
$1(d){return this.a},
$S(){return this.a.$ti.i("h3<1>(h3<1>)")}}
A.aFj.prototype={
$0(){return this.a.a=!1},
$S:0}
A.aFk.prototype={
$1(d){var x
if(this.a.a){x=this.b
x.a4(A.aS2(d,B.m(x).c))}},
$S(){return B.m(this.b).i("aq(1)")}}
A.aFl.prototype={
$2(d,e){var x
if(this.a.a){x=this.b
x.a4(A.aS3(d,e,B.m(x).c))}},
$S:45};(function inheritance(){var x=a.inheritMany,w=a.inherit
x(B.w,[A.dk,A.Bo])
x(B.dl,[A.aaa,A.aab,A.aac,A.aa7,A.aa8,A.aa9,A.aFk])
x(A.dk,[A.le,A.h3,A.kd])
w(A.aFj,B.lj)
w(A.aFl,B.lk)})()
B.wv(b.typeUniverse,JSON.parse('{"le":{"dk":["1"]},"h3":{"dk":["1"]},"kd":{"dk":["1"]}}'))
var y={h:B.a8("p<f>"),p:B.a8("aq"),b:B.a8("@")};(function constants(){D.OJ=new B.bz(57785,!1)
D.hr=new B.de(D.OJ,null,null,null)
D.P6=new B.bz(58751,!1)
D.eY=new B.de(D.P6,null,null,null)})()}
$__dart_deferred_initializers__["HzXANlQv+CtXhnFtgTrCuLfSJjM="] = $__dart_deferred_initializers__.current
