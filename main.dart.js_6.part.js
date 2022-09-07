self.$__dart_deferred_initializers__=self.$__dart_deferred_initializers__||Object.create(null)
$__dart_deferred_initializers__.current=function(a,b,c,$){var A={
aRD(d,e){return new A.l9(d,!1,null,null,e.i("l9<0>"))},
aRE(d,e,f){return new A.ka(!1,!1,null,d,e,f.i("ka<0>"))},
PC(d){if(d.gmN())return d.gl(d)
return null},
ds:function ds(){},
a9Q:function a9Q(d){this.a=d},
a9R:function a9R(d){this.a=d},
a9S:function a9S(d){this.a=d},
l9:function l9(d,e,f,g,h){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.$ti=h},
fZ:function fZ(d){this.$ti=d},
a9N:function a9N(d){this.a=d},
a9O:function a9O(d){this.a=d},
a9P:function a9P(d){this.a=d},
ka:function ka(d,e,f,g,h,i){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.$ti=i},
Be:function Be(){},
aEX:function aEX(d){this.a=d},
aEY:function aEY(d,e){this.a=d
this.b=e},
aEZ:function aEZ(d,e){this.a=d
this.b=e}},B,C,J,E,D
A=a.updateHolder(c[9],A)
B=c[0]
C=c[2]
J=c[1]
E=c[10]
D=c[13]
A.ds.prototype={
aCi(){var x=this
return x.xn(0,new A.a9Q(x),new A.a9R(x),new A.a9S(x))},
j(d){var x,w=this,v=y.h,u=B.a([],v)
if(w.gmS())u.push("isLoading: "+w.gmS())
if(w.gmN())u.push("value: "+B.o(w.gl(w)))
if(w.go4(w)!=null)C.c.V(u,B.a(["error: "+B.o(w.go4(w)),"stackTrace: "+B.o(w.giQ())],v))
x=C.c.bx(u,", ")
return B.M(w).j(0)+"("+x+")"},
m(d,e){var x=this
if(e==null)return!1
return B.M(x)===J.af(e)&&B.m(x).i("ds<1>").b(e)&&e.gmS()===x.gmS()&&e.gmN()===x.gmN()&&J.h(e.go4(e),x.go4(x))&&e.giQ()==x.giQ()&&J.h(A.PC(e),A.PC(x))},
gC(d){var x,w,v=this,u=B.M(v),t=v.gmS(),s=v.gmN(),r=A.PC(v)
if(r==null)r=0
x=v.go4(v)
if(x==null)x=0
w=v.giQ()
return B.ae(u,t,s,r,x,w==null?0:w,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a)}}
A.l9.prototype={
gmN(){return!0},
xm(d,e,f,g){return e.$1(this)},
xn(d,e,f,g){return this.xm(d,e,f,g,y.b)},
JP(d){return this},
gl(d){return this.a},
gmS(){return this.b},
go4(d){return this.c},
giQ(){return this.d}}
A.fZ.prototype={
gmS(){return!0},
gmN(){return!1},
gl(d){return null},
go4(d){return null},
giQ(){return null},
xm(d,e,f,g){return g.$1(this)},
xn(d,e,f,g){return this.xm(d,e,f,g,y.b)},
JP(d){return d.xn(0,new A.a9N(this),new A.a9O(this),new A.a9P(this))},
j(d){return"AsyncLoading<"+B.ca(this.$ti.c).j(0)+">()"}}
A.ka.prototype={
gl(d){var x,w=this
if(!w.b){x=w.e
if(x==null)throw B.c(w.d)
E.b3n(w.d,x)}return w.c},
xm(d,e,f,g){return f.$1(this)},
xn(d,e,f,g){return this.xm(d,e,f,g,y.b)},
JP(d){var x=this,w=A.PC(d)
return new A.ka(x.a,d.gmN(),w,x.d,x.e,x.$ti)},
gmS(){return this.a},
gmN(){return this.b},
go4(d){return this.d},
giQ(){return this.e}}
A.Be.prototype={
Tg(d){var x,w,v,u,t,s=this,r={}
r.a=!0
s.f2(new A.aEX(r))
try{x=d.$0()
u=B.m(s)
if(u.i("a1<1>").b(x)){s.a3(new A.fZ(u.i("fZ<1>")))
x.hi(new A.aEY(r,s),new A.aEZ(r,s),y.p)}else{r=A.aRD(x,u.c)
return r}r=s.ghB()
return r}catch(t){w=B.ac(t)
v=B.ap(t)
r=A.aRE(w,v,B.m(s).c)
return r}}}
var z=a.updateTypes([])
A.a9Q.prototype={
$1(d){if(d.b)return new A.fZ(B.m(this.a).i("fZ<1>"))
return A.aRD(d.a,B.m(this.a).c)},
$S(){return B.m(this.a).i("ds<1>(l9<1>)")}}
A.a9R.prototype={
$1(d){if(d.a)return new A.fZ(B.m(this.a).i("fZ<1>"))
return A.aRE(d.d,d.e,B.m(this.a).c)},
$S(){return B.m(this.a).i("ds<1>(ka<1>)")}}
A.a9S.prototype={
$1(d){return d},
$S(){return B.m(this.a).i("fZ<1>(fZ<1>)")}}
A.a9N.prototype={
$1(d){return new A.l9(d.a,!0,d.c,d.d,this.a.$ti.i("l9<1>"))},
$S(){return this.a.$ti.i("l9<1>(l9<1>)")}}
A.a9O.prototype={
$1(d){return new A.ka(!0,d.b,A.PC(d),d.d,d.e,this.a.$ti.i("ka<1>"))},
$S(){return this.a.$ti.i("ka<1>(ka<1>)")}}
A.a9P.prototype={
$1(d){return this.a},
$S(){return this.a.$ti.i("fZ<1>(fZ<1>)")}}
A.aEX.prototype={
$0(){return this.a.a=!1},
$S:0}
A.aEY.prototype={
$1(d){var x
if(this.a.a){x=this.b
x.a3(A.aRD(d,B.m(x).c))}},
$S(){return B.m(this.b).i("aq(1)")}}
A.aEZ.prototype={
$2(d,e){var x
if(this.a.a){x=this.b
x.a3(A.aRE(d,e,B.m(x).c))}},
$S:43};(function inheritance(){var x=a.inheritMany,w=a.inherit
x(B.x,[A.ds,A.Be])
x(B.dm,[A.a9Q,A.a9R,A.a9S,A.a9N,A.a9O,A.a9P,A.aEY])
x(A.ds,[A.l9,A.fZ,A.ka])
w(A.aEX,B.lf)
w(A.aEZ,B.lg)})()
B.wq(b.typeUniverse,JSON.parse('{"l9":{"ds":["1"]},"fZ":{"ds":["1"]},"ka":{"ds":["1"]}}'))
var y={h:B.a9("p<f>"),p:B.a9("aq"),b:B.a9("@")};(function constants(){D.NR=new B.by(57785,!1)
D.hj=new B.dg(D.NR,null,null,null)})()}
$__dart_deferred_initializers__["DG7Z3kuyM86QEwhHhR1NWKNzHrY="] = $__dart_deferred_initializers__.current
