
ServerOptions.devices
s.options.device ="UMC404HD 192k"

s.num


(

~klank={
	|out=0,amp=0.02,m=6,e=21,pos=0|
	{
	var sig,filtF,reson;
	filtF=Array.fill(26,{|c|100+(c*70)});
	reson=Array.fill(26,{|c|if(c<=(6)){(c+(4/6))/6} {(c)/(c+(c-6))}})*0.7;
	sig=LFNoise2.ar(LFNoise2.kr(0.4).range(600,1000))*amp;
	sig=Klank.ar(`[filtF,reson*0.1,reson],sig);
	sig=Pan2.ar(sig,pos);
	sig
	}
}
)
~klank.play


(
~perc_noisy={
	|out=0,amp=0.8,mf=160,ranf=25,frate=23,fvib=14,pos=0|
	{
	var sig,vs,freq,wshape;
	vs = VarSaw;
	freq =vs.kr(frate,0,0.5,ranf,mf);
	wshape =LFNoise0.kr(fvib).range(0.01,1);
	sig = vs.ar(freq,0,wshape);
	sig=Pan2.ar(sig,pos)*amp;
	sig
	}
}
)

~perc_noisy.play

(
~metals={
	|out=0,amp=0.01,inF=200,l=0.1,h=8,nG=3,miF=70,maF=300,pos=0|
	var sig,aud;
	sig = VarSaw.ar(inF*TRand.kr(l,h,Dust.kr(nG)),0,0.001)*amp;
	sig
}
)

~metals.play


(
~pend_ond= {
	|out=0, pos=0,amp=0.05,minF=30,maxF=400,rateF=1,filtR=1,windR=1,minW=0.001,maxW=0.02|
	var sig,aud,filtf,wind;
	aud = SyncSaw.ar(Rand(minF,maxF),LFNoise2.kr(rateF).range(minF,maxF));
	filtf = LFNoise2.kr(filtR).range(minF,maxF);
	wind = LFNoise2.kr(windR).range(minW,maxW);
	sig =RLPF.ar(aud,filtf,wind)*amp;
	sig=Pan2.ar(sig,pos);
	sig
}
)

(
~reverb={
	|room=10,rev=1,spr=15,dry=1,tail=0.6|
	\filter -> {| sig |
	GVerb.ar(sig,room,rev,spread:spr,drylevel:dry,taillevel:tail);
}}
)

(
~blip_talk={
	|out=0,pos=0,fR=76,lF=150,hF=600,hR=4,lH=1,hH=2.5,amp=0.6|
	var sig,freq,harm,n3;
	n3=LFDNoise3;
	freq =n3.kr(fR).range(lF,hF);
	harm = n3.kr(hR).range(lH,hH);
	sig=Blip.ar(freq,harm,0.2)*amp;
	sig=Pan2.ar(sig,pos);
	sig
}
)

~rvb = { | mix = 0.9, room= 1, damp = 1 |
	\filter -> {| sig | FreeVerb.ar(sig, mix, room, damp)} };

~lp		=  { | freq = 500, rq = 0.1 |
	\filter -> {| sig | RLPF.ar(sig, freq, rq)} };
~hp		=  { | freq = 500, rq = 0.1 |
	\filter -> {| sig | RHPF.ar(sig, freq, rq)} };
~bp		=  { | freq = 500, rq = 0.1,amp=0.8 |
	\filter -> {| sig | BPF.ar(sig, freq, rq)*amp} };


//Eco
(
SynthDef(\eComb,
	{|out=0,pos=0,nGrain=15,amp=0.1,minF=90,maxF=1000,grDur=0.11,mDel=0.4,del=0.03,dec=0.4|
	var x ,sig;
	x = Dust.kr(nGrain);
	sig = SinGrain.ar(x,grDur,TExpRand.kr(minF,maxF,x));
	sig = CombN.ar(sig,mDel,[del],dec);
	sig = Limiter.ar(sig,amp,0.01);
	sig= Pan2.ar(sig,pos);
	Out.ar(out,sig)
};).add
)


Synth(\eComb,[\dec,12,\grDur,0.03,\nGrain,4])
Synth(\eComb,[\dec,12,\grDur,0.03,\nGrain,4,\del,0.08])
Synth(\eComb, [\nGrain,14,\minF,190,\maxF,800,\grDur,0.1,\del,0.01,\dec,0.9])

//poliritmia
Synth(\eComb,[\dec,12,\grDur,0.03,\nGrain,4,\mDel,0.95,\del,0.95,\amp,0.07,\pos,-1])
Synth(\eComb,[\dec,12,\grDur,0.05,\nGrain,4,\mDel,0.95,\del,0.95,\amp,0.07,\pos,-0.33])

Synth(\eComb,[\dec,12,\grDur,0.07,\nGrain,4,\mDel,0.95,\del,1,\amp,0.07,\pos,-0])

Synth(\eComb,[\dec,12,\grDur,0.09,\nGrain,4,\mDel,0.95,\del,1.4,\amp,0.07,\pos,0.33])

Synth(\eComb,[\dec,12,\grDur,0.1,\nGrain,4,\mDel,1.95,\del,1.7,\amp,0.07,\pos,1])

Synth(\eComb,[\dec,12,\grDur,0.1,\nGrain,3,\mDel,1.95,\del,1.7,\amp,0.07,\pos,1,\minF,190,\maxF,1800])

Synth(\eComb,[\dec,12,\grDur,0.1,\nGrain,9,\mDel,1.95,\del,1.7,\amp,0.07,\pos,1,\minF,190,\maxF,1800])

Synth(\eComb,[\dec,12,\grDur,0.1,\nGrain,9,\mDel,1.95,\del,1.7,\amp,0.07,\pos,1,\minF,190,\maxF,2000])

Synth(\eComb,[\dec,12,\grDur,0.1,\nGrain,5,\mDel,1.95,\del,1.7,\amp,0.07,\pos,1,\minF,190,\maxF,2000])


(
~timpani = {
	|out=0,amp=0.7,nGr=3,del=0.067,dec=2.5,coef=0.9|
	{var sig;
	sig = FBSineL.ar(100,1,2.5,0.7,1.3,0.3,0.4);
	sig = Pluck.ar(sig,Dust.kr(nGr),2,del,dec,coef)*amp;
	sig = GVerb.ar(sig);
		Out.ar(out,sig)};
}
)

~n = Ndef(\noise, { Silent.ar.dup }).play;

~n[1]=~timpani.(amp:0.2)

// ritmo
~n[0]=~timpani.(0,0.1,9,0.3,12,0.2)
~note[0]=~timpani.(0,0.1,2,1,7,0.7)
~n[0]=~timpani.(0,0.1,0.6,1,7,0.7)
~n[0]=~timpani.(0,0.04,22,0.01,1,0.4)

~n[0]=~timpani.(0,0.1,2,1,7,0.7)


{{RLPF.ar(SyncSaw.ar(rrand(70,300),LFNoise2.kr(12).range(10,300)),LFNoise2.kr(12).range(60,500),LFNoise2.kr(11).range(0.01,0.07))*0.01}!5}.play


{CombL.ar(GVerb.ar(VarSaw.ar(VarSaw.kr(0.03,0,1,65,120),0,LFNoise0.kr(11).range(0.01,1)),7,13,0.1,0.5,15,01),1,0.2,1)*0.01}.play

{PanAz.ar(4,CombL.ar(FreeVerb.ar(VarSaw.ar(VarSaw.kr(0.03,0,1,65,120),0,LFNoise0.kr(11).range(0.01,1)),1,13,0.5),1,0.2,1)*0.1,LFNoise2.kr(0.05).range(0,2))}.play

{PanAz.ar(4,CombL.ar(FreeVerb.ar(VarSaw.ar(VarSaw.kr(0.03,0,1,65,150),0,LFNoise0.kr(11).range(0.01,1)),1,13,0.5),1,0.2,1)*0.1,SinOsc.kr(0.1).range(0,2))}.play

{PanAz.ar(4,CombL.ar(FreeVerb.ar(VarSaw.ar(VarSaw.kr(0.03,0,1,65,200),0,LFNoise0.kr(11).range(0.01,1)),1,13,0.5),1,0.2,1)*0.1,SinOsc.kr(0.1).range(0,2))}.play

{PanAz.ar(4,CombL.ar(FreeVerb.ar(VarSaw.ar(VarSaw.kr(0.03,0,1,65,200),0,LFNoise0.kr(11).range(0.01,1)),1,13,0.5),1,0.2,1)*0.1,SinOsc.kr(0.01).range(0,2))}.play


(
~eComb =
	{|out=0,nGrain=15,amp=0.1,minF=90,maxF=1000,grDur=0.11,mDel=0.4,del=0.03,dec=0.4|
	{
	var x ,sig,g;
	g=EnvGen.kr(Env([1,100],[12],[2]),2);
	x = Dust.kr(g);
	sig = SinGrain.ar(x,grDur,TExpRand.kr(minF,maxF,x));
	sig = CombN.ar(sig,mDel,[del],dec);
	Limiter.ar(sig,amp,0.01);
	};
}
)




~n = Ndef(\noise, { Silent.ar.dup }).play;

~n[0] = ~eComb.(amp:0.1,nGrain:3,minF:150,maxF:900,grDur:0.096,mDel:1,del:0.08,dec:15)
~n[0] = ~eComb.(amp:0.3,nGrain:3,minF:150,maxF:900,grDur:0.05,mDel:3,del:2,dec:5)
~n[0] = ~eComb.(amp:0.3,nGrain:5,minF:950,maxF:1500,grDur:0.01,mDel:3,del:2.4,dec:3)

Synth(\eComb,[\dec,12,\grDur,0.1,\nGrain,3,\mDel,1.95,\del,1.7,\amp,0.07,\pos,1,\minF,190,\maxF,1800])


~n[0] = ~eComb.(amp:0.1,nGrain:10,minF:150,maxF:1800,grDur:0.01,mDel:3,del:2,dec:5)

~n[0] = ~eComb.(amp:0.3,nGrain:1,minF:150,maxF:1800,grDur:0.05,mDel:3,del:1,dec:5)

~n[2] = ~eComb.(amp:0.3,nGrain:1,minF:150,maxF:1800,grDur:0.09,mDel:3,del:1,dec:5)

~n[3] = ~eComb.(amp:0.3,nGrain:1,minF:150,maxF:1800,grDur:0.1,mDel:3,del:1,dec:5)

//~reverb={|room=10,rev=1,spr=15,dry=1,tail=0.6,pos=0|


~n[4]=~reverb.(8,5,15,0.5,2.2)

~note.source=nil

~note = NodeProxy.audio(s, 4).play;


~note.fadeTime=4
//|freq=500,amp=0.4,nW=2,lr=0.05,hr=0.3,wid=19200
~note[0]=~allF.(90,lr:0.1,hr:0.4,wid:29900,amp:0.1,nW:4)
~note[1]=nil
~note[1]=~allF.(100,lr:0.1,hr:0.4,wid:220,amp:0.1,nW:4)
~note[2]=~allF.(300,lr:0.1,hr:0.4,wid:9220,amp:0.2,nW:4)

~note[1]=nil

//despues de que la capa alta se revela volver a la capa baja

~allF={|freq=500,amp=0.4,nW=2,lr=0.05,hr=0.3,wid=19200|{{SinOsc.ar(freq,Saw.kr(LFNoise2.kr(0.1).range(lr,hr),wid))*amp}!nW}};