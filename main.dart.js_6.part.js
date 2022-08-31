self.$__dart_deferred_initializers__=self.$__dart_deferred_initializers__||Object.create(null)
$__dart_deferred_initializers__.current=function(a,b,c,$){var A={
b3Z(d,e){return new A.mC(d,!1,null,null,e.i("mC<0>"))},
b4_(d,e,f){return new A.lo(!1,!1,null,d,e,f.i("lo<0>"))},
UH(d){if(d.gnB())return d.gk(d)
return null},
e1:function e1(){},
ahd:function ahd(d){this.a=d},
ahe:function ahe(d){this.a=d},
ahf:function ahf(d){this.a=d},
mC:function mC(d,e,f,g,h){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.$ti=h},
hT:function hT(d){this.$ti=d},
aha:function aha(d){this.a=d},
ahb:function ahb(d){this.a=d},
ahc:function ahc(d){this.a=d},
lo:function lo(d,e,f,g,h,i){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.$ti=i},
ES:function ES(){},
aPf:function aPf(d){this.a=d},
aPg:function aPg(d,e){this.a=d
this.b=e},
aPh:function aPh(d,e){this.a=d
this.b=e}},B,C,J,E,D
A=a.updateHolder(c[9],A)
B=c[0]
C=c[2]
J=c[1]
E=c[10]
D=c[13]
A.e1.prototype={
aJJ(){var x=this
return x.z9(0,new A.ahd(x),new A.ahe(x),new A.ahf(x))},
j(d){var x,w=this,v=y.h,u=B.a([],v)
if(w.gnF())u.push("isLoading: "+w.gnF())
if(w.gnB())u.push("value: "+B.m(w.gk(w)))
if(w.gmr(w)!=null)C.d.P(u,B.a(["error: "+B.m(w.gmr(w)),"stackTrace: "+B.m(w.gjv())],v))
x=C.d.bH(u,", ")
return B.M(w).j(0)+"("+x+")"},
l(d,e){var x=this
if(e==null)return!1
return B.M(x)===J.ah(e)&&B.o(x).i("e1<1>").b(e)&&e.gnF()===x.gnF()&&e.gnB()===x.gnB()&&J.k(e.gmr(e),x.gmr(x))&&e.gjv()==x.gjv()&&J.k(A.UH(e),A.UH(x))},
gC(d){var x,w,v=this,u=B.M(v),t=v.gnF(),s=v.gnB(),r=A.UH(v)
if(r==null)r=0
x=v.gmr(v)
if(x==null)x=0
w=v.gjv()
return B.ab(u,t,s,r,x,w==null?0:w,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a)}}
A.mC.prototype={
gnB(){return!0},
z8(d,e,f,g){return e.$1(this)},
z9(d,e,f,g){return this.z8(d,e,f,g,y.b)},
MB(d){return this},
gk(d){return this.a},
gnF(){return this.b},
gmr(d){return this.c},
gjv(){return this.d}}
A.hT.prototype={
gnF(){return!0},
gnB(){return!1},
gk(d){return null},
gmr(d){return null},
gjv(){return null},
z8(d,e,f,g){return g.$1(this)},
z9(d,e,f,g){return this.z8(d,e,f,g,y.b)},
MB(d){return d.z9(0,new A.aha(this),new A.ahb(this),new A.ahc(this))},
j(d){return"AsyncLoading<"+B.cB(this.$ti.c).j(0)+">()"}}
A.lo.prototype={
gk(d){var x,w=this
if(!w.b){x=w.e
if(x==null)throw B.e(w.d)
E.bie(w.d,x)}return w.c},
z8(d,e,f,g){return f.$1(this)},
z9(d,e,f,g){return this.z8(d,e,f,g,y.b)},
MB(d){var x=this,w=A.UH(d)
return new A.lo(x.a,d.gnB(),w,x.d,x.e,x.$ti)},
gnF(){return this.a},
gnB(){return this.b},
gmr(d){return this.d},
gjv(){return this.e}}
A.ES.prototype={
WB(d){var x,w,v,u,t,s=this,r={}
r.a=!0
s.h8(new A.aPf(r))
try{x=d.$0()
u=B.o(s)
if(u.i("aa<1>").b(x)){s.Y(new A.hT(u.i("hT<1>")))
x.hB(new A.aPg(r,s),new A.aPh(r,s),y.p)}else{r=A.b3Z(x,u.c)
return r}r=s.giS()
return r}catch(t){w=B.ar(t)
v=B.b_(t)
r=A.b4_(w,v,B.o(s).c)
return r}}}
var z=a.updateTypes([])
A.ahd.prototype={
$1(d){if(d.b)return new A.hT(B.o(this.a).i("hT<1>"))
return A.b3Z(d.a,B.o(this.a).c)},
$S(){return B.o(this.a).i("e1<1>(mC<1>)")}}
A.ahe.prototype={
$1(d){if(d.a)return new A.hT(B.o(this.a).i("hT<1>"))
return A.b4_(d.d,d.e,B.o(this.a).c)},
$S(){return B.o(this.a).i("e1<1>(lo<1>)")}}
A.ahf.prototype={
$1(d){return d},
$S(){return B.o(this.a).i("hT<1>(hT<1>)")}}
A.aha.prototype={
$1(d){return new A.mC(d.a,!0,d.c,d.d,this.a.$ti.i("mC<1>"))},
$S(){return this.a.$ti.i("mC<1>(mC<1>)")}}
A.ahb.prototype={
$1(d){return new A.lo(!0,d.b,A.UH(d),d.d,d.e,this.a.$ti.i("lo<1>"))},
$S(){return this.a.$ti.i("lo<1>(lo<1>)")}}
A.ahc.prototype={
$1(d){return this.a},
$S(){return this.a.$ti.i("hT<1>(hT<1>)")}}
A.aPf.prototype={
$0(){return this.a.a=!1},
$S:0}
A.aPg.prototype={
$1(d){var x
if(this.a.a){x=this.b
x.Y(A.b3Z(d,B.o(x).c))}},
$S(){return B.o(this.b).i("aD(1)")}}
A.aPh.prototype={
$2(d,e){var x
if(this.a.a){x=this.b
x.Y(A.b4_(d,e,B.o(x).c))}},
$S:41};(function inheritance(){var x=a.inheritMany,w=a.inherit
x(B.A,[A.e1,A.ES])
x(B.e3,[A.ahd,A.ahe,A.ahf,A.aha,A.ahb,A.ahc,A.aPg])
x(A.e1,[A.mC,A.hT,A.lo])
w(A.aPf,B.mG)
w(A.aPh,B.o0)})()
B.zw(b.typeUniverse,JSON.parse('{"mC":{"e1":["1"]},"hT":{"e1":["1"]},"lo":{"e1":["1"]}}'))
var y={h:B.Z("r<i>"),p:B.Z("aD"),b:B.Z("@")};(function constants(){D.av2=new B.bv(57785,"MaterialIcons",null,!1)
D.lB=new B.d9(D.av2,null,null,null)})()}
$__dart_deferred_initializers__["K5zpBx21MRS29S0xG8NJiGzbJ4w="] = $__dart_deferred_initializers__.current
