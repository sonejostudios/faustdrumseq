// compile with: faust2jaqt -soundfile soundfiletest.dsp
// https://github.com/grame-cncm/faustlibraries/blob/41163d260be908778d638e1d0211626b8b22b7e7/soundfiles.lib

import("stdfaust.lib");

process =  k, hh, sn :> _,_;

looplength = 8;
bpm = hslider("bpm",120,40,240,1) *2;

beat_seq = ba.beat(bpm) : ba.pulse_countup_loop(looplength-1,1) : hbargraph("seq",0,looplength-1) ;
playhead(x) = (1:+~_*trigger(x): _*1); // _*1 is speed
trigger(x) = steps(x) : par(i,looplength, _<: (_>_@1)  : _) :> 1-_ ;
steps(x) = hgroup("%x", par(i,looplength, checkbox("%i"))) : par(i, looplength, _*(beat_seq==i) );


k =  playhead(1) : soundfile("label[url:/media/sda7/Programming/Faust/Vinz4/k.wav]",1) : !,!,!,_*k_vol<:_,_;
hh =  playhead(2) : soundfile("label[url:/media/sda7/Programming/Faust/Vinz4/hh.wav]",1) : !,!,!,_*hh_vol<:_,_;
sn =  playhead(3) : soundfile("label[url:/media/sda7/Programming/Faust/Vinz4/sn.wav]",1) : !,!,!,_*sn_vol<:_,_;


k_vol = vslider("/h:volume/1 k[style:knob]",1,0,2,0.01);
hh_vol = vslider("/h:volume/2 hh[style:knob]",1,0,2,0.01);
sn_vol = vslider("/h:volume/3 sn[style:knob]",1,0,2,0.01);
