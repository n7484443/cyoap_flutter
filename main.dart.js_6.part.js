self.$__dart_deferred_initializers__=self.$__dart_deferred_initializers__||Object.create(null)
$__dart_deferred_initializers__.current=function(a,b,c,$){var A={
b0o(d,e){return new A.mj(d,!1,null,null,e.i("mj<0>"))},
b0p(d,e,f){return new A.l5(!1,!1,null,d,e,f.i("l5<0>"))},
Uo(d){if(d.gnq())return d.gk(d)
return null},
dL:function dL(){},
afr:function afr(d){this.a=d},
afs:function afs(d){this.a=d},
aft:function aft(d){this.a=d},
mj:function mj(d,e,f,g,h){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.$ti=h},
hE:function hE(d){this.$ti=d},
afo:function afo(d){this.a=d},
afp:function afp(d){this.a=d},
afq:function afq(d){this.a=d},
l5:function l5(d,e,f,g,h,i){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.$ti=i},
ES:function ES(){},
aLm:function aLm(d){this.a=d},
aLn:function aLn(d,e){this.a=d
this.b=e},
aLo:function aLo(d,e){this.a=d
this.b=e}},B,C,J,E,D
A=a.updateHolder(c[8],A)
B=c[0]
C=c[2]
J=c[1]
E=c[9]
D=c[13]
A.dL.prototype={
aJz(){var x=this
return x.yT(0,new A.afr(x),new A.afs(x),new A.aft(x))},
j(d){var x,w=this,v=y.h,u=B.b([],v)
if(w.gns())u.push("isLoading: "+w.gns())
if(w.gnq())u.push("value: "+B.n(w.gk(w)))
if(w.gmd(w)!=null)C.d.T(u,B.b(["error: "+B.n(w.gmd(w)),"stackTrace: "+B.n(w.gjq())],v))
x=C.d.bA(u,", ")
return B.N(w).j(0)+"("+x+")"},
l(d,e){var x=this
if(e==null)return!1
return B.N(x)===J.aj(e)&&B.o(x).i("dL<1>").b(e)&&e.gns()===x.gns()&&e.gnq()===x.gnq()&&J.k(e.gmd(e),x.gmd(x))&&e.gjq()==x.gjq()&&J.k(A.Uo(e),A.Uo(x))},
gC(d){var x,w,v=this,u=B.N(v),t=v.gns(),s=v.gnq(),r=A.Uo(v)
if(r==null)r=0
x=v.gmd(v)
if(x==null)x=0
w=v.gjq()
return B.ak(u,t,s,r,x,w==null?0:w,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a)}}
A.mj.prototype={
gnq(){return!0},
yS(d,e,f,g){return e.$1(this)},
yT(d,e,f,g){return this.yS(d,e,f,g,y.b)},
LN(d){return this},
gk(d){return this.a},
gns(){return this.b},
gmd(d){return this.c},
gjq(){return this.d}}
A.hE.prototype={
gns(){return!0},
gnq(){return!1},
gk(d){return null},
gmd(d){return null},
gjq(){return null},
yS(d,e,f,g){return g.$1(this)},
yT(d,e,f,g){return this.yS(d,e,f,g,y.b)},
LN(d){return d.yT(0,new A.afo(this),new A.afp(this),new A.afq(this))},
j(d){return"AsyncLoading<"+B.cs(this.$ti.c).j(0)+">()"}}
A.l5.prototype={
gk(d){var x,w=this
if(!w.b){x=w.e
if(x==null)throw B.e(w.d)
E.bh_(w.d,x)}return w.c},
yS(d,e,f,g){return f.$1(this)},
yT(d,e,f,g){return this.yS(d,e,f,g,y.b)},
LN(d){var x=this,w=A.Uo(d)
return new A.l5(x.a,d.gnq(),w,x.d,x.e,x.$ti)},
gns(){return this.a},
gnq(){return this.b},
gmd(d){return this.d},
gjq(){return this.e}}
A.ES.prototype={
Yg(d){var x,w,v,u,t,s=this,r={}
r.a=!0
s.h2(new A.aLm(r))
try{x=d.$0()
u=B.o(s)
if(u.i("aa<1>").b(x)){s.a1(new A.hE(u.i("hE<1>")))
J.b07(x,new A.aLn(r,s),new A.aLo(r,s),y.p)}else{r=A.b0o(x,u.c)
return r}r=s.giM()
return r}catch(t){w=B.ar(t)
v=B.aU(t)
r=A.b0p(w,v,B.o(s).c)
return r}}}
var z=a.updateTypes([])
A.afr.prototype={
$1(d){if(d.b)return new A.hE(B.o(this.a).i("hE<1>"))
return A.b0o(d.a,B.o(this.a).c)},
$S(){return B.o(this.a).i("dL<1>(mj<1>)")}}
A.afs.prototype={
$1(d){if(d.a)return new A.hE(B.o(this.a).i("hE<1>"))
return A.b0p(d.d,d.e,B.o(this.a).c)},
$S(){return B.o(this.a).i("dL<1>(l5<1>)")}}
A.aft.prototype={
$1(d){return d},
$S(){return B.o(this.a).i("hE<1>(hE<1>)")}}
A.afo.prototype={
$1(d){return new A.mj(d.a,!0,d.c,d.d,this.a.$ti.i("mj<1>"))},
$S(){return this.a.$ti.i("mj<1>(mj<1>)")}}
A.afp.prototype={
$1(d){return new A.l5(!0,d.b,A.Uo(d),d.d,d.e,this.a.$ti.i("l5<1>"))},
$S(){return this.a.$ti.i("l5<1>(l5<1>)")}}
A.afq.prototype={
$1(d){return this.a},
$S(){return this.a.$ti.i("hE<1>(hE<1>)")}}
A.aLm.prototype={
$0(){return this.a.a=!1},
$S:0}
A.aLn.prototype={
$1(d){var x
if(this.a.a){x=this.b
x.a1(A.b0o(d,B.o(x).c))}},
$S(){return B.o(this.b).i("aw(1)")}}
A.aLo.prototype={
$2(d,e){var x
if(this.a.a){x=this.b
x.a1(A.b0p(d,e,B.o(x).c))}},
$S:41};(function inheritance(){var x=a.inheritMany,w=a.inherit
x(B.B,[A.dL,A.ES])
x(B.dN,[A.afr,A.afs,A.aft,A.afo,A.afp,A.afq,A.aLn])
x(A.dL,[A.mj,A.hE,A.l5])
w(A.aLm,B.mn)
w(A.aLo,B.nN)})()
B.z2(b.typeUniverse,JSON.parse('{"mj":{"dL":["1"]},"hE":{"dL":["1"]},"l5":{"dL":["1"]}}'))
var y={h:B.R("r<i>"),p:B.R("aw"),b:B.R("@")};(function constants(){D.asJ=new B.bp(57785,"MaterialIcons",null,!1)
D.l8=new B.dg(D.asJ,null,null,null)})()}
$__dart_deferred_initializers__["3ZOgQGQ9YAE1xNQIMntif9aAcI4="] = $__dart_deferred_initializers__.current
