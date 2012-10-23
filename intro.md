---
title: Introduction
author: Douglas Burke
date: October 23 2012
---

This is an experiment in "live blogging science" and an attempt to 
report on the X-ray properties of a system, which I am 
*assuming* (for now) to be a 
[galaxy group](http://en.wikipedia.org/wiki/Galaxy_groups_and_clusters#Groups_of_galaxies).
There are follow-up X-ray observations, by the
[XMM-Newton](http://xmm.esac.esa.int/)
and
[Suzaku](http://www.isas.jaxa.jp/e/enterp/missions/suzaku/index.shtml)
telescopes, which become public in the very-near future, which will hopefully
provide extra data on this group.

## The discovery image

I have been developing, as part of my job at the 
[Chandra X-ray Center](http://cxc.harvard.edu/), a set of scripts
to simplify the creation of exposure-corrected images from multiple
Chandra observations. In looking around for test systems, I noted the
recent set of observations on the galaxy cluster
[MACSJ0717.5+3745](http://chandra.harvard.edu/photo/2009/macs/),
which is a really interesting looking system, that have been
used to 
[detect a Dark-Matter filament in 3D](http://www.spacetelescope.org/news/heic1215/),
which is a really interesting result!
There have been two Chandra observations of this target; the first,
a relatively short "discovery" observation in 2001, followed by a 
longer observation in 2003.

If you have CIAO 4.4 installed, then you can quickly query the public
Chandra archive from the command line using:

~~~
% find_chandra_obsid '7 17 33.8' '37 45 20'
# obsid  sepn   inst grat   time    obsdate        piname              target
1655      0.6 ACIS-I NONE   20.1 2001-01-29 VANSPEYBROECK "MACS J0717.5+3745"
4200      0.6 ACIS-I NONE   59.9 2003-01-08       Ebeling    MACSJ0717.5+3745
~~~

or you can use the 
[Chandra Footprint Service](http://cxc.harvard.edu/cda/footprint/).

Downloading the data and re-processing (using
[Chandra CALDB 4.5.3](http://cxc.harvard.edu/ciao/releasenotes/ciao_4.4.1_release.html#HowCALDB4.5.3AffectsYourAnalysis)),
with the following:

~~~
% download_chandra_obsid 1655,4200
... screen output removed ...
% chandra_repro 1655,4200 outdir=
% merge_obs '*/repro/*evt*[ccd_id=0:3]' quick8/ bands=csc 
... a lot of screen output removed ...
~~~

creates three exposure-corrected images, in the
soft (0.5 to 1.2 keV), medium (1.2 to 2.0 keV),
and hard (2.0 to 7.0 keV) bands, which can be viewed using
ds9 (or other tool):

~~~
% cd quick8
% ds9 -scale sqrt -smooth -rgb -red soft_flux.img -green medium_flux.img -blue hard_flux.img &
~~~

to create 

![A three-color image of MACSJ0717.7+3745](/images/discovery.png)

which shows the cluster in the center, as the blue-white blob, and 
the target of this investigation, a faint red point source with possible
extended emission around it. The question is, is this really a group?
Note that in the image the red channel corresponds to the soft band, 
the green channel the medium band, and the blue channel is the hard band,
so the system is very soft (esentially no emission above 1.2 keV).

The coordinates of the point source are (as determined by eye, rather than
with a source-detection algorithm)
a Right Ascension of 07h 16m 44.3s and Declination of +37d 39' 55"
(J2000). Plugging these coordinates into 
NED, the [NASA/IPAC Extragalactic Database](http://ned.ipac.caltech.edu/),
return what looks to be an
[Elliptical galaxy](http://en.wikipedia.org/wiki/Elliptical_galaxy) detected in the 
[2MASS survey](http://en.wikipedia.org/wiki/2MASS).
Here are the
[NED search results](http://ned.ipac.caltech.edu/cgi-bin/objsearch?search_type=Near+Position+Search&in_csys=Equatorial&in_equinox=J2000.0&lon=7+16+44.3&lat=%2B37+39+55&radius=0.5&hconst=73&omegam=0.27&omegav=0.73&corr_z=1&z_constraint=Unconstrained&z_value1=&z_value2=&z_unit=z&ot_include=ANY&nmp_op=ANY&out_csys=Equatorial&out_equinox=J2000.0&obj_sort=Distance+to+search+center&of=pre_text&zv_breaker=30000.0&list_limit=5&img_stamp=YES)
for `2MASX J07164427+3739556`.

![The Digital-Sky Survey image of the galaxy](/images/dss.gif)

This image is taken from the
[Digital Sky Survey](http://ned.ipac.caltech.edu/cgi-bin/ex_refcode?refcode=1994DSS...1...0000%3A)
and was created by the
[NED DSS service](http://ned.ipac.caltech.edu/results/dssimage_22178.html) (I am not sure how long-lived
this URL is).
