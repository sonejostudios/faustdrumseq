// compile with: faust2jaqt -soundfile soundfiletest.dsp
// https://github.com/grame-cncm/faustlibraries/blob/41163d260be908778d638e1d0211626b8b22b7e7/soundfiles.lib

import("stdfaust.lib");

process = k, hh, sn :> _,_;

looplength = 16;
bpm = hslider("bpm",120,40,240,1)*2;

beat_seq = ba.beat(bpm) : ba.pulse_countup_loop(looplength-1,1) : hbargraph("seq",0,looplength-1);
playhead(x) = (1:+~_*trigger(x): _*1); // _*1 is speed
trigger(x) = steps(x) : par(i,looplength, _<: (_>_@1) : _) :> 1-_ ;
steps(x) = hgroup("%x", par(i,looplength, checkbox(" %2i "))) : par(i, looplength, _*(beat_seq==i));

vol(v) = !,!,_*v<:_,_;

//k = 0, playhead(1) : soundfile("label[url:k.wav]",1) : vol(k_vol);
//hh = 0, playhead(2) : soundfile("label[url:hh.wav]",1) : vol(hh_vol);
//sn = 0, playhead(3) : soundfile("label[url:sn.wav]",1) : vol(sn_vol);

// unsing a single 'soundfile':
sound = soundfile("label[url:{'k.wav';'hh.wav';'sn.wav'}]",1);
k = 0, playhead(1) : sound : vol(k_vol);
hh = 1, playhead(2) : sound : vol(hh_vol);
sn = 2, playhead(3) : sound : vol(sn_vol);


//volume gui
k_vol = vslider("/h:volume/1 k[style:knob]",1,0,2,0.01);
hh_vol = vslider("/h:volume/2 hh[style:knob]",1,0,2,0.01);
sn_vol = vslider("/h:volume/3 sn[style:knob]",1,0,2,0.01);
