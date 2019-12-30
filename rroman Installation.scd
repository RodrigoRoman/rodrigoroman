/*INSTALLATION 1*/

(
a = Ndef(\a, {Silent.ar.dup}).play;
b = Ndef(\b, {Silent.ar.dup}).play;
c = Ndef(\c, {Silent.ar.dup}).play;
a.fadeTime=8;
b.fadeTime=8;
c.fadeTime=8;

~brownN={{BrownNoise.ar(0.005)}!2};

~whiteN={{WhiteNoise.ar(0.005)}!2};

~tamb={|freq=90,amp=0.4,rate=1|{Pan2.ar(SinOsc.ar(freq,mul:SinOsc.kr(PinkNoise.kr(rate).range(0.01,1)).range(0,0.2))*amp,LFNoise1.kr(0.1).range(-1,1))}};

~pattM={|freq=300,midR=2,low=1,high=7,amp=0.1|{{SinOsc.ar(freq*LFNoise0.kr(midR).range(low,high))*amp}!5}};

~card={|freq=#[900,1200],rate=#[1,4],start=0.1,end=13,low=1,high=130,amp=0.1|{SinOsc.ar(freq,SinOsc.kr(LFNoise0.kr(rate).range(start,end)).range(low,high))*amp}};

~waveC={|dust=20,dur=0.3,low=400,high=1200,amp=0.07|{{Pan2.ar(SinGrain.ar(Dust.kr(dust),dur,ExpRand(low,high),0.5),LFTri.kr(0.1).range(-1,1))*amp}!9}};

~lowRF= {|rate=3,low=0.01,high=12,start=180,end=2000,rq=0.2|
	\filter->{| sig | RLPF.ar(sig, LFNoise1.ar(rate*LFNoise1.kr.range(low,high)).exprange(start,end), rq)}};

~highRF={|ratio1=0.05,ratio2=0.04,start=180,end=2800,rq=0.3|\filter->{|sig|RHPF.ar(sig,LFNoise1.ar(ratio1*LFNoise1.kr(ratio2).range(0.5,17)).exprange(start,end),rq)}};
)

(
~slowPi=[~pattM.([100,200,300].choose,midR:[0.1,0.08,0.2].choose,amp:0.0003),~waveC.(1,2,low:100,high:500,amp:0.001),~waveC.([0.5,0.3,0.2].choose,[0.3,0.2,0.5].choose,low:100,high:500,amp:0.001)];

~filterSl=[~highRF.([0.5,0.2,0.1].choose,0.1,30,rq:[0.1,0.2,0.3].choose),~lowRF.(1,rq:[0.1,0.2,0.3].choose)];

~fastPi=[~waveC.(5,[0.05,0.2,0.1,0.08].choose,low:100,high:500,amp:0.001),~pattM.(rrand(100,300),midR:rrand(11,23),amp:0.001)];

~fort=[~waveC.(5,[0.05,0.2,0.1,0.08].choose,low:100,high:500,amp:0.03),~pattM.(rrand(100,300),midR:rrand(11,23),amp:0.01),~card.([300,500],[5,7],amp:0.007)];

~filterF=[~highRF.([15,7,11].choose,0.1,30,rq:[0.1,0.2,0.3].choose),~lowRF.([11,8,5,15].choose,rq:[0.1,0.2,0.3].choose)];
)

~instal= Task({
			inf.do{
		b[0]=~brownN;
        a[0]=~whiteN;
		c[0]=~tamb.();
		40.wait;
		a[1]=~slowPi.choose;
		40.wait;
		b[1]=~slowPi.choose;
		40.wait;
		a[2]=~slowPi.choose;
		40.wait;
		c[0]=nil;
		b[2]=~slowPi.choose;
		40.wait;
		a[3]=~filterSl.choose;
		40.wait;
		b[3]=~filterSl.choose;
		40.wait;
		a[4]=~fastPi.choose;
		c[0]=~tamb.(rrand(90,200),0.2,rrand(0.1,3));
		30.wait;
		b[4]=~fastPi.choose;
		30.wait;
		a[5]=~fastPi.choose;
		30.wait;
		b[5]=~fastPi.choose;
		40.wait;
		b[3]=~filterF.choose;
		c[1]=~tamb.(rrand(100,500),0.1,rrand(0.1,3));
		c[2]=~tamb.(rrand(100,500),0.1,rrand(0.1,3));
		40.wait;
		c[3]=~tamb.(rrand(100,500),0.1,rrand(0.1,3));
		c[4]=~tamb.(rrand(100,500),0.1,rrand(0.1,3));
		a[6]=~fort.choose;
		40.wait;
		b[6]=~fort.choose;
		b[7]=~fort.choose;
		a[7]=~fort.choose;
		40.wait;
		b[3]=~filterF.choose;
        a[3]=~filterF.choose;
		c[5]=~filterF.choose;
		50.wait;
		a[7]=nil;
		b[7]=nil;
		c[5]=nil;
		a[0]=nil;
		40.wait;
		a[6]=nil;
		b[6]=nil;
		c[4]=nil;
		c[2]=nil;
		b[3]=nil;
		10.wait;
		c[3]=nil;
		b[0]=nil;
		a[3]=nil;
		40.wait;
		c[1]=nil;
		a[5]=nil;
		b[5]=nil;
		40.wait;
		a[4]=nil;
		b[4]=nil;
		30.wait;
		a[2]=nil;
		b[2]=nil;
}})
~instal.play;


/* INTALATION 2 (Mostly the same code as the livecoding session) */

(
a = Ndef(\a, {Silent.ar.dup}).play;
b = Ndef(\b, {Silent.ar.dup}).play;
c = Ndef(\c, {Silent.ar.dup}).play;
a.fadeTime=5;
b.fadeTime=5;
c.fadeTime=5;

~panN={|freq=50,rate=13,panR=30,low=3,high=230,amp=0.1|{Pan2.ar(LFNoise2.ar(freq*LFNoise1.kr(rate).range(low,high)),LFNoise1.kr(panR).range(-1,1))*amp}};


~henonN={|freq=600,rate=0.01,start=400,end=700,amp=0.5|{{HenonN.ar(freq*BrownNoise.kr(rate).range(start,end),LFNoise1.kr(1,0.2,1.4),LFNoise0.kr(1,0.01,0.3))*amp}!2}};

~saw2={|freq=34,midra=13,low=1,high=50,freq2=400,midr2=5,low2=10,high2=13,amp=0.1|{{[LFSaw.ar(freq*BrownNoise.kr(midra).range(low,high))*amp,LFPulse.ar(freq2*BrownNoise.kr(midr2).range(low2,high2))*amp]}!2}};


~sinO={|freq1=7,freq2=400,rate=2,low=1,high=10,amp=0.1,period = 1, exp = 0.1|{{LFSaw.kr(1/period).range(0, 1) **exp *SinOsc.ar(ExpRand(freq1,freq2)*PinkNoise.kr(ExpRand(0.01,5)).range(low,high)*PinkNoise.kr(rate).range(low,high))*amp}!3}};

~fbSin={|amp=0.1,ratio=1,freq=600,start=0.1,end=9,low=0.1,high=5|{{FBSineC.ar(freq*PinkNoise.ar(ratio*LFNoise1.kr(0.1).range(start,end)).range(low,high),0.8,0.1,1.1)*amp}!2}};


~waveC={|dust=20,dur=0.3,low=400,high=1200,amp=0.07|{{Pan2.ar(SinGrain.ar(Dust.kr(dust),dur,ExpRand(low,high),0.5),LFTri.kr(0.1).range(-1,1))*amp}!9}};

~patt={|dur=0.5,amp=0.02,midfre=2,panR=0.5|{Pan2.ar(SinGrain.ar(Dust.kr([14,13,3,5,15].choose+midfre),dur,BrownNoise.kr.range(300,1200),0.5),LFNoise1.kr(panR).range(-1,1))*amp}};

~speak={|low=1300,high=1500,amp=0.3|{{LFPulse.ar(TExpRand.kr(low,high,Dust.kr([35,13,5,3,23,18,9].choose)))*amp}!5}};


~pattM={|freq=300,midR=2,low=1,high=7,amp=0.1|{{SinOsc.ar(freq*LFNoise0.kr(midR).range(low,high))*amp}!5}};

~card={|freq=#[900,1200],rate=#[1,4],start=0.1,end=13,low=1,high=130,amp=0.1|{SinOsc.ar(freq,SinOsc.kr(LFNoise0.kr(rate).range(start,end)).range(low,high))*amp}};

~lfSaw={|freq=#[500,490,495,530,515],low=4,high=9,amp=0.05,midR=0.02 |{LFSaw.ar(freq*PinkNoise.kr(midR).range(low,high))*amp}};

~blip = { |freq=12,freq2=8,low=0.1,high=1,amp=0.9, period = 1, exp = 11| {{
	(LFTri.kr(1/period).range(0, 1) **exp) *
	Blip.ar(freq*PinkNoise.kr(freq2).range(low,high))*amp}!7}};
)

(
~lowRF= {|rate=3,low=0.01,high=12,start=880,end=12000,rq=0.2|
	\filter->{| sig | RLPF.ar(sig, LFNoise1.ar(rate*LFNoise1.kr.range(low,high)).exprange(start,end), rq)}};

~highRF={|ratio1=0.05,ratio2=0.04,start=180,end=2800|\filter->{|sig|RHPF.ar(sig,LFSaw.ar(ratio1*LFNoise1.kr(ratio2).range(0.5,17)).exprange(start,end))}};

~rvb = { | mix = 0.9, room= 1, damp = 1 |
	\filter -> {| sig | FreeVerb.ar(sig, mix, room, damp)} };

~lp		=  { | freq = 500, rq = 0.1 |
	\filter -> {| sig | RLPF.ar(sig, freq, rq)} };
~hp		=  { | freq = 500, rq = 0.1 |
	\filter -> {| sig | RHPF.ar(sig, freq, rq)} };
~bp		=  { | freq = 500, rq = 0.1 |
	\filter -> {| sig | BPF.ar(sig, freq, rq)} };
	~delay 	= { |
	del = 0.1, decay  = 4 | {| sig | sig + AllpassC.ar(sig, del, del, decay )} };
~tremolo = { | rate = 2.1, depth = 1 |
	\filter -> {| sig | sig * SinOsc.ar(rate, 0, depth, 1-depth)}  };

~vibrato = { | rate = 2.1, depth = 0.4, window = 0.01 |
	\filter -> {| sig | PitchShift.ar(sig, window, SinOsc.ar(rate, 0, depth).midiratio)} };

~distort 		=\filter-> {| sig | (3111.33*sig.distort/(1+(2231.23*sig.abs))).distort*0.02};

~squiz			= {| ratio = 4.5, chunk = 5 | \filter-> {|sig|Squiz.ar(sig, ratio, chunk, 0.1)}};

~hilosweep = { | dur =20, startFreq = 20000, endFreq = 20, rq = 1 |
	\filter -> { | in |
		RLPF.ar(in, XLine.kr(startFreq, endFreq, dur), rq ) +
		RHPF.ar(in, XLine.kr(endFreq, startFreq,  dur), rq )
	} };

~glitchOut = { | dur =20, startFreq = 100, endFreq = 0, dr = 0.03 |
	\filter -> { | in | in * LagUD.ar(Dust.ar(Line.kr(startFreq, endFreq, dur)), 0, dr) }
	};
)

		~installation2= Task({
			inf.do{
				b[0]=~blip.(30,freq:21,exp:9,period:0.01);
				30.wait;
				a[1]=~panN.(50,13,20,1,400,amp:0.02);
				15.wait;
				a[2]=~squiz.(3,34);
				15.wait;
				a[1]=~panN.(50,13,20,1,400,amp:0.04);
				9.wait;
				b[1]=~lp.(400);
				8.wait;
				a[1]=~panN.(50,13,20,1,400,amp:0.06);
				8.wait;
				a[1]=~panN.(50,13,20,1,400,amp:0.08);
				a[2]=~squiz.(4,35);
				20.wait;
				b[1]=~lp.(550);
				2.wait;
				a[2]=~squiz.(15,35);
				20.wait;
				c[0]=~patt.(0.01,midfre:10,amp:0.3);
				b[1]=~lp.(650);
				5.wait;
				a[2]=~squiz.(12,7);
				15.wait;
				b[1]=~lp.(850);
				15.wait;
				c[1]=~lfSaw.(freq:[110,311,170],midR:[0.5,18,0.1],amp:0.03,low:0.01,high:10);
				25.wait;
				a[0]=~waveC.(dust:4,dur:3,low:260,high:1000,amp:0.03);
				a[1]=~vibrato.(0.01,0.5,0.05);
				25.wait;
				b[0]=~saw2.(9,0.2,4,60,35,0.1,2,13,amp:0.05);
				b[1]=~squiz.(3,1.5);
				20.wait;
				c[0]=nil;
		        a[0]=~waveC.(dust:4,dur:3,low:260,high:1000,amp:0.03);
				a[1]=~vibrato.(0.01,13,0.05);
		        17.wait;
				a[0]=~waveC.(dust:4,dur:3,low:260,high:1000,amp:0.03);
				a[1]=~vibrato.(0.01,13,0.05);
				a[2]=nil;
				24.wait;
				c[1]=nil;
				c[0]=~henonN.(30,rate:0.1,amp:0.1,start:100,end:300);
				c[1]=~vibrato.(6,3,0.6);
				c[2]=~bp.(400,5);
				20.wait;
				a[0]=~card.(freq:[323,200,250]+200,rate:[3,0.2,5],start:0.01,end:13,low:0.1,high:90);
				a[1]=~vibrato.(0.2,29,0.8);
				a[2]=~hp.(700,0.5);
				a[3]=~hp.(400,0.5);
				12.wait;
				b[0]=~pattM.(midR:4,freq:500,low:0.01,high:7,amp:0.05);
				b[1]=~squiz.(2.3,24);
				15.wait;
				c[0]=~pattM.(midR:4,freq:500,low:0.01,high:7,amp:0.05);
				c[1]=~squiz.(9,204);
				c[2]=nil;
				15.wait;
				a[2]=nil;
				a[3]=nil;
				a[0]=~card.(amp:0.1);
				a[1]=~vibrato.(24,29,0.8);
				15.wait;
				b[0]=~pattM.(midR:4,freq:500,low:0.01,high:7,amp:0.05);
				b[1]=~squiz.(9,154);
				15.wait;
				b[0]=~card.();
				b[1]=~vibrato.(24,29,0.6);
				b[2]=~highRF.(ratio1:8,ratio2:0.5);
				15.wait;
				c[0]=~sinO.(103,53,5,low:0.1,high:23,amp:0.08);
				c[1]=~lowRF.(3,start:850,high:9,rq:0.05);
				c[2]=~rvb.();
				15.wait;
				b.source=nil;
				c[0]=~sinO.(103,53,5,low:0.1,high:23,amp:0.08);
				c[1]=~lowRF.(5,start:750,high:9,rq:0.05);
				c[2]=~rvb.();
				15.wait;
				a[0]=~speak.(300,amp:0.1);
				a[1]=~lowRF.();
				a[2]=~rvb.();
				9.wait;
				c[0]=~sinO.(103,53,5,low:0.1,high:23,amp:0.08);
				c[1]=~lowRF.(7,start:750,high:9,rq:0.03);
				c[2]=~rvb.();
				15.wait;
				c[0]=~sinO.(103,53,5,low:0.1,high:23,amp:0.08);
				c[1]=~lowRF.(9,start:650,high:9,rq:0.02);
				c[2]=~rvb.();
				6.wait;
				a[0]=~speak.(500,amp:0.1);
				a[1]=~lowRF.();
				a[2]=~rvb.();
				15.wait;
				a[3]=~glitchOut.(dur:5, startFreq:100, endFreq: 0);
				c[3]=~glitchOut.(dur:5, startFreq:100, endFreq: 0);
				15.wait;
				a[3]=~glitchOut.(dur:5, startFreq:0, endFreq: 100);
				c[3]=~glitchOut.(dur:5, startFreq:0, endFreq: 100);
				4.wait;
				a[3]=nil;
				c[3]=nil;
				15.wait;
				c[0]=~sinO.(103,53,5,low:0.1,high:23,amp:0.08);
				c[1]=~lowRF.(12,start:650,high:9,rq:0.01);
				c[2]=~rvb.();
				20.wait;
				a[0]=~speak.(700,amp:0.1);
				a[1]=~lowRF.();
				a[2]=~rvb.();
				15.wait;
				c[0]=~sinO.(103,53,5,low:0.1,high:23,amp:0.08);
				c[1]=~lowRF.(15,start:450,high:9,rq:0.01);
				c[2]=~rvb.();
				20.wait;
				a[3]=~glitchOut.(dur:9, startFreq:1000, endFreq: 0);
				c[3]=~glitchOut.(dur:9, startFreq:1000, endFreq: 0);
				20.wait;
				a[3]=~glitchOut.(dur:7, startFreq:0, endFreq: 1000);
				c[3]=~glitchOut.(dur:7, startFreq:0, endFreq: 1000);
				4.wait;
				a[3]=nil;
				c[3]=nil;
				10.wait;
				c[0]=~sinO.(103,53,5,low:0.1,high:23,amp:0.08);
				c[1]=~lowRF.(15,start:450,high:9,rq:0.01);
				c[2]=~rvb.();
				20.wait;
				b[0]=~speak.();
				b[1]=~lowRF.();
				b[2]=~rvb.(0.7,0.8,0.8);
				b[3]=~bp.(1500,4);
				15.wait;
				c.source=nil;
				c[1]=~panN.(80,13,20,1,400,amp:0.05);
				15.wait;
				a.source=nil;
				30.wait;
				c[0]=~saw2.(9,0.2,4,60,35,0.1,2,13);
				c[1]=~vibrato.(0.01,1,0.5);
				c[2]=~lp.(400,1);
				23.wait;
				b.source=nil;
				c[0]=~saw2.(9,0.2,4,60,35,0.1,2,13);
				c[1]=~vibrato.(0.01,12,0.1);
				c[2]=~lp.(400,1);
				28.wait;
				b[0]=~henonN.(30,rate:0.1,amp:0.01,start:100,end:300);
				b[1]=~lp.(1500);
				b[2]=~hp.(1000);
				25.wait;
				a[0]=~patt.(8,midfre:0.01);
				a[1]=~highRF.(0.01,0.01);
				20.wait;
				c.source=nil;
				20.wait;
				b.source=nil;
				2.wait;
				b[1]=~waveC.(dust:1,dur:7,low:120,end:500,amp:0.01);
				20.wait;
				c[0]=~fbSin.();
				15.wait;
				c[1]=~rvb.();
				20.wait;
				c[3]=~blip.(30,freq:21,exp:9,period:0.01);
				a.source=nil;
				20.wait;
				c.source=nil;
				b[0]=~blip.(30,freq:21,exp:9,period:0.01);
			}
		})

~installation2.play;




