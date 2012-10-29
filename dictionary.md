---
title: Dictionary
author: Douglas Burke
date: October 29 2012
---

This is a somewhat ad-hoc dictionary of therms used in this research blog.

## ACIS

The Advanced Camera for Imaging and Spectroscopy (ACIS) is one of
two detectors on Chandra. There are 10 chips arranged into two arrays
-- ACIS-I and ACIS-S -- and for the purposes of this analysis
I am interested in the ACIS-I array. The other detector on Chandra
is the High-Resolution Camera (HRC).

[More information](http://cxc.harvard.edu/ciao/dictionary/acis.html)

## Chandra

The Chandra X-ray observatory is a satellite, orbiting Earth,
and has the best imaging capabilities of any X-ray observatory (in that
it provides sub-arcsecond Point-Spread Function for sources observed
near the center of the field of view).

More information: 

 * [Chandra Public website](http://chandra.harvard.edu/about/)

 * [Chandra Science website](http://cxc.harvard.edu/cdo/about_chandra/)

## Event

The ACIS and HRC detectors on Chandra record information on each
detected "event"; this should be a X-ray photon but can be due
to high-energy particles passing through Chandra, which act as
a source of background that we have to remove.

The basic quantities recorded for each event - at least when the
ACIS detector is used in its most common set up, as it was for the
data I am interested in - are time, position, and energy (these
values are actually derived from the recorded properties but
this difference does not really make any difference to the
research here).

 * **time** - each chip is read out once every $\sim 3.2$ seconds
   (a *frame*),
   which causes complications for sources bright enough to have
   multiple events within the same pixel in a frame. Fortunately
   for me the source I am interested is a lot fainter than this
   (I measure $\sim 60$ events, the observation time is
    $\sim 20000$ seconds, so the measured count rate is
    $60 / (20000 / 3.2)$, or $\sim 0.01$ count/frame).

 * **position** - each ACIS detector consists of 1024 by 1024 pixels,
   and the event location is recorded as the chip number and pixel
   location. The aspect solution is used to work out the celestial
   coordinates of each event (that is, where it came from on the
   sky). For bright sources near the center of the observation it
   is possible to use some of the data recorded about each event
   to improve the positional information - using the 
   [*EDSER* sub-pixel algorithm](http://cxc.harvard.edu/ciao/dictionary/subpix.html) - but for faint, off-axis sources such as the one I am
   interested in this algorithm is not needed.
   
 * **energy** - X-ray photons pass through the ACIS detector and
   some get absorbed, creating a cloud of electrons whose charge
   can be measured. Calibration can then convert this to an
   estimate of the energy of the incoming photon, but unfortunately
   this is not a unique conversion - for example see
   [page 18 of the "Introduction to X-ray Data Analysis" PDF by my boss](http://cxc.harvard.edu/ciao/workshop/feb10/talks/mcdowell.pdf) - which means that
   care should be taken using these values. When fitting a model
   to the spectrum - to try and determine what physical processes
   are important in the source - we have to use our knowledge of the
   instrument response to account for this complexity (in fact
   spectral analysis does not use energy but a related quantity,
   the pulse height, instead).

## Event file

The basic data file used in X-ray astronomy is the event file,
which is a time-sorted list of events that were recorded by the
detector.

## Point Spread Function (PSF)

The Point Spread Function describes the image created by
a point source observed by a system - in this case Chandra and ACIS.
On axis (that is, at the center of the image), the PSF is small,
with a width of $\sim 0.5$ arcseconds (the PSF size varies with
energy, so that low-energy photons have a smaller PSF than
high-energy photons). The PSF increases in size as you go
further off axis (that is, for sources further away from the
center of the image); this is relevant since the group I am
interested in is about 8 arcminutes away from the center of
the observation

More information:

 * [PSF definition](http://cxc.harvard.edu/acis/dictionary/psf.html)

 * [ACIS-I PSF size versus off-axis angle](http://cxc.harvard.edu/proposer/POG/html/chap4.html#fg:hrma_ee_offaxis_acisi) (note that this link takes you to the
   figure caption, you have to scroll up the page to get to the plots).

## Therm

A [unit of energy](http://en.wikipedia.org/wiki/Therm).
Also, a mis-spelling of the word *term*.


