(
(
~transferKVs = { | keys, targetkeys|
	var oldEvent, holdEvent;
	holdEvent = { oldEvent = currentEnvironment };
	Pfunc({ |  ev |
			ev[\finish] = holdEvent;
					if (oldEvent.notNil) {
						keys.do { | k, i | ev[ targetkeys[i] ] = oldEvent[k] };
					};
					0
	});
};
//STR_REB

(
// Pluck going through CombC
// pluck ranges from 50 to 2kHz

SynthDef(\str_reb,{
	|out=0,amp=0.1,cur=(-1),gate=1,
	iHDP=0.02,fHDP=0.02,			// delay max of Pluck
 	iLDP=0.0005,fLDP=0.0005,		// delay min of Pluck
	iDR=0.1,fDR=0.1,						// rate of random delay selections
	iG=2,fG=2,								//number of impulses
	iLDC=0.01,fLDC=0.01,				//del min of CombN
	iHDC=0.016,fHDC=0.016,		//del max of CombN
	iDEC=3,fDEC=3,						//decay of ComN
	baseT=0,devT=0|
	var env,sig, dur,bsig,delP,delC,envDelR,envG,envLDP,envHDP,envLDC,envHDC,envDEC,maxTenv,envT;
	dur = baseT+ devT;
	env = EnvGen.kr(Env([-1, -1,1],[baseT,devT],[cur]));
	envDelR =env.range( iDR, fDR);
	envG = 	env.range( iG, fG);
	envLDP = 	env.range( iLDP, fLDP);//low delPluck
	envHDP = env.range( iHDP, fHDP); //high delPluck
	envLDC = env.range( iLDC, fLDC); //low delComb
	envHDC= 	env.range( iHDC, fHDC);//high delComb
	envDEC = env.range( iDEC, fDEC);

	delP = TExpRand.kr(envLDP,envHDP,Impulse.kr(envDelR));
	sig = Pluck.ar(ClipNoise.ar(0.4),Dust.ar(envG),2,delP,3,0.34);

	delC = SinOsc.kr(envDelR).range(envLDC,envHDC);
	sig = CombN.ar(sig,2,delC,envDEC);

	sig = sig* EnvGen.kr(Env([0,amp,amp,0], [0.01,dur,0.5], cur), gate, doneAction:2);
	Out.ar(out,sig);
}).add
);
/*
Synth(\str_reb,[\baseT,7,\devT,7,\iHDP,0.02,\fHDP,0.02,\iLDP,0.05,\fLDP,0.05,\iDR,0.1,\iG,2,\fG,2,\iLDC,0.01,\fLDC,0.01,\iHDC,0.016,\fHDC,0.016,\iDEC,0.4,\fDEC,0.4]);
Synth(\str_reb,[\baseT,7,\devT,7,\iHDP,0.02,\fHDP,0.02,\iLDP,0.0005,\fLDP,0.0005,\iDR,0.1,\iG,20,\fG,20,\iLDC,0.05,\fLDC,0.05,\iHDC,0.206,\fHDC,0.206,\iDEC,3,\fDEC,3])
Synth(\str_reb,[\baseT,7,\devT,7,\iHDP,0.02,\fHDP,0.02,\iLDP,0.0005,\fLDP,0.0005,\iDR,0.4,\iG,2,\fG,2,\iLDC,0.05,\fLDC,0.05,\iHDC,0.206,\fHDC,0.206,\iDEC,3,\fDEC,3])
Synth(\str_reb,[\baseT,7,\devT,7,\iHDP,0.02,\fHDP,0.02,\iLDP,0.0005,\fLDP,0.0005,\iDR,3.2,\iG,2,\fG,2,\iLDC,0.001,\fLDC,0.001,\iHDC,0.13,\fHDC,0.13,\iDEC,3,\fDEC,3])
Synth(\str_reb,[\baseT,7,\devT,7,\iHDP,0.02,\fHDP,0.02,\iLDP,0.0005,\fLDP,0.0005,\iDR,0.08,\iG,4,\fG,4,\iLDC,0.001,\fLDC,0.001,\iHDC,0.136,\fHDC,0.136,\iDEC,3,\fDEC,3])
Synth(\str_reb,[\baseT,9,\devT,9,\iHDP,0.0005,\fHDP,0.0005,\iLDP,0.02,\fLDP,0.02,\iDR,12,\iG,2,\fG,2,\iLDC,0.001,\fLDC,0.001,\iHDC,0.2,\fHDC,0.2,\iDEC,1,\fDEC,1])
Synth(\str_reb,[\baseT,7,\devT,7,\iHDP,0.01,\fHDP,0.01,\iLDP,0.05,\fLDP,0.05,\iDR,30,\iG,2,\fG,2,\iLDC,0.01,\fLDC,0.01,\iHDC,0.001,\fHDC,0.001,\iDEC,0.3,\fDEC,1])
Synth(\str_reb,[\baseT,7,\devT,7,\iHDP,0.001,\fHDP,0.001,\iLDP,0.0005,\fLDP,0.0005,\iDR,18,\fDR,18,\iG,60,\fG,60,\iLDC,0.01,\fLDC,0.01,\iHDC,0.05,\fHDC,0.05,\iDEC,0.2,\fDEC,0.2])
*/



/*
wdr1 weight of slow delay rate
wdr2 weight of mid delay rate
wdr3 weight of fast delay rate
wl weight for low frequency
wh high frequency
bD  duration in start state
dD  duration to end state
ou   output
am  amp
pN
*/
//~reb_trans.(wg:0.3,wn:0.3,wdr1:0.33,wdr2:0.33,wdr3:0.33,wl:0.5,wh:0.5,bD:9,dD:9,grp:0,ou:0,am:0.04,pN:1).play
(
~reb_trans={|wg=0.7,wn=0.3,wdr1=0.33,wdr2=0.33,wdr3=0.33,wl=0.5,wh=0.5,bD,dD,grp,ou,am=0.04,pN|
	Pdef("reb_tran%".format(pN).asSymbol,
			Pbind(*[
					instrument: 	\str_reb,
					baseT:		 	bD,
					devT:			dD,
					amp:				am,
	   				group:		 	grp,
					bar: 			~transferKVs.(#[fHDP,fG,fLDC,fHDC,fDR,fD,fLDP],#[iHDP,iG,iLDC,iHDC,iDR,iD,iLDP]),
					cur:				Pwhite(-2,2),
					out:				ou,
					dur:				Pseq([0, Pkey(\baseT)+Pkey(\devT)]),
					fD:				Pwhite(0.03,3),
					fHDP:			Pwrand([Pexprand(0.0007,0.02,1),Pexprand(0.0005,0.0001,1)],[wl,wh],inf),
					fLDP:			Pwrand([Pwhite(0.0007,0.02,1),Pwhite(0.0005,0.0001,1)],[wl,wh],inf),
					fG:				Pwrand([Pwhite(2,6,1),Pwhite(16,200,1)],[wg,wn],inf),
					fDR:				Pwrand([Pwhite(0.03,0.2,1),Pwhite(6,14,1),Pwhite(20,34,1)],[wdr1,wdr2,wdr3],inf),
					fLDC:			Pwrand([Pwhite(0.005,1.3,1),Pwhite(0.004,0.001,1)],[wl,wh],inf),
					fHDC:			Pwrand([Pexprand(0.005,1.3,1),Pexprand(0.004,0.001,1)],[wl,wh],inf),

			])
	)};
);

(
//diferent from str_reb in the use of LFNoise2 for delay instead of SinOsc.
SynthDef(\str_harm,{
	|out=0,amp=0.1,cur=(-1),gate=1,
	iHDP=0.02,fHDP=0.02,			// delay max of Pluck
 	iLDP=0.0005,fLDP=0.0005,		// delay min of Pluck
	iDR=0.1,fDR=0.1,						// rate of random delay selections
	iG=2,fG=2,								//number of impulses
	iLDC=0.01,fLDC=0.01,				//del min of CombN
	iHDC=0.016,fHDC=0.016,		//del max of CombN
	iDEC=3,fDEC=3,						//decay of ComN
	baseT=0,devT=0|
	var sig,dur,delP,delC,envDR,envG,envLDP,envHDP,envLDC,envHDC,envDelR,envDEC,envT,env;
	dur=baseT+devT;
	env = EnvGen.kr(Env([-1, -1,1],[baseT,devT],[cur]));
	envDelR =  	env.range(iDR,fDR);
	envG = 	  	env.range(iG,fG);
	envLDP =  	env.range(iLDP,fLDP); //low delPluck
	envHDP = 	env.range(iHDP,fHDP);//high delPluck
	envLDC = 	env.range(iLDC,fLDC); //low delComb
	envHDC=  	env.range(iHDC,fHDC);//high delComb
	envDEC = 	env.range(iDEC,fDEC);

	delP = 			TExpRand.kr(envLDP,envHDP,Impulse.kr(envDelR));
	sig = 			Pluck.ar(ClipNoise.ar(0.4),Dust.ar(envG),2,delP,3,0.34);

	delC = 			LFNoise2.kr(envDelR).range(envLDC,envHDC);
	sig = 			CombN.ar(sig,2,delC,envDEC)*amp;

	sig = 			sig* EnvGen.kr(Env([0,amp,amp,0],[0.01,dur,0.5],cur),gate,doneAction:2);
	Out.ar(out,sig)
}).add
);
/*
Synth(\str_harm,[\baseT,7,\devT,7,\iHDP,0.02,\fHDP,0.02,\iLDP,0.05,\fLDP,0.05,\iDR,0.1,\iG,2,\fG,2,\iLDC,0.01,\fLDC,0.01,\iHDC,0.016,\fHDC,0.016,\iDEC,0.4,\fDEC,0.4]);
Synth(\str_harm,[\baseT,7,\devT,7,\iHDP,0.02,\fHDP,0.02,\iLDP,0.0005,\fLDP,0.0005,\iDR,0.1,\iG,20,\fG,20,\iLDC,0.05,\fLDC,0.05,\iHDC,0.206,\fHDC,0.206,\iDEC,3,\fDEC,3])
Synth(\str_harm,[\baseT,7,\devT,7,\iHDP,0.02,\fHDP,0.02,\iLDP,0.0005,\fLDP,0.0005,\iDR,0.4,\iG,2,\fG,2,\iLDC,0.05,\fLDC,0.05,\iHDC,0.206,\fHDC,0.206,\iDEC,3,\fDEC,3])
Synth(\str_harm,[\baseT,7,\devT,7,\iHDP,0.02,\fHDP,0.02,\iLDP,0.0005,\fLDP,0.0005,\iDR,3.2,\iG,2,\fG,2,\iLDC,0.001,\fLDC,0.001,\iHDC,0.13,\fHDC,0.13,\iDEC,3,\fDEC,3])
Synth(\str_harm,[\baseT,7,\devT,7,\iHDP,0.02,\fHDP,0.02,\iLDP,0.0005,\fLDP,0.0005,\iDR,0.08,\iG,4,\fG,4,\iLDC,0.001,\fLDC,0.001,\iHDC,0.136,\fHDC,0.136,\iDEC,3,\fDEC,3])
Synth(\str_harm,[\baseT,9,\devT,9,\iHDP,0.0005,\fHDP,0.0005,\iLDP,0.02,\fLDP,0.02,\iDR,12,\iG,2,\fG,2,\iLDC,0.001,\fLDC,0.001,\iHDC,0.2,\fHDC,0.2,\iDEC,1,\fDEC,1])
Synth(\str_harm,[\baseT,7,\devT,7,\iHDP,0.01,\fHDP,0.01,\iLDP,0.05,\fLDP,0.05,\iDR,30,\iG,2,\fG,2,\iLDC,0.01,\fLDC,0.01,\iHDC,0.001,\fHDC,0.001,\iDEC,0.3,\fDEC,1])
Synth(\str_harm,[\baseT,7,\devT,7,\iHDP,0.001,\fHDP,0.001,\iLDP,0.0005,\fLDP,0.0005,\iDR,18,\fDR,18,\iG,60,\fG,60,\iLDC,0.01,\fLDC,0.01,\iHDC,0.05,\fHDC,0.05,\iDEC,0.2,\fDEC,0.2])
*/

/*
wdr1 weight of slow delay rate
wdr2 weight of mid delay rate
wdr3 weight of fast delay rate
wl weight for low frequency
wh high frequency
bD  duration in start state
dD  duration to end state
ou   output
am  amp
pN
*/
(
~harm_trans={|wg=0.7,wn=0.3,wdr1=0.5,wdr2=0.3,wdr3=0.2,wl=0.5,wh=0.5,bD,dD,grp,ou,am=0.06,pN|
	Pdef("harm_tran%".format(pN).asSymbol,
			Pbind(*[
				instrument:\str_harm,
				baseT:			bD,
				devT:			dD,
				amp:				am,
	    		group:			grp,
				cur:				Pwhite(-2,2),
				out:				ou,
				bar: 				~transferKVs.(#[fHDP,fG,fLDC,fHDC,fDR,fD,fLDP],#[iHDP,iG,iLDC,iHDC,iDR,iD,iLDP]),
				dur:				Pseq([0,Pkey(\baseT)+Pkey(\devT)]),
				fD:				Pwhite(0.8,3),
				fHDP:			Pwrand([Pwhite(0.005,0.02,1),Pwhite(0.0005,0.0001,1)],[wl,wh],inf),
				fLDP:			Pwrand([Pwhite(0.0007,0.02,1),Pwhite(0.0005,0.0001,1)],[wl,wh],inf),
				fG:				Pwrand([Pwhite(2,6,1),Pwhite(16,200,1)],[wg,wn],inf),
				fDR:				Pwrand([Pwhite(0.08,0.5,1),Pwhite(6,14,1),Pwhite(20,34,1)],[wdr1,wdr2,wdr3],inf),
				fLDC:			Pwrand([Pwhite(0.005,1.3,1),Pwhite(0.004,0.001,1)],[wl,wh],inf),
				fHDC:			Pwrand([Pwhite(0.005,1.3,1),Pwhite(0.004,0.001,1)],[wl,wh],inf),
				])
		)};
);






//TIMP
(
//FBSineL going through a Pluck
SynthDef(\timpani, {
	|out=0,amp=0.7,cur=(-1),gate=1,
	iG=3,fG=3, 										//number of impulses
	iDel=0.067,fDel=0.067,					//delay of Pluck
	iDec=2.5,fDec=2.5,							//decay of Pluck
	iCoe=0.9,fCoe=0.9,							//coeficient of Pluck
	baseT=0,devT=0|
	var sig,dur,envG,envDel,envDec,envCoe,envT,env;
	dur = baseT+ devT;
	env = EnvGen.kr(Env([-1, -1,1],[baseT,devT],[cur]));
	envG= 			env.range(iG,fG);
	envDel=		env.range(iDel,fDel);
	envDec = 		env.range(iDec,fDec);
	envCoe = 		env.range(iCoe,fCoe);

	sig = FBSineL.ar(100,1,2.5,0.7,1.3,0.3,0.4, 5);

	sig = Pluck.ar(sig,Dust.kr(envG),2,envDel,envDec,envCoe);

	sig = sig* EnvGen.kr(Env([0,amp,amp,0],[0.01,dur,0.5],cur),gate,doneAction:2);
	Out.ar(out,sig)
}).add;
);

/*
Synth(\timpani,[\iG,5,\fG,5,\iDel,0.045,\fDel,0.045,\iCoe,0.9,\fCoe,0.9,\baseT,5,\devT,5])
Synth(\timpani,[\iG,5,\fG,5,\iDel,0.017,\fDel,0.017,\iCoe,0.99,\fCoe,0.99,\baseT,5,\devT,5])
Synth(\timpani,[\iG,7,\fG,7,\iDel,0.027,\fDel,0.027,\iDec,0.2,\fDec,0.2,\iCoe,0.99,\fCoe,0.99,\baseT,5,\devT,5])
Synth(\timpani,[\iG,37,\fG,37,\iDel,0.027,\fDel,0.027,\iDec,0.05,\fDec,0.05,\iCoe,0.5,\fCoe,0.5,\baseT,5,\devT,5])
Synth(\timpani,[\amp,0.3,\iG,437,\fG,437,\iDel,0.0027,\fDel,0.0027,\iDec,0.05,\fDec,0.05,\iCoe,0.5,\fCoe,0.5,\baseT,5,\devT,5])
*/


/*
wl weight for low frequency
wh high frequency
bD  duration in start state
dD  duration to end state
ou   output
am  amp
pN
*/
//~timp_trans.(wg:0.5,wn:0.5,wl:0.5,wh:5,bD:9,dD:9,grp:0,ou:0,am:0.15,pN:1).play
~timp_trans={|wg,wn,wl,wh,bD,dD,grp,ou,am=0.15,pN|

Pdef("timp_tran%".format(pN).asSymbol,Pbind(*[
			instrument: \timpani,
			group:		grp,
			out:			ou,
			amp:		    am,

			baseT:		bD,
			devT:		dD,
			dur:			Pseq([0, Pkey(\baseT)+Pkey(\devT)]),
							// force an initializing event of zero duration

			bar: 			~transferKVs.(#[fDel, fDec, fCoe, fG], #[iDel, iDec, iCoe, iG]),
						// previous target values become starting values
			fDec:			Pwhite(0.05,2.5),
			fDel:			Pwhite().lincurve(0, 1, 0.000017,0.06 , 0).trace,
							// use Pdefn for interactive control
			cur:			Pwhite(-2,2),
			fG:			Pwrand([Pwhite(2,6,1),Pwhite(30,200,1)],[wg,wn],inf),
			fDel:			Pwrand([Pwhite(0.06,0.006,1),Pwhite(0.000017,0.0055,1)],[wl,wh],inf),
			fCoe:		Pwrand([Pwhite(0.8,0.99,1),Pwhite(0.1,0.7,1)],[wl,wh],inf),

]));
};

//ARP_HARM----

(
//PinkNoise going through a Pluck that is articulated by StandardTrig. The rsuting signal is filtered with BPF
SynthDef(\arp_harm,{
	|out=0,amp=0.4,cur=(-1),gate=1,
	iDel=0.0042,fDel=0.0042,				//Delay of Pluck
	iDec=2,fDec=2,								//Dec of Pluck
	iFR=13,fFR=13,								//Frequency rate
	iLF=400,fLF=400,								//min frequency
	iHF=1200,fHF=1200,						//max frequency
	iQ=0.1,fQ=0.1,								//rq of BPF
	baseT=0,devT=0
	|
	var sig,dur,trig,envDel,envDec,envFR,envLF,envHF,envQ,envT,env,bpf_Freq;
	dur=		baseT+devT;
	env = 		EnvGen.kr(Env([-1, -1,1],[baseT,devT],[cur]));
	envDel = 	env.range(iDel,fDel);
	envDec = 	env.range(iDec,fDec);
	envFR = 	env.range(iFR,fFR);
	envLF = 	env.range(iLF,fLF);
	envHF = 	env.range(iHF,iHF,fHF);
	envQ = 	env.range(iQ,fQ);

	trig = 			StandardTrig.ar(10,50,TRand.kr(0.01,1,Impulse.kr(4)),0.2,0.3);

	bpf_Freq = 	LFNoise0.kr(envFR).range(envLF,envHF);
	sig = 			Pluck.ar(PinkNoise.ar,trig,2,envDel,envDec,0.9);
	sig= 			BPF.ar(sig,bpf_Freq,envQ)*amp;

	sig = sig* EnvGen.kr(Env([0,amp,amp,0],[0.01,dur,0.5],cur),gate,doneAction:2);
	Out.ar(out,sig);
}).add
);
/*
Synth(\arp_harm,[\iDel,0.06,\fDel,0.06,\iDec,2,\fDec,2,\iFR,13,\fFR,13,\iLF,400,\fLF,400,\iHF,1200,\fHF,1200,\iQ,0.1,\fQ,0.1,\baseT,5,\devT,5])
Synth(\arp_harm,[\iDel,0.03,\fDel,0.03,\iDec,2,\fDec,2,\iFR,13,\fFR,13,\iLF,200,\fLF,200,\iHF,600,\fHF,600,\iQ,0.4,\fQ,0.4,\baseT,5,\devT,5])
Synth(\arp_harm,[\iDel,0.001,\fDel,0.001,\iDec,0.3,\fDec,0.3,\iFR,13,\fFR,13,\iLF,200,\fLF,200,\iHF,800,\fHF,800,\iQ,0.4,\fQ,0.4,\baseT,5,\devT,5,\amp,0.7])
Synth(\arp_harm,[\iDel,0.005,\fDel,0.005,\iDec,0.3,\fDec,0.3,\iFR,0.5,\fFR,0.5,\iLF,200,\fLF,200,\iHF,1200,\fHF,1200,\iQ,0.9,\fQ,0.9,\baseT,5,\devT,5])
Synth(\arp_harm,[\iDel,0.001,\fDel,0.001,\iDec,2,\fDec,2,\iFR,08,\fFR,8,\iLF,100,\fLF,100,\iHF,300,\fHF,300,\iQ,0.3,\fQ,0.3,\baseT,5,\devT,5,\amp,1.3])*/

/*
wl weight for low frequency
wh high frequency
bD  duration in start state
dD  duration to end state
ou   output
am  amp
pN
*/
//~arp_trans.(wl:0.5,wh:0.5,bD:5,dD:5,grp:0,ou:0,am:0.7,pN:1).play//lllll
(
~arp_trans={|wl=0.5,wh=0.5,bD,dD,grp,ou,am=0.7,pN|
	Pdef("arp_tran%".format(pN).asSymbol,
		Pseq([
			Pbind(*[
				instrument:\arp_harm,
				baseT:		bD,
				devT:		dD,
				amp:			am,
	    		group:		grp,
				cur:			Pwhite(-2,2),
				out:			ou,
				dur:			Pseq([0,Pkey(\baseT)+Pkey(\devT)]),
				bar: 			~transferKVs.(#[fQ,fDec,fFR,fDel,fLF,fHF],#[iQ,iDec,iFR,iDel,iLF,iHF]),
				fQ:			Pwhite(0.1,0.9),
				fDec:			Pwhite(0.07,2),
				fFR:			Pwhite(0.5,30),
				fDel:			Pwrand([Pwhite(0.008,0.03,1),Pwhite(0.006,0.001,1)],[wl,wh],inf),
				fLF:			Pwrand([Pwhite(40,500,1),Pwhite(500,1800,1)],[wl,wh],inf),
				fHF:			Pwrand([Pwhite(40,500,1),Pwhite(500,1800,1)],[wl,wh],inf),
					])
				])
			)};
);

//ACEL----
(
//LFPulse going through a CombN
SynthDef(\acel,{
	|out=0,amp=0.3,gate=1,cur=(-1),
	iF=300,fF=300,								//frequency
	iR=13,fR=13,									//rate of change for delay
	iLD=0.001,fLD=0.001,						//min delay
	iHD=0.08,fHD=0.08,						//max delay
	iDEC=7,fDEC=7,								//decay
	baseT=0,devT=0|
	var sig,dur,env,envT,envF,envR,envLD,envHD,envDEC;
	dur = baseT+devT;
	env = 		EnvGen.kr(Env([-1, -1,1],[baseT,devT],[cur]));
	envF=		env.range(iF,fF);
	envR=		env.range(iR,fR);
	envLD=		env.range(iLD,fLD);
	envHD=	env.range(iHD,fHD);
	envDEC=	env.range(iDEC,fDEC);

	sig = 		LFPulse.ar(envF,0,0.5);
	sig = 		CombN.ar(sig,4,LFNoise1.ar(envR).range(envLD,envHD),envDEC)*amp;

	sig= 		sig* EnvGen.kr(Env([0,amp,amp,0],[0.01,dur,0.5],cur),gate,doneAction:2);
	Out.ar(out,sig)
}).add;
);
//dec<4
/*
Synth(\acel,[\iF,1500,\fF,1500,\iR,13,\fR,13,\iLD,0.01,\fLD,0.01,\iHD,0.08,\fHD,0.08,\iDEC,3,\fDEC,3,\baseT,5,\devT,5])
Synth(\acel,[\iF,1500,\fF,1500,\iR,0.1,\fR,0.1,\iLD,0.01,\fLD,0.01,\iHD,0.05,\fHD,0.05,\iDEC,3,\fDEC,3,\baseT,8,\devT,8])
Synth(\acel,[\iF,300,\fF,300,\iR,13,\fR,13,\iLD,0.1,\fLD,0.1,\iHD,1,\fHD,1,\iDEC,3,\fDEC,3,\baseT,8,\devT,8])
Synth(\acel,[\iF,400,\fF,400,\iR,13,\fR,13,\iLD,0.006,\fLD,0.006,\iHD,0.012,\fHD,0.012,\iDEC,0.4,\fDEC,0.4,\baseT,8,\devT,8])
Synth(\acel,[\iF,400,\fF,400,\iR,3,\fR,3,\iLD,0.006,\fLD,0.006,\iHD,0.012,\fHD,0.012,\iDEC,2,\fDEC,2,\baseT,8,\devT,8])
Synth(\acel,[\iF,300,\fF,300,\iR,0.3,\fR,0.3,\iLD,0.019,\fLD,0.019,\iHD,0.012,\fHD,0.012,\iDEC,2,\fDEC,2,\baseT,8,\devT,8])
Synth(\acel,[\iF,300,\fF,300,\iR,37,\fR,37,\iLD,0.01,\fLD,0.01,\iHD,0.0052,\fHD,0.082,\iDEC,2,\fDEC,2,\baseT,8,\devT,8])
Synth(\acel,[\iF,300,\fF,300,\iR,107,\fR,107,\iLD,0.01,\fLD,0.01,\iHD,0.0062,\fHD,0.0062,\iDEC,0.6,\fDEC,0.6,\baseT,8,\devT,8])
Synth(\acel,[\iF,200,\fF,200,\iR,101,\fR,101,\iLD,0.12,\fLD,0.12,\iHD,0.62,\fHD,0.62,\iDEC,3,\fDEC,3,\baseT,8,\devT,8])
*/

/*
wr1  weight of slow freq rate
wr2 weight of mid freq rate
wr3 weight of fast freq rate
wl weight for low frequency
wh high frequency
bD  duration in start state
dD  duration to end state
ou   output
am  amp
pN
*/

//~acel_trans.(wr1:0.33,wr2:0.33,wr3:0.33,wl:0.5,wh:0.5,bD:3,dD:5,grp:0,ou:0,am:0.09,pN:1).play
(
~acel_trans={|wr1=0.33,wr2=0.33,wr3=0.33,wl=0.5,wh=0.5,bD=3,dD=5,grp,ou,am=0.04,pN|
	Pdef("acel_tran%".format(pN).asSymbol,
			Pbind(*[
				instrument:\acel,
				baseT:		bD,
				devT:		dD,
				amp:			am,
				out:			ou,
				group:		grp,
				bar: 			~transferKVs.(#[fD,fF,fR,fLD,fHD],#[iD,iF,iR,iLD,iHD]),
				cur:			Pwhite(-2,2),
				fD:			Pwhite(0.4,8),
				fF:				Pwrand([Pwhite(100,300,1),Pwhite(350,700,1)],[wl,wh],inf),
				fR:			Pwrand([Pwhite(0.01,0.3,1),Pwhite(7,11,1),Pwhite(11,100,1)],[wr1,wr2,wr3],inf),
				fLD:			Pwrand([Pwhite(0.003,0.1,1),Pwhite(0.0001,0.002,1)],[wl,wh],inf),
				fHD:			Pwrand([Pwhite(0.003,0.1,1),Pwhite(0.0001,0.002,1)],[wl,wh],inf),
				dur:			Pseq([0,Pkey(\baseT)+Pkey(\devT)]),
			])
		)};
);

//SYNC------
(
//SyncSaw
SynthDef(\sync_talk,{
	|out=0,amp=0.3,gate=1,cur=(-1),
	iFR=9,fFR=9,									//frequency rate of change
	iLF=100,fLF=100,								//min frequency
	iHF=300,fHF=300,							//max fequency
	iHR=13,fHR=13,								//rate of change of harmonics
	iLH=50,fLH=50,								//min harmonics
	iHH=700,fHH=700,							//max harmonics
	baseT=0,devT=0|
	var sig,dur,n3,freq,harm,envT,envF,envLF,envHF,envHR,envLH,envHH,env;
	dur = baseT+devT;
	env = 		EnvGen.kr(Env([-1, -1,1],[baseT,devT],[cur]));
	envF=		env.range(iFR,fFR);
	envLF=		env.range(iLF,fLF);
	envHF=		env.range(iHF,fHF);
	envHR=	env.range(iHR,fHR);
	envLH=		env.range(iLH,fLH);
	envHH=	env.range(iHH,fHH);

	n3=			LFDNoise3;
	freq =		n3.kr(envF).range(envLF,envHF);
	harm = 	n3.kr(envHR).range(envLH,envHH);
	sig=			SyncSaw.ar(freq,harm)*amp;

	XOut.ar(out,EnvGen.kr(Env([0,1,1],[0.6,dur],cur),gate,doneAction:2),sig)
}).add
);

/*
Synth(\sync_talk,[\iFR,8,\fFR,8,\iLF,100,\fLF,100,\iHF,300,\fHF,300,\iHR,4,\fHR,4,\iLH,40,\fLH,40,\iHH,900,\fHH,900,\baseT,5,\devT,5])
Synth(\sync_talk,[\iFR,8,\fFR,8,\iLF,100,\fLF,100,\iHF,300,\fHF,300,\iHR,4,\fHR,4,\iLH,50,\fLH,50,\iHH,700,\fHH,700,\baseT,5,\devT,5])
Synth(\sync_talk,[\iFR,23,\fFR,23,\iLF,200,\fLF,200,\iHF,400,\fHF,400,\iHR,6,\fHR,6,\iLH,320,\fLH,320,\iHH,1200,\fHH,1200,\baseT,5,\devT,5])
Synth(\sync_talk,[\iFR,1,\fFR,1,\iLF,100,\fLF,100,\iHF,300,\fHF,300,\iHR,6,\fHR,6,\iLH,320,\fLH,320,\iHH,800,\fHH,800,\baseT,5,\devT,5])
Synth(\sync_talk,[\iFR,3,\fFR,3,\iLF,130,\fLF,130,\iHF,200,\fHF,200,\iHR,16,\fHR,16,\iLH,520,\fLH,520,\iHH,900,\fHH,900,\baseT,5,\devT,5])
Synth(\sync_talk,[\iFR,21,\fFR,21,\iLF,100,\fLF,100,\iHF,300,\fHF,300,\iHR,6,\fHR,6,\iLH,320,\fLH,320,\iHH,1200,\fHH,1200,\baseT,5,\devT,5])
*/

/*
wr1  weight of slow freq rate
wr2 weight of fast freq rate
wl weight for low frequency
wh high frequency
bD  duration in start state
dD  duration to end state
ou   output
am  amp
pN
*/

//~sync_trans.(wr1:0.33,wr2:0.33,wl:0.5,wh:0.5,bD:8,dD:8,grp:0,ou:0,am:0.07,pN:1).play
(
~sync_trans={|wr1=0.33,wr2=0.33,wl=0.5,wh=0.5,bD=3,dD=5,grp,ou,am=0.07,pN|
	Pdef("sync_tran%".format(pN).asSymbol,
			Pbind(*[
				instrument:\sync_talk,
				baseT:		bD,
				devT:		dD,
				amp:			am,
				group:	    grp,
				cur:			Pwhite(-2,2),
				out:			ou,
			    dur:			Pseq([0,Pkey(\baseT)+Pkey(\devT)]),
			    bar: 			~transferKVs.(#[fHR,fFR,fLF,fHF,fLH,fHH],#[iHR,iFR,iLF,iHF,iLH,iHH]),
				fHR:			Pwhite(1,17,inf),
			    fFR:			Pwrand([Pwhite(1,10,1),Pwhite(10,100,1)],[wr1,wr2],inf),
			    fLF:			Pwrand([Pwhite(40,300,1),Pwhite(300,500,1)],[wl,wh],inf),
				fHF:			Pwrand([Pwhite(40,300,1),Pwhite(300,500,1)],[wl,wh],inf),
				fLH:			Pwrand([Pwhite(50,500,1),Pwhite(500,700,1)],[wl,wh],inf),
				fHH:			Pwrand([Pwhite(50,700,1),Pwhite(500,700,1)],[wl,wh],inf),
					])
		)};
);
);



(//effects
(
SynthDef(\Pan2,{ | in,out=0,gate=1, fadeTime=0.5,pos=0|
  var audioIn = In.ar(in);
  var audio = Pan2.ar(audioIn,pos);
  Out.ar(out, audio*EnvGen.kr(Env([0,1,1,0],[0.01,fadeTime-0.5,0.5],-1),gate,doneAction:2));
}).add;
);
(
SynthDef(\fade_in,{ | in,out=0,gate=1, fadeTime=0.5,di=5|
  var audio = In.ar(in);
  ReplaceOut.ar(out, audio*EnvGen.kr(Env([0,1,1,0],[fadeTime/di,(di-1)*(fadeTime/di)],[-1]),gate,doneAction:2));
}).add;
);
(
SynthDef(\FreeV,{ | in,out=0, gate=1,fadeTime=0.5,dp=0.5,rC=0.5|
  var audioIn = In.ar(in);
	var rooM=LFNoise1.kr(rC).range(0.01,0.9);
  var audio = FreeVerb.ar(audioIn,rooM*5,rooM,dp);
  ReplaceOut.ar(out, audio*EnvGen.kr(Env([0,1,1,0],[0.01,fadeTime-0.5,0.5],-1),gate,doneAction:2));
}).add;
);
(
SynthDef(\PAmp,{ | in,out=0,gate=1,amR=0.1,lA=0.1,hA=1, fadeTime=0.5|
  var audioIn = In.ar(in);
	var ampM = LFNoise1.kr(amR).range(lA,hA);
  var audio = audioIn*ampM;
  ReplaceOut.ar(out, audio*EnvGen.kr(Env([0,1,1,0],[0.01,fadeTime-0.5,0.5],-1),gate,doneAction:2));
}).add;
);
(
SynthDef(\combo, { | out, in, dtime,fadeTime, gate=1,dec=2, ampC=0, lagT=16,vR=0.5|
	var sig, comv, mix,varN;
	dtime = {LFDNoise3.kr(LFNoise0.kr(0.5).range(0.007, 0.03)).exprange(8, 15555)}!37;
	dtime = dtime.reciprocal;
	varN = LFNoise1.kr(vR).range(0.001,ampC);
	ampC = {(0.001, 0.0015..0.07).choose}!37*varN;
	ampC = ampC.lag2(lagT);
	sig = In.ar(in, 1);
	comv = CombC.ar(sig, 0.2,dtime, dec, ampC);
	comv = Mix.new(comv);
	comv = comv;
	ReplaceOut.ar(out, comv*EnvGen.kr(Env([0,1,1,0],[0.01,fadeTime-0.5,0.5],-1),gate,doneAction:2))
}).add;
);
);


/*
This Chain allows the transitions from one restriction on the parameters to another in the same synth. This is the reason there are two instances of the same states, because one only recieves transitions from the same synth. This chain also allows transitions from a synth to a different one. It does so by finding a final state of the pattern ending to the new pattern that is starting.
*/



/*
wArr: Array of possible initial states
rateSC: Rate of change from Chain state to state (duration on each state)
sD: Duration of the starting section for each pattern
eD: Duration from development from starting state of parameters to next state
 group for the pattern to be allocated
out: bus to which the pattern is sent out
ptN: index of Pdef to be created
*/



(//rateSC is the rate of change from state to state in minutes
~wPfsm={|wArr=#[],rateSC,sD,eD,gRp,out,ptN|
Pfsm([
		wArr,
		//timp low
		Pfx(
			Plazy({                                       //wg,wn,wl,wh,bD,dD,grp,ou,am,pN
				Pfindur( rateSC* 60,~timp_trans.(1,0,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),
		((9!2)++[10,12]++(18..21)++(18..21)++(68..71)),//0 tg reducir (9..14) a solo gs en caso de querer mantener mas la text g

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~timp_trans.(0.5,0.5,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),(9..14),//1 tr

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~timp_trans.(0,1,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),([10,11,11,11,14,17]++(118!3)),//2 tn  ---(22..25)++(72++75) en caso de querer mas variaciones

		//timp low-high
		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~timp_trans.(1,0,0.5,0.5,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),[9,10,12,15],//3 tg

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~timp_trans.(0.5,0.5,0.5,0.5,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),(9..17),//4 tr

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~timp_trans.(0,1,0.5,0.5,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),[10,11,14,17],//5 tn

		//timp high
		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~timp_trans.(1,0,0,1,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),([12,15,16]++(26..29)++(76..79)++(76..79)++(76..79)),//6 tg

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~timp_trans.(0.5,0.5,0,1,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),(12..17),//7 tr

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~timp_trans.(0,1,0,1,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),([14,16,17]++(119!3)),//8 tn (30..31)++(80..83) for more variations

		//START of low
		//timp2 low
		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~timp_trans2.(1,0,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((9!2)++[10,12]++(18..21)++(18..21)++(68..71)),//9 tg

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~timp_trans2.(0.5,0.5,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),(9..14),//10 tr

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~timp_trans2.(0,1,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),([10,11,11,11,14,17]++(118!3)),//11 tn
		//timp2 low-high

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~timp_trans2.(1,0,0.5,0.5,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),[9,10,12,15],//12 tg

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~timp_trans2.(0.5,0.5,0.5,0.5,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),(9..17),//13 tr NOR

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~timp_trans2.(0,1,0.5,0.5,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),[10,11,14,17],//14 tn

		//timp2 high
		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~timp_trans2.(0.8,0,0,1,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),([12,15,16]++(26..29)++(76..79)++(76..79)++(76..79)),//15 tg

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~timp_trans2.(0.5,0.5,0,1,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),(12..17),//16 tr

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~timp_trans2.(0,0.8,0,1,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),([14,16,17]++(119!3)),//17 tn


		//START OF reb
		//reb low-grain                           wg,wn,wdr1,wdr2,wdr3,wl,wh,bD,dD,grp,ou,am,pN
		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~reb_trans.(1,0,1,0,0,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),([0]++(43..54)++(59..62)++(68..71)++(138!2)++(139!2)),//18

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~reb_trans.(1,0,0,1,0,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),([0]++(43..54)++(59..62)++(68..71)++(138!2)++(139!2)),//19

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~reb_trans.(1,0,0,0,1,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),([0]++(43..54)++(59..62)++(68..71)++(138!2)++(139!2)),//20

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~reb_trans.(1,0,0.33,0.33,0.33,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),([0]++(43..54)++(59..62)++(68..71)++(138!2)++(139!2)),//21
		//reb low-noise

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~reb_trans.(0,1,1,0,0,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((47..50)++(63..66)++(72..75)++(118!7)++(124..126)++(124..126)++(124..126)),//22

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~reb_trans.(0,1,0,1,0,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((47..50)++(63..66)++(72..75)++(118!7)++(124..126)++(124..126)++(124..126)),//23

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~reb_trans.(0,1,0,0,1,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((47..50)++(63..66)++(72..75)++(118!7)++(124..126)++(124..126)++(124..126)),//24

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~reb_trans.(0,1,0.33,0.33,0.33,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((47..50)++(63..66)++(72..75)++(118!7)++(124..126)++(124..126)++(124..126)),//25

		//reb high-grain
		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~reb_trans.(1,0,1,0,0,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((51..62)++(76..79)++(140!2)++(141!2)),//26

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~reb_trans.(1,0,0,1,0,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((51..62)++(76..79)++(140!2)++(141!2)),//27

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~reb_trans.(1,0,0,0,1,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((51..62)++(76..79)++(140!2)++(141!2)),//28

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~reb_trans.(1,0,0.33,0.33,0.33,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((51..62)++(76..79)++(140!2)++(141!2)),//29

		//reb high-noise
		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~reb_trans.(0,1,1,0,0,0,1,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((51..54)++(63..66)++(80..83)++(119!7)++(127..129)++(127..129)++(127..129)++(127..129)),//30

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~reb_trans.(0,1,0,1,0,0,1,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((51..54)++(63..66)++(80..83)++(119!7)++(127..129)++(127..129)++(127..129)++(127..129)),//31

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~reb_trans.(0,1,0,0,1,0,1,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((51..54)++(63..66)++(80..83)++(119!7)++(127..129)++(127..129)++(127..129)++(127..129)),//32

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~reb_trans.(0,1,0.33,0.33,0.33,0,1,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((51..54)++(63..66)++(80..83)++(119!7)++(127..129)++(127..129)++(127..129)++(127..129)),//33

		//reb low-high-grain
		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~reb_trans.(1,0,1,0,0,0.5,0.5,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((51..54)++(59..67)++(84..87)),//34

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~reb_trans.(1,0,0,1,0,0.5,0.5,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((51..54)++(59..67)++(84..87)),//35

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~reb_trans.(1,0,0,0,1,0.5,0.5,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((51..54)++(59..67)++(84..87)),//36

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~reb_trans.(1,0,0.33,0.33,0.33,0.5,0.5,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((51..54)++(59..67)++(84..87)),//37

		//reb low-high-noise
		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~reb_trans.(0,1,1,0,0,0.5,0.5,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((47..50)++(55..67)++(50..58)),//38

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~reb_trans.(0,1,0,1,0,0.5,0.5,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((47..50)++(55..67)++(50..58)),//39

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~reb_trans.(0,1,0,0,1,0.5,0.5,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((47..50)++(55..67)++(50..58)),//40

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~reb_trans.(0,1,0.33,0.33,0.33,0.5,0.5,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((47..50)++(55..67)++(50..58)),//41

		//reb NOR
		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~reb_trans.(0.5,0.5,0.33,0.33,0.33,0.5,0.5,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((43..66)++(67!4)),//42


		//START OF reb2
		//reb2 low-grain
		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~reb_trans2.(1,0,1,0,0,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),([0]++(43..54)++(59..62)++(68..71)++(138!2)++(139!2)),//43

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~reb_trans2.(1,0,0,1,0,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),([0]++(43..54)++(59..62)++(68..71)++(138!2)++(139!2)),//44

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~reb_trans2.(1,0,0,0,1,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),([0]++(43..54)++(59..62)++(68..71)++(138!2)++(139!2)),//45

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~reb_trans2.(1,0,0.33,0.33,0.33,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),
		([0]++(43..54)++(59..62)++(68..71)++(138!2)++(139!2)),//46

		//reb2 low-noise
		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~reb_trans2.(0,1,1,0,0,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),
		((47..50)++(63..66)++(72..75)++(118!7)++(124..126)++(124..126)++(124..126)++(124..126)),//47

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~reb_trans2.(0,1,0,1,0,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),
		((47..50)++(63..66)++(72..75)++(118!7)++(124..126)++(124..126)++(124..126)++(124..126)),//48

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~reb_trans2.(0,1,0,0,1,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),
		((47..50)++(63..66)++(72..75)++(118!7)++(124..126)++(124..126)++(124..126)++(124..126)),//49

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~reb_trans2.(0,1,0.33,0.33,0.33,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((47..50)++(63..66)++(72..75)++(118!7)++(124..126)++(124..126)++(124..126)++(124..126)),//50

		//reb2 high-grain
		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~reb_trans2.(1,0,1,0,0,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((51..62)++(76..79)++(140!2)++(141!2)),//51

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~reb_trans2.(1,0,0,1,0,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((51..62)++(76..79)++(140!2)++(141!2)),//52

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~reb_trans2.(1,0,0,0,1,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((51..62)++(76..79)++(140!2)++(141!2)),//53

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~reb_trans2.(1,0,0.33,0.33,0.33,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((51..62)++(76..79)++(140!2)++(141!2)),//54

		//reb2 high-noise
		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~reb_trans2.(0,1,1,0,0,0,1,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((51..54)++(63..66)++(80..83)++(119!7)++(127..129)++(127..129)++(127..129)),//55

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~reb_trans2.(0,1,0,1,0,0,1,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((51..54)++(63..66)++(80..83)++(119!7)++(127..129)++(127..129)++(127..129)),//56

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~reb_trans2.(0,1,0,0,1,0,1,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((51..54)++(63..66)++(80..83)++(119!7)++(127..129)++(127..129)++(127..129)),//57

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~reb_trans2.(0,1,0.33,0.33,0.33,0,1,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((51..54)++(63..66)++(80..83)++(119!7)++(127..129)++(127..129)++(127..129)),//58

		//reb2 low-high-grain
		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~reb_trans2.(1,0,1,0,0,0.5,0.5,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((51..54)++(59..67)++(84..87)),//59

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~reb_trans2.(1,0,0,1,0,0.5,0.5,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((51..54)++(59..67)++(84..87)),//60

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~reb_trans2.(1,0,0,0,1,0.5,0.5,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((51..54)++(59..67)++(84..87)),//61

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~reb_trans2.(1,0,0.33,0.33,0.33,0.5,0.5,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((51..54)++(59..67)++(84..87)),//62

		//reb2 low-high-noise
		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~reb_trans2.(0,1,1,0,0,0.5,0.5,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((47..50)++(55..67)++(50..58)),//63

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~reb_trans2.(0,1,0,1,0,0.5,0.5,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((47..50)++(55..67)++(50..58)),//64

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~reb_trans2.(0,1,0,0,1,0.5,0.5,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((47..50)++(55..67)++(50..58)),//65

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~reb_trans2.(0,1,0.33,0.33,0.33,0.5,0.5,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((47..50)++(55..67)++(50..58)),//66

		//reb2 NOR
		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~reb_trans2.(0.5,0.5,0.33,0.33,0.33,0.5,0.5,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((43..66)++(67!4)),//67


		//START harm
		//harm low-grain
		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~harm_trans.(1,0,1,0,0,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((93..104)++(109..112)++(138!2)++(139!2)++(43..46)++(118!3)),//68

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~harm_trans.(1,0,0,1,0,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((93..104)++(109..112)++(138!2)++(139!2)++(43..46)++(118!3)),//69

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~harm_trans.(1,0,0,0,1,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((93..104)++(109..112)++(138!2)++(139!2)++(43..46)++(118!3)),//70

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~harm_trans.(1,0,0.33,0.33,0.33,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((93..104)++(109..112)++(138!2)++(139!2)++(43..46)++(118!3)),//71

		//harm low-noise
		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~harm_trans.(0,1,1,0,0,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((93..100)++(105..108)++(113..116)++(118!7)++(124..126)++(124..126)++(124..126)++(124..126)++(47..50)),//72

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~harm_trans.(0,1,0,1,0,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((93..100)++(105..108)++(113..116)++(118!7)++(124..126)++(124..126)++(124..126)++(124..126)++(47..50)),//73

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~harm_trans.(0,1,0,0,1,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((93..100)++(105..108)++(113..116)++(118!7)++(124..126)++(124..126)++(124..126)++(124..126)++(47..50)),//74

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~harm_trans.(0,1,0.33,0.33,0.33,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((93..100)++(105..108)++(113..116)++(118!7)++(124..126)++(124..126)++(124..126)++(124..126)++(47..50)),//75

		//harm high-grain
		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~harm_trans.(1,0,1,0,0,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((101..112)++(105..108)++(140!2)++(141!2)++(93..96)++(51..54)++(119!3)),//76

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~harm_trans.(1,0,0,1,0,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((101..112)++(105..108)++(140!2)++(141!2)++(93..96)++(51..54)++(119!3)),//77

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~harm_trans.(1,0,0,0,1,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((101..112)++(105..108)++(140!2)++(141!2)++(93..96)++(51..54)++(119!3)),//78

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~harm_trans.(1,0,0.33,0.33,0.33,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((101..112)++(105..108)++(140!2)++(141!2)++(93..96)++(51..54)++(119!3)),//79

		//harm high-noise
		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~harm_trans.(0,1,1,0,0,0,1,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((105..108)++(97..100)++(113..116)++(119!7)++(127..129)++(127..129)++(127..129)++(127..129)++(55..58)),//80

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~harm_trans.(0,1,0,1,0,0,1,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((105..108)++(97..100)++(113..116)++(119!7)++(127..129)++(127..129)++(127..129)++(127..129)++(55..58)),//81

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~harm_trans.(0,1,0,0,1,0,1,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((105..108)++(97..100)++(113..116)++(119!7)++(127..129)++(127..129)++(127..129)++(127..129)++(55..58)),//82

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~harm_trans.(0,1,0.33,0.33,0.33,0,1,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((105..108)++(97..100)++(113..116)++(119!7)++(127..129)++(127..129)++(127..129)++(127..129)++(55..58)),//83

		//harm low-high-grain
		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~harm_trans.(1,0,1,0,0,0.5,0.5,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((109..112)++(117!3)++(93..96)++(101..104)),//84

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~harm_trans.(1,0,0,1,0,0.5,0.5,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((109..112)++(117!3)++(93..96)++(101..104)),//85

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~harm_trans.(1,0,0,0,1,0.5,0.5,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((109..112)++(117!3)++(93..96)++(101..104)),//86

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~harm_trans.(1,0,0.33,0.33,0.33,0.5,0.5,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((109..112)++(117!3)++(93..96)++(101..104)),//87

		//harm low-high-noise
		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~harm_trans.(
					0,1,1,0,0,0.5,0.5,sD,eD,gRp,out,pN:ptN))}),
			\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((113..116)++(105..108)++(97..100)++[117]),//88

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~harm_trans.(0,1,0,1,0,0.5,0.5,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((113..116)++(105..108)++(97..100)++[117]),//89

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~harm_trans.(0,1,0,0,1,0.5,0.5,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((113..116)++(105..108)++(97..100)++[117]),//90

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~harm_trans.(0,1,0.33,0.33,0.33,0.5,0.5,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((113..116)++(105..108)++(97..100)++[117]),//91

		//harm NOR
		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~harm_trans.(0.5,0.5,0.33,0.33,0.33,0.5,0.5,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((93..116)++(117!4)),//92


		//START harm2
		//harm2 low-grain
		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~harm_trans2.(1,0,1,0,0,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((93..104)++(109..112)++(138!2)++(139!2)++(43..46)++(118!3)),//93

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~harm_trans2.(1,0,0,1,0,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((93..104)++(109..112)++(138!2)++(139!2)++(43..46)++(118!3)),//94

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~harm_trans2.(1,0,0,0,1,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((93..104)++(109..112)++(138!2)++(139!2)++(43..46)++(118!3)),//95

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~harm_trans2.(1,0,0.33,0.33,0.33,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((93..104)++(109..112)++(138!2)++(139!2)++(43..46)++(118!3)),//96

		//harm2 low-noise
		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~harm_trans2.(0,1,1,0,0,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((93..100)++(105..108)++(113..116)++(118!7)++(124..126)++(124..126)++(124..126)++(124..126)++(47..50)),//97

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~harm_trans2.(0,1,0,1,0,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((93..100)++(105..108)++(113..116)++(118!7)++(124..126)++(124..126)++(124..126)++(124..126)++(47..50)),//98

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~harm_trans2.(0,1,0,0,1,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((93..100)++(105..108)++(113..116)++(118!7)++(124..126)++(124..126)++(124..126)++(124..126)++(47..50)),//99

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~harm_trans2.(0,1,0.33,0.33,0.33,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((93..100)++(105..108)++(113..116)++(118!7)++(124..126)++(124..126)++(124..126)++(124..126)++(47..50)),//100

		//harm2 high-grain
		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~harm_trans2.(1,0,1,0,0,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((101..112)++(105..108)++(140!2)++(141!2)++(93..96)++(51..54)++(119!3)),//101

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~harm_trans2.(1,0,0,1,0,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((101..112)++(105..108)++(140!2)++(141!2)++(93..96)++(51..54)++(119!3)),//102

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~harm_trans2.(1,0,0,0,1,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((101..112)++(105..108)++(140!2)++(141!2)++(93..96)++(51..54)++(119!3)),//103

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~harm_trans2.(1,0,0.33,0.33,0.33,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((101..112)++(105..108)++(140!2)++(141!2)++(93..96)++(51..54)++(119!3)),//104

		//harm2 high-noise
		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~harm_trans2.(0,1,1,0,0,0,1,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((105..108)++(97..100)++(113..116)++(119!7)++(127..129)++(127..129)++(127..129)++(127..129)++(55..58)),//105

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~harm_trans2.(0,1,0,1,0,0,1,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((105..108)++(97..100)++(113..116)++(119!7)++(127..129)++(127..129)++(127..129)++(127..129)++(55..58)),//106

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~harm_trans2.(0,1,0,0,1,0,1,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((105..108)++(97..100)++(113..116)++(119!7)++(127..129)++(127..129)++(127..129)++(127..129)++(55..58)),//107

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~harm_trans2.(0,1,0.33,0.33,0.33,0,1,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((105..108)++(97..100)++(113..116)++(119!7)++(127..129)++(127..129)++(127..129)++(127..129)++(55..58)),//108

		//harm2 low-high-grain
		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~harm_trans2.(1,0,1,0,0,0.5,0.5,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((109..112)++(117!3)++(93..96)++(101..104)),//109

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~harm_trans2.(1,0,0,1,0,0.5,0.5,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((109..112)++(117!3)++(93..96)++(101..104)),//110

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~harm_trans2.(1,0,0,0,1,0.5,0.5,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((109..112)++(117!3)++(93..96)++(101..104)),//111

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~harm_trans2.(1,0,0.33,0.33,0.33,0.5,0.5,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((109..112)++(117!3)++(93..96)++(101..104)),//112

		//harm2 low-high-noise
		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~harm_trans2.(0,1,1,0,0,0.5,0.5,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((113..116)++(105..108)++(97..100)++[117]),//113

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~harm_trans2.(0,1,0,1,0,0.5,0.5,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((113..116)++(105..108)++(97..100)++[117]),//114

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~harm_trans2.(0,1,0,0,1,0.5,0.5,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((113..116)++(105..108)++(97..100)++[117]),//115

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~harm_trans2.(0,1,0.33,0.33,0.33,0.5,0.5,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((113..116)++(105..108)++(97..100)++[117]),//116

		//harm2 NOR
		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~harm_trans2.(0.5,0.5,0.33,0.33,0.33,0.5,0.5,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((93..116)++(117!4)),//117


		//START ARP
		//arp
		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~arp_trans.(1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((121..123)++(121..123)++(121..123)++(121..123)++(124..126)++(124..126)++(124..126)++(22..25)++(72..75)++[2]),//118

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~arp_trans.(0,1,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((121..123)++(121..123)++(121..123)++(121..123)++(127..129)++(127..129)++(127..129)++(80..83)++(30..33)++[8]),//119

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~arp_trans.(0.5,0.5,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((121..123)),//120

		//START ARP2
		//arp 2
		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~arp_trans2.(1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((121..123)++(121..123)++(121..123)++(124..126)++(124..126)++(124..126)++(124..126)++(22..25)++(72..75)++[2]),//121

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~arp_trans2.(0,1,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((121..123)++(121..123)++(121..123)++(127..129)++(127..129)++(127..129)++(127..129)++(80..83)++(30..33)++[8]),//122

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~arp_trans2.(0.5,0.5,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((121..123)),//123

		//START ACEL
		//acel low
		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~acel_trans.(1,0,0,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((131..133)++(131..133)++(131..133)++(137..139)++(137..139)++[118]),//124

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~acel_trans.(0,1,0,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((131..133)++(131..133)++(131..133)++(137..139)++(137..139)++[118]),//125

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~acel_trans.(0,0,1,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((131..133)++(131..133)++(131..133)++(137..139)++(137..139)++[118]),//126

		//acel high
		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~acel_trans.(1,0,0,0,1,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((134..137)++(134..137)++(134..137)++[140,141]++[140,141]++[119]),//127

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~acel_trans.(0,1,0,0,1,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((134..137)++(134..137)++(134..137)++[140,141]++[140,141]++[119]),//128

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~acel_trans.(0,0,1,0,1,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((134..137)++(134..137)++(134..137)++[140,141]++[140,141]++[119]),//129

		//acel NOR
		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~acel_trans.(0.33,0.33,0.33,0.5,0.5,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),(131..137),//130

		//START ACEL2
		//acel2 low
		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~acel_trans2.(1,0,0,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((131..133)++(131..133)++(131..133)++(137..139)++(137..139)++[118]),//131

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~acel_trans2.(0,1,0,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((131..133)++(131..133)++(131..133)++(137..139)++(137..139)++[118]),//132

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~acel_trans2.(0,0,1,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((131..133)++(131..133)++(131..133)++(137..139)++(137..139)++[118]),//133

		//acel2 high
		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~acel_trans2.(1,0,0,0,1,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((134..137)++(134..137)++(134..137)++[140,141]++[140,141]++[119]),//134

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~acel_trans2.(0,1,0,0,1,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((134..137)++(134..137)++(134..137)++[140,141]++[140,141]++[119]),//135

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~acel_trans2.(0,0,1,0,1,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((134..137)++(134..137)++(134..137)++[140,141]++[140,141]++[119]),//136

		//acel2 NOR
		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~acel_trans2.(0.33,0.33,0.33,0.5,0.5,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),(131..137),//137


		//START sync
		//sync low
		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~sync_trans.(1,0,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((143..147)++(143..147)++(143..144)++(143..144)++(124..126)++(72..75)++(22..25)++(2!4)++(118!4)),//138

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~sync_trans.(0,1,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((143..147)++(143..147)++(143..144)++(143..144)++(124..126)++(72..75)++(22..25)++(2!4)++(118!4)),//139

		//sync high
		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~sync_trans.(1,0,0,1,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((143..147)++(143..147)++(145..146)++(145..146)++(127..129)++(119!4)++(80..83)++(30..33)++(8!4)),//140

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~sync_trans.(0,1,0,1,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((143..147)++(143..147)++(145..146)++(145..146)++(127..129)++(119!4)++(80..83)++(30..33)++(8!4)),//141

		//sync NOR
		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~sync_trans.(0.5,0.5,0.5,0.5,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),(143..147),//142

		//sync2 low
		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~sync_trans.(1,0,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((143..147)++(143..147)++(143..144)++(143..144)++(124..126)++(72..75)++(22..25)++(2!4)++(118!4)),//143

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~sync_trans.(0,1,1,0,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((143..147)++(143..147)++(143..144)++(143..144)++(124..126)++(72..75)++(22..25)++(2!4)++(118!4)),//144

		//sync2 high
		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~sync_trans.(1,0,0,1,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((143..147)++(143..147)++(145..146)++(145..146)++(127..129)++(119!4)++(80..83)++(30..33)++(8!4)),//145

		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~sync_trans.(0,1,0,1,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),((143..147)++(143..147)++(145..146)++(145..146)++(127..129)++(119!4)++(80..83)++(30..33)++(8!4)),//146

		//sync2 NOR
		Pfx(
			Plazy({
				Pfindur( rateSC* 60,~sync_trans.(0.5,0.5,0.5,0.5,sD,eD,gRp,out,pN:ptN))}),\fade_in,\in,out,\out,out,\fadeTime,(rateSC*60)+0.5,\group,~efG),(143..147),//147
])}
);

(
~c1 = NodeProxy.audio(s, 2);
~c2 = NodeProxy.audio(s, 2);
~c3 = NodeProxy.audio(s, 2);
~c4 = NodeProxy.audio(s, 2);
~c5 = NodeProxy.audio(s, 2);
~c6 = NodeProxy.audio(s, 2);
~c7 = NodeProxy.audio(s, 2);
);

/*
boo: boolean to determine wether the central channel is occupied by a pattern(false if the central channel will be used for recordings
genD: General duration of the section with the current number of channels
inSt: main initial chain state. (more likelihood for the chain to start from here)
inD: deviation of the initial state (where the chain starts, the  bigger the number the wider the choises for the initial state to be )
ent: Approximate starting time for the parts to begin/ range of starting points (as ent->genD st->0)
avD: mean duration of starting state of parameters and of development
durDev: deviation for durations of parameter states
frD: fragment duration (meaning duration on the chain state)
frDev: deviation on the duration of the chain state
*/


/*
~chanFrag
Function that creates a dictionary with seven entries, one for each possible number of channels for the instance of ~chanFrag. The channels are weighted so that they expand from a parrticular point.
General effects are also introduced here
*/

//Reminder of previous parameters:
//wPfsm={|wArr=#[],rateSC,sD,eD,gRp,out,ptN|

(/*dev for gauss random dist as ent->genD st->0, avD1 and D2 are the average duration for fragments. also consider that inst is an index of posInS*/
~chanFrag={|boo,genD,inSt,inD,ent,avD,durDev,frD,frDev|
	var arFsm,we,in,new,repFs,repwe,repin,parD=[],startD=[],d1=[],d2=[],envD,n2= [],inSts=[],posInS,bS,eS,fragD=[];
posInS=((0..8)++(18..42)++(71..92)++(118..120)++(124..130)++(138..142));//initial states
	inSt.postln;
	if((inSt-inD)<0){bS=0;}{bS=inSt-inD;};
	if(inSt+inD>(posInS.size-1)){eS=(posInS.size-1);}{eS=inSt+inD;};
	we=[0.2, 0.6, 0.4,0.8,0.4,0.6,0.2];//weights for occurrence of channels
	in=[0,1,2,3,4,5,6];
	new=[];
	envD= 25;
	genD=genD*60;
	(7).do({
		var st,end;
		st= rrand(0.0,(genD/ent));
		end= rrand(st+((genD-st)/3),genD);
		parD=parD.add(end-st);
		startD=startD.add(st);
		d1 =  d1.add(abs(gauss(avD,durDev)));
		d2 =  d2.add(abs(gauss(avD,durDev)));
		fragD =  fragD.add(abs(gauss(frD,frDev)));
		inSts = inSts.add(abs(choose((bS..eS))));
	});

	arFsm=[
		Pfindur( parD[1]*60,~wPfsm.([posInS[inSts[1]]],fragD[1],d1[1],d2[1],~inG,~ch2,2)),

		Pfindur( parD[2]*60,~wPfsm.([posInS[inSts[2]]],fragD[2],d1[2],d2[2],~inG,~ch3,3)),

		Pfindur( parD[3]*60,~wPfsm.([posInS[inSts[3]]],fragD[3],d1[3],d2[3],~inG,~ch4,4)),

		Pfindur( parD[4]*60,~wPfsm.([posInS[inSts[4]]],fragD[4],d1[4],d2[4],~inG,~ch5,5)),

		Pfindur( parD[5]*60,~wPfsm.([posInS[inSts[5]]],fragD[5],d1[5],d2[5],~inG,~ch6,6)),

		Pfindur( parD[6]*60,~wPfsm.([posInS[inSts[6]]],fragD[6],d1[6],d2[6],~inG,~ch7,7)),

	];

	if(boo==true){
		arFsm.removeAt(3);
		we.removeAt(3);
		in.remove(size(in)-1);
		startD.remove(3);
	};//see that in this case 7 chan is not possible
	repFs=arFsm.copy;
	repwe =we.copy;
	repin = in.copy;
	(1..size(repFs)).do({|num|num.do({//
	var ir=in.wchoose(we);
	var ts= arFsm[ir];
	var ws = we[ir];
	in.remove(size(in)-1);
	arFsm.remove(ts);
	we.remove(ws);
	new=new.add(ts);
});
 arFsm=repFs.copy;
 we=repwe.copy;
 in=repin.copy;
	new.do({|i,j| n2=n2.add(startD[j]);
	n2=n2.add(i);
});
	n2=n2.put(0,0);//tengo que hacer un caso especial para cuando bool es true esto podria modificarse dentro del if statement~dicCh=Dictionary.new

~dicCh.put("ch_%".format(num).asSymbol,n2);
new=[];
	n2=[]
});
}
);



(//from left to right
~ch1 =Bus.audio(s,1);
~ch2 =Bus.audio(s,1);
~ch3 =Bus.audio(s,1);
~ch4 =Bus.audio(s,1);
~ch5 =Bus.audio(s,1);
~ch6 =Bus.audio(s,1);
~ch7 =Bus.audio(s,1);
);

(
~inG = Group.new;
~efG= Group.after(~inG);
);

~dicCh=Dictionary.new;


(/*dev for gauss random dist as ent->genD st->0, avD1 and D2 are the average duration for fragments. also consider that inst is an index of posInS*/
~chanFrag={|boo,genD,inSt,inD,ent,avD,durDev,frD,frDev|
	var arFsm,we,in,new,repFs,repwe,repin,parD=[],startD=[],d1=[],d2=[],envD,n2= [],inSts=[],posInS,bS,eS,fragD=[];
posInS=((0..8)++(18..42)++(71..92)++(118..120)++(124..130)++(138..142));//initial states
	inSt.postln;
	if((inSt-inD)<0){bS=0;}{bS=inSt-inD;};
	if(inSt+inD>(posInS.size-1)){eS=(posInS.size-1);}{eS=inSt+inD;};
 we=[0.2, 0.6, 0.4,0.8,0.4,0.6,0.2];//weights for occurrence of channels
 in=[0,1,2,3,4,5,6];
 new=[];
envD= 25;
	genD=genD*60;
	(7).do({
		var st,end;
		st= rrand(0.0,(genD/ent));
		end= rrand(st+((genD-st)/3),genD);
		parD=parD.add(end-st);
		startD=startD.add(st);
		d1 =  d1.add(abs(gauss(avD,durDev)));
		d2 =  d2.add(abs(gauss(avD,durDev)));
		fragD =  fragD.add(abs(gauss(frD,frDev)));
		inSts = inSts.add(abs(choose((bS..eS))));
	});
	arFsm=[

		Pfx(Pfx(Pfindur( parD[0],~wPfsm.([posInS[inSts[0]]],fragD[0],d1[0],d2[0],~inG,~ch1,1)),\FreeV,\in,~ch1,\out,~ch1,\fadeTime,(parD[0])*60,\rC,1,\low,0.1,\high,1,\group,~efG),\Pan2,\in,~ch1,\out,0,\pos,-1,\fadeTime,(parD[0])*60,\group,~efG),

		Pfx(Pfx(Pfindur( parD[1],~wPfsm.([posInS[inSts[1]]],fragD[1],d1[1],d2[1],~inG,~ch2,2)),\FreeV,\in,~ch2,\out,~ch2,\fadeTime,(parD[1])*60,\rC,1,\low,0.1,\high,1,\group,~efG),\Pan2,\in,~ch2,\out,0,\pos,(-0.66),\fadeTime,(parD[1])*60,\group,~efG),

			Pfx(Pfx(Pfindur( parD[2],~wPfsm.([posInS[inSts[2]]],fragD[2],d1[2],d2[2],~inG,~ch3,3)),\FreeV,\in,~ch3,\out,~ch3,\fadeTime,(parD[2])*60,\rC,1,\low,0.1,\high,1,\group,~efG),\Pan2,\in,~ch3,\out,0,\pos,(-0.33),\fadeTime,(parD[2])*60,\group,~efG),


				Pfx(Pfx(Pfindur( parD[3],~wPfsm.([posInS[inSts[3]]],fragD[3],d1[3],d2[3],~inG,~ch4,4)),\FreeV,\in,~ch4,\out,~ch4,\fadeTime,(parD[3])*60,\rC,1,\low,0.1,\high,1,\group,~efG),\Pan2,\in,~ch4,\out,0,\pos,0,\fadeTime,(parD[3])*60,\group,~efG),

					Pfx(Pfx(Pfindur( parD[4],~wPfsm.([posInS[inSts[4]]],fragD[4],d1[4],d2[4],~inG,~ch5,5)),\FreeV,\in,~ch5,\out,~ch5,\fadeTime,(parD[4])*60,\rC,1,\low,0.1,\high,1,\group,~efG),\Pan2,\in,~ch5,\out,0,\pos,(0.33),\fadeTime,(parD[4])*60,\group,~efG),

						Pfx(Pfx(Pfindur( parD[5],~wPfsm.([posInS[inSts[5]]],fragD[5],d1[5],d2[5],~inG,~ch6,6)),\FreeV,\in,~ch6,\out,~ch6,\fadeTime,(parD[5])*60,\rC,1,\low,0.1,\high,1,\group,~efG),\Pan2,\in,~ch6,\out,0,\pos,(0.66),\fadeTime,(parD[5])*60,\group,~efG),

							Pfx(Pfx(Pfindur( parD[6],~wPfsm.([posInS[inSts[6]]],fragD[6],d1[6],d2[6],~inG,~ch7,7)),\FreeV,\in,~ch7,\out,~ch7,\fadeTime,(parD[6])*60,\rC,1,\low,0.1,\high,1,\group,~efG),\Pan2,\in,~ch7,\out,0,\pos,(1),\fadeTime,(parD[6])*60,\group,~efG)

	];

	if(boo==true){
		arFsm.removeAt(3);
		we.removeAt(3);
		in.remove(size(in)-1);
		startD.remove(3);
	};//see that in this case 7 chan is not possible
	repFs=arFsm.copy;
	repwe =we.copy;
	repin = in.copy;
	(1..size(repFs)).do({|num|num.do({//
	var ir=in.wchoose(we);
	var ts= arFsm[ir];
	var ws = we[ir];
	in.remove(size(in)-1);
	arFsm.remove(ts);
	we.remove(ws);
	new=new.add(ts);
});
 arFsm=repFs.copy;
 we=repwe.copy;
 in=repin.copy;
	new.do({|i,j| n2=n2.add(startD[j]);
	n2=n2.add(i);
});
	n2=n2.put(0,0);//tengo que hace un caso especial para cuando bool es true esto podria modificarse dentro del if statement
~dicCh.put("ch_%".format(num).asSymbol,n2);
new=[];
	n2=[]
});
}
);
~chanFrag.(false,15,2,2,8,12,5,0.6,2);


Ptpar(~dicCh.at(\ch_3),1).play;

)











