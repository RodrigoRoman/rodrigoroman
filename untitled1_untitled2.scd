s.quit;
s.options.memSize = 75536;
s.boot;
(
(
~pend_ond= {
	| posR=1,iposD=1,eposD=0.3,posM=1,amp=0.05,iminF=30,eminF=30,imaxF=400,emaxF=400,ifiltR=1,efiltR=1,windR=1,minW=0.001,maxW=0.02,baseT,devT,cur|
			{ | exp = 1.03|
	var sig,aud,filtf,wind,pos,envFiltR,envminF,envmaxF,envPosD,envAmp;
	envFiltR= 		EnvGen.kr(Env([ifiltR, efiltR,efiltR,ifiltR],[baseT,devT,4],[cur]));
	envminF=		EnvGen.kr(Env([iminF, eminF,eminF,70],[baseT,devT,4],[cur]));
	envmaxF = 		EnvGen.kr(Env([imaxF, emaxF,emaxF,70],[baseT,devT,4],[cur]));
	envPosD = 		EnvGen.kr(Env([iposD, eposD,eposD],[baseT,devT+4],[cur]),doneAction:0);
	envAmp = 		EnvGen.kr(Env([1,1,0.01],[baseT+devT,4],[cur]),doneAction:0);
	aud = SyncSaw.ar(Rand(envminF,envmaxF),LFNoise2.kr(envFiltR).range(envminF,envmaxF))**exp;
	filtf = LFNoise2.kr(envFiltR).range(envminF,envmaxF);
	wind = LFNoise2.kr(windR).range(minW,maxW);
	pos = LFNoise2.kr(posR,envPosD,posM);
	sig =RLPF.ar(aud,filtf,wind)**exp;
	sig= sig*amp;
	sig = Limiter.ar(sig, 0.3);
	PanAz.ar(4,sig,pos);
			}
};
);

(
~klank={
	|out=0,amp=0.02,m=6,e=21,pos=0,tres=0.4,cur,baseT,devT|
	{
	var sig,filtF,reson,envAmp;
	envAmp= 		EnvGen.kr(Env([0,1,1,0],[baseT,devT,9],[5,5,-5]));
	filtF=Array.fill(26,{|c|100+(c*70)})*EnvGen.kr(Env([1,1,1,0.01],[baseT,devT,9],[cur]),doneAction:2);//how can i control this freqency
	reson=Array.fill(26,{|c|if(c<=(m)){(c+(4/m))/m} {(c)/(c+(c-m))}})*0.7;
	sig=LFNoise2.ar(LFNoise2.kr(0.4).range(600,1000),envAmp)*amp;
	sig=Klank.ar(`[filtF,reson*0.1,reson],sig);
	sig =Limiter.ar(sig, tres);
	sig=PanAz.ar(4,sig,pos);
	sig
		}
};
);


(
~op_cant={
	|iA=0.5,eA=0.5,pos=0,ifR=5,efR=5,ilF=200,elF=200,ihF=500,ehF=500,vibW=70,vibR=6,cur=2,baseT=1,devT=1|
	{var sig,n3,envFR,envlF,envhF,envW,envA;
	envFR= 		EnvGen.kr(Env([ifR, efR,efR],[baseT,devT],[cur]));
	envlF=		EnvGen.kr(Env([ilF,elF,elF],[baseT,devT],[cur]));
	envhF = 		EnvGen.kr(Env([ihF,ehF,ehF],[baseT,devT],[cur]));
	envA = 		EnvGen.kr(Env([iA,eA,eA],[baseT,devT],[cur]));
	n3=LFDNoise3;
	sig=Klank.ar(`[Array.fill(5,{|up| n3.kr(5).range(250,600)*(up+1.3)}),(0.1)!5,(0.1)!5],Saw.ar(Lag.kr(n3.kr(envFR).range(envlF,envhF)) + SinOsc.kr(vibR).range(1,vibW)))*envA;
	sig=Limiter.ar(sig,0.1);
	sig=PanAz.ar(4,sig,pos,orientation:0);
	sig
}}
);

(
~perc_noisy={
	|amp=0.8,mf=160,wid=1,ranf=25,frate=23,fvib=14|
	{
	var sig,vs,freq,wshape;
	vs = VarSaw;
	freq =vs.kr(frate,0,wid,ranf,mf);
	wshape =LFNoise0.kr(fvib).range(0.01,1);
	sig = vs.ar(freq,0,wshape);
	sig=PanAz.ar(4,sig,LFNoise2.kr(0.05).range(0,2))*amp;
	sig
	}
}
);
(//how can i change position every attack
~timpani = {
	|out=0,amp=0.7,nGr=3,del=0.067,dec=2.5,coef=0.9|
	{var sig,trig,pos;
	sig = FBSineL.ar(100,1,2.5,0.7,1.3,0.3,0.4);
	sig = Pluck.ar(sig,Dust.kr(nGr),2,del,dec,coef)*amp;
	sig = GVerb.ar(sig);
	pos= LFNoise2.kr(0.3).range(0,2);
	PanAz.ar(4,sig,pos,orientation:0)};
}
);

(
~eComb =
	{|pos=0,tres=0.1,cur=1,iG=15,eG=15,iamp=0.1,eamp=0.1,iminF=90,eminF=90,imaxF=1000,emaxF=1000,iGD=0.11,eGD=0.11,mDel=3,iDel=0.03,eDel=0.03,iDec=0.4,eDec=0.4,baseT,devT,done=2|
	{
	var x,sig,env,envG,envDel,envDec,envAmp,envGD,envminF,envmaxF;
	env = EnvGen.kr(Env([-1, 1,1],[baseT,devT],[cur]),doneAction:done);
	envG= 			env.range(iG,eG);
	envminF=     env.range(iminF,eminF);
	envmaxF =   env.range(emaxF,emaxF);
	envDel=		env.range(iDel,eDel);
	envDec = 		env.range(iDec,eDec);
	envAmp =    env.range(iamp,eamp);
	envGD =		env.range(iGD,eGD);
	x = Dust.kr(envG);//,envAmp
	sig = SinGrain.ar(x,envGD,TExpRand.kr(envminF,envmaxF,x));
	sig = CombN.ar(sig,mDel,envDel,envDec);//why i wrote []
	sig=Limiter.ar(sig,tres,0.01);
	sig = PanAz.ar(4,sig,pos,orientation:0);
	sig
	};
}
);

(
~eComb2 =
	{|out=0,rnd=50,nGrain=15,amp=0.1,minF=90,maxF=1000,grDur=0.11,mDel=0.4,del=0.03,dec=0.4,dur,edur=4,cur|
	{
	var x ,sig,g,envA;
	g=EnvGen.kr(Env([1,100,0],[dur,edur],[cur,4]),1,doneAction:2);
	x = Dust.kr(g);
	envA=	EnvGen.kr(Env([0,amp,0],[dur,edur],[cur,4]),1,doneAction:2);
	sig = SinGrain.ar(x,grDur,TExpRand.kr(minF,maxF,x).round(rnd));
	sig = CombN.ar(sig,mDel,del,dec);
	Limiter.ar(sig,envA,0.01)!4;
	};
}
);

(
~metals={
	|out=0,amp=0.01,inF=200,l=0.1,h=8,iG=3,eG=24,miF=70,maF=300,dur,cur,durA,curA|
	{
	var sig,aud,envG,envA;
	envG = EnvGen.kr(Env([iG,eG],[dur],[cur]),1,doneAction:0);
	envA = EnvGen.kr(Env([0,amp],[durA],[curA]),1,doneAction:0);
	sig = VarSaw.ar(inF*TRand.kr(l,h,Dust.kr(envG)),0,0.001)*envA;
	sig!4
	}
}
);

~allF={|freq=500,amp=0.4,nW=2,lr=0.05,hr=0.3,wid=19200|{{SinOsc.ar(freq,Saw.kr(LFNoise2.kr(0.1).range(lr,hr),wid))*amp}!nW}};

~allFEnv={|freq=500,amp=0.4,nW=2,ilr=0.05,elr=0.05,ihr=0.3,ehr=0.3,iwid=19200,ewid=19990,cur1=1,cur2=4,devT=12,baseT=13|{
	var envWid,envlr,envhr;
	envWid= 		EnvGen.kr(Env([iwid, ewid,ewid],[baseT,devT],[cur2]));
	envlr= 		EnvGen.kr(Env([ilr, elr,elr],[baseT,devT],[cur1]));
	envhr= 		EnvGen.kr(Env([ihr, ehr,ehr],[baseT,devT],[cur1]));
	{SinOsc.ar(freq,Saw.kr(LFNoise2.kr(0.1).range(envlr,envhr),envWid))*amp}!nW}
};


//effects
(
~gVerb={
	|room=10,rev=1,spr=15,dry=1,tail=0.6,pos=0|
	\filter -> {|in|
	var sig;
	sig=GVerb.ar(in,room,rev,spread:spr,drylevel:dry,taillevel:tail,mul:0.5);
	sig!4
}
}
);

~rvb = { | mix = 0.9, room= 1, damp = 1,amp=0.8 |
		\filter -> {| sig | Limiter.ar(FreeVerb.ar(sig, mix, room, damp)*amp,0.5)} };

~bp		=  { | freq = 500, rq = 0.1,amp=0.8 |
	\filter -> {| sig | BPF.ar(sig, freq, rq)*amp} };

~filtK		=  { | size,lev =#[]|
	\filter -> {| sig |
		Limiter.ar(Klank.ar(`[Array.fill(22,{exprand(280,1000)}),[size],lev],sig),0.1,0.02)} };
)

//UNTITLED1
~layer1 = NodeProxy.audio(s, 4).play;

~layer1.fadeTime=9;
~layer1.objects[0].set(\exp, 1.03)

~layer1[0]=~pend_ond.( posR:1,iposD:1,eposD:0.1,posM:1,amp:0.05,iminF:30,eminF:530,imaxF:560,emaxF:400,ifiltR:0.1,efiltR:0.6,windR:1,minW:0.001,maxW:0.02,baseT:60*2,devT:3,cur:1);

~layer1[1]=~pend_ond.( posR:1,iposD:1,eposD:0.1,posM:1,amp:0.05,iminF:30,eminF:530,imaxF:560,emaxF:400,ifiltR:0.1,efiltR:0.6,windR:1,minW:0.001,maxW:0.02,baseT:60*1,devT:3,cur:1);

~layer1[0]=~pend_ond.( posR:1,iposD:1,eposD:0.1,posM:1,amp:0.05,iminF:30,eminF:530,imaxF:560,emaxF:400,ifiltR:0.2,efiltR:0.9,windR:1,minW:0.001,maxW:0.02,baseT:60*1,devT:3,cur:1);

~layer1[1]=~pend_ond.( posR:1,iposD:1,eposD:0.1,posM:1,amp:0.05,iminF:30,eminF:530,imaxF:560,emaxF:400,ifiltR:0.3,efiltR:2,windR:1,minW:0.001,maxW:0.02,baseT:60*2,devT:3,cur:1);

~layer1[2]=~pend_ond.( posR:1,iposD:1,eposD:0.1,posM:1,amp:0.05,iminF:30,eminF:530,imaxF:560,emaxF:400,ifiltR:0.5,efiltR:4,windR:1,minW:0.001,maxW:0.02,baseT:60*1,devT:3,cur:1,exp:1.15);


(
~layer1[0]=~pend_ond.( posR:1,iposD:1,eposD:0.1,posM:1,amp:0.05,iminF:30,eminF:530,imaxF:560,emaxF:400,ifiltR:1,efiltR:17,windR:1,minW:0.001,maxW:0.02,baseT:60*2,devT:40,cur:1);

~layer1[1]=~pend_ond.( posR:1,iposD:1,eposD:0.1,posM:1.5,amp:0.05,iminF:30,eminF:530,imaxF:560,emaxF:400,ifiltR:0.8,efiltR:17,windR:1,minW:0.001,maxW:0.02,baseT:60*2,devT:40,cur:1);

~layer1[2]=~pend_ond.( posR:1,iposD:2,eposD:0.1,posM:0,amp:0.05,iminF:30,eminF:630,imaxF:600,emaxF:500,ifiltR:0.9,efiltR:17,windR:1,minW:0.001,maxW:0.02,baseT:60*2,devT:40,cur:1);

~layer1[3]=~pend_ond.( posR:1,iposD:2,eposD:0.1,posM:0.5,amp:0.05,iminF:30,eminF:560,imaxF:590,emaxF:260,ifiltR:0.8,efiltR:17,windR:1,minW:0.001,maxW:0.02,baseT:60*2,devT:40,cur:1);
)


(
~layer1[7]=~klank.(pos:0,cur:5,tres:0.5,baseT:73,devT:23);
~layer1[3]=~klank.(pos:0.5,m:2,tres:0.5,cur:5,baseT:73,devT:23);
~layer1[4]=~klank.(pos:1.5,m:4,tres:0.5,cur:5,baseT:73,devT:23);
~layer1[5]=~klank.(pos:1,m:1,tres:0.5,cur:5,baseT:73,devT:23);
)

~layer1.fadeTime=5;

(
~layer1[0]=nil;
~layer1[1]=nil;
~layer1[2]=nil;
~layer1[3]=nil;
)

(
~layer1[7]=nil;
~layer1[3]=nil;
~layer1[4]=nil;
~layer1[6]=nil;
~layer1[5]=nil;
)

~layer2 = NodeProxy.audio(s, 4).play;
~layer2.fadeTime=6
(
~layer2[0]=~op_cant.(iA:0.0,eA:0.1,pos:0,ifR:9,efR:9,ilF:70,elF:70,ihF:150,ehF:150,vibW:100,vibR:0.3,cur:5,baseT:64,devT:12);
~layer2[1]=~op_cant.(iA:0.0,eA:0.1,pos:0.5,ifR:9,efR:9,ilF:450,elF:450,ihF:650,ehF:650,vibW:100,vibR:0.3,cur:5,baseT:64,devT:12);
~layer2[2]=~op_cant.(iA:0.0,eA:0.1,pos:1,ifR:9,efR:9,ilF:250,elF:250,ihF:350,ehF:350,vibW:100,vibR:0.3,cur:2,baseT:64,devT:12);
~layer2[3]=~op_cant.(iA:0.0,eA:0.1,pos:1.5,ifR:7,efR:9,ilF:100,elF:100,ihF:250,ehF:250,vibW:100,vibR:0.3,cur:5,baseT:34,devT:12);
~layer2[4]=~op_cant.(iA:0.0,eA:0.1,pos:0,ifR:9,efR:9,ilF:100,elF:100,ihF:250,ehF:250,vibW:100,vibR:0.3,cur:5,baseT:64,devT:12);
~layer2[5]=~op_cant.(iA:0.0,eA:0.1,pos:0.5,ifR:9,efR:9,ilF:250,elF:250,ihF:400,ehF:400,vibW:100,vibR:0.3,cur:5,baseT:64,devT:12);
~layer2[6]=~op_cant.(iA:0.0,eA:0.1,pos:1,ifR:9,efR:9,ilF:50,elF:50,ihF:150,ehF:150,vibW:100,vibR:0.3,cur:5,baseT:64,devT:12);
~layer2[7]=~op_cant.(iA:0.0,eA:0.1,pos:1.5,ifR:9,efR:9,ilF:350,elF:350,ihF:550,ehF:550,vibW:100,vibR:0.3,cur:5,baseT:64,devT:12);
)



~layer2[7]=nil;
~layer2[3]=nil;
~layer2[4]=nil;
~layer2[6]=nil;
~layer2[5]=nil;


~layer2.fadeTime=1
~layer2[0]=~op_cant.(amp:0.3,pos:0,ifR:3,efR:8,ilF:10,elF:80,ihF:10,ehF:200,vibW:170,vibR:11,cur:1,baseT:12,devT:12);
~layer2[1]=~op_cant.(amp:0.3,pos:0.5,ifR:3,efR:5,ilF:10,elF:300,ihF:10,ehF:400,vibW:70,vibR:12,cur:1,baseT:10,devT:12);
~layer2[2]=~op_cant.(amp:0.3,pos:1,ifR:3,efR:9,ilF:10,elF:100,ihF:10,ehF:250,vibW:70,vibR:6,cur:9,baseT:14,devT:12);
~layer2[3]=~op_cant.(amp:0.3,pos:1.5,ifR:3,efR:7,ilF:10,elF:300,ihF:10,ehF:600,vibW:70,vibR:11,cur:2,baseT:12,devT:12);


(
~layer1[0]=~perc_noisy.(0.7,120,1,65,0.03,11);
~layer1[1]=~rvb.(0.9,1,1,0.4);
)

//one by one
~layer2[0]=nil;
~layer2[1]=nil;
~layer2[2]=nil;
~layer2[3]=nil;

~layer1[0]=nil;

~layer1[0]=~timpani.(amp:0.1,nGr:0.3,del:2,dec:7.5,coef:0.9);

~layer1[0]=~timpani.(amp:0.3,nGr:0.3,del:2,dec:7.5,coef:0.8);

~layer1[1]=~allFEnv.(100,amp:0.1,nW:4,ilr:0.1,elr:0.4,ihr:0.08,ehr:0.1,iwid:200,ewid:29990,cur1:1,cur2:10,devT:60*8,baseT:60);

~layer1[0]=~allF.(100,lr:0.1,hr:0.4,wid:420,amp:0.2,nW:4);

~layer1[0]=nil
~layer1.fadeTime=13
~layer1.source=nil;

~layer1[1]=nil

~layer1 = NodeProxy.audio(s, 4).play;
~layer1.fadeTime=3;


//UNTITLED 2

(//changing GD makes the process very different
~layer1[0]=~eComb.(pos:0,tres:0.2,cur:4,iG:1,eG:105,iamp:0.1,eamp:0.1,iminF:150,eminF:390,imaxF:1800,emaxF:1000,iGD:0.01,eGD:0.05,mDel:3,iDel:2,eDel:2,iDec:5,eDec:5,baseT:60,devT:5,done:0);
~layer1[1]=~eComb.(pos:0.5,tres:0.2,cur:4,iG:1,eG:105,iamp:0.1,eamp:0.1,iminF:150,eminF:390,imaxF:1800,emaxF:1000,iGD:0.01,eGD:0.05,mDel:3,iDel:2,eDel:2,iDec:5,eDec:5,baseT:60,devT:5,done:0);
~layer1[2]=~eComb.(pos:1,tres:0.2,cur:4,iG:1,eG:105,iamp:0.1,eamp:0.1,iminF:150,eminF:390,imaxF:1800,emaxF:1000,iGD:0.01,eGD:0.05,mDel:3,iDel:2,eDel:2,iDec:5,eDec:5,baseT:60,devT:5,done:0);
~layer1[3]=~eComb.(pos:1.5,tres:0.2,cur:4,iG:1,eG:105,iamp:0.1,eamp:0.1,iminF:150,eminF:390,imaxF:1800,emaxF:1000,iGD:0.01,eGD:0.05,mDel:3,iDel:2,eDel:2,iDec:5,eDec:5,baseT:60,devT:5,done:0);
)


~layer2 = NodeProxy.audio(s, 4).play;
~layer2.fadeTime=2;

//inclement rnd from 25
~layer2[0] = ~eComb2.(amp:0.05,rnd:25,nGrain:4,minF:100,maxF:900,grDur:5,mDel:3,del:1.5,dec:5,dur:7.5,cur:2,edur:6);
~layer2[1]=~rvb.(1,1,1);
~layer2[2]=~rvb.(1,1,1);


~layer2[0] = ~eComb2.(amp:0.1,rnd:35,nGrain:4,minF:100,maxF:900,grDur:5,mDel:3,del:1.5,dec:5,dur:7.5,cur:2,edur:6);

~layer2[0] = ~eComb2.(amp:0.15,rnd:45,nGrain:4,minF:100,maxF:1200,grDur:5,mDel:3,del:1.5,dec:5,dur:7.5,cur:2,edur:6);

~layer2[0] = ~eComb2.(amp:0.2,rnd:55,nGrain:4,minF:100,maxF:1200,grDur:5,mDel:3,del:1.5,dec:5,dur:7.5,cur:2,edur:6);

~layer2[0] = ~eComb2.(amp:0.15,rnd:25,nGrain:4,minF:100,maxF:900,grDur:5,mDel:3,del:1.5,dec:5,dur:7.5,cur:2,edur:6);

~layer2[0] = ~eComb2.(amp:0.12,rnd:75,nGrain:4,minF:100,maxF:1900,grDur:5,mDel:3,del:1.5,dec:5,dur:3.5,cur:-8,edur:10);


~layer1.fadeTime=13;
~layer1[4]=~comboZ.(dtime:1.4,ampC:2,dec:0.7,vR:4)


//\room,4.5,\rev,6,\spr,1,\dry,0.1,\tail,5,\pos,2

//para el ultimo hacerlo mucho mas dinamico. como si lanzara algo
//,e interesa el efecto de pasar a otra dimension
~layer3.fadeTime=18;
~layer1.source=nil
~layer3 = NodeProxy.audio(s, 4).play;
~layer3[0]=~metals.(iG:13,eG:13,dur:3,cur:-4);
~layer3[1]=nil


~layer3[0]=~metals.(iG:1,eG:43,dur:13,cur:2,durA:20,curA:2);
~layer3[2]=~reverb.(4.5,6,1,0.1,6,1);
~layer3[4]=~comboZ.(dtime:5.4,ampC:5,dec:2.1,vR:43)


//vR
~layer3[3]=~comboZ.(dtime:4.4,ampC:4,dec:1.1,vR:23)

~layer3[4]=~comboZ.(dtime:5.4,ampC:5,dec:2.1,vR:43)

~layer3[4]=~comboZ.(dtime:2.4,ampC:5,dec:1.7,vR:3)





//~comboZ= { |  dtime,fadeTime, gate=1,dec=2, ampC=1, lagT=16,vR=0.5|
~layer1.fadeTime=3;


//| freq = 500, rq = 0.1,amp=0.8 |
~layer3.fadeTime=3;

~layer3[1]=~bp.(100,0.01,4.9);
~layer3[1]=~bp.(100,0.9,0.7);
~layer3[1]=~bp.(100,0.01,4.9);
~layer3[1]=~bp.(100,0.9,0.7);
~layer3[1]=~bp.(100,0.01,4.9);
~layer3[1]=~bp.(100,0.9,0.7);



//dos cosas por hacer
/*
jugar con los bp y por otro lado convertir la otra pieza
*/



