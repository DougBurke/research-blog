"""
This script is placed in the public domain.

Author: Douglas Burke
Date: November 2 2012

For more information see
   http://dougburke.github.com/research-blog/posts/2012-11-02-checks.html

"""

def dofit(elo=0.5, ehi=7.0, fixbgnd=True):
    """Fit group.pi with an absorbed APEC model over the
    energy range elo to ehi (in keV) using the Cash statistic.
    The background is modeled as a powerlaw + thermal model
    (both absorbed), fitted separately, then fixed before
    fitting the source (unless fixbgnd is False).
    """

    # Remove any settings
    clean()
    set_stat('cash')
    set_method('simplex')

    print("***")
    print("*** Fix bgnd before source fitting: {}".format(fixbgnd))
    print("*** Energy range: {} to {} keV".format(elo, ehi))
    print("***")

    load_data('group.pi')
    notice(elo, ehi)

    print("*** Fitting background")
    set_bkg_model(xsphabs.galabs * powlaw1d.bgnd)
    galabs.nh = 0.07
    freeze(galabs)

    fit_bkg()
    fit_bkg()

    set_bkg_model(galabs * (bgnd + xsmekal.gal))
    gal.kt = 0.2

    fit_bkg()
    fit_bkg()

    thaw(gal.abundanc)

    fit_bkg()
    fit_bkg()

    if fixbgnd:
        print("*** Freezing background")
        freeze(galabs)
        freeze(bgnd)
        freeze(gal)

    print("*** Fitting source")
    set_source(galabs * xsmekal.grp)
    grp.redshift = 0.069

    fit()
    fit()
    conf()

    print("*** now allowing metallicity to vary")
    thaw(grp.abundanc)
    fit()
    fit()
    conf()

def doplot():
    """Plot up the source and background fits and tweak the
    arrangement.
    """

    # Source + fit on the top plot, Background + its fit on the bottom
    plot("fit", "bkgfit")

    # Remove the vertical gap between the two plots
    adjust_grid_ygap(0)

    # Change properties in both plots at once
    current_plot('all')

    # Remove the plot titles
    set_plot_title('')

    # Connect the data with lines
    set_curve('crv1', ['line.style', 'solid', 'symbol.style', 'none'])

    # Move the X-axis on the top plot to the top
    current_plot('plot1')
    cid = ChipsId()
    cid.axis = 'ax1'
    cid.coord_sys = PLOT_NORM
    move_axis(cid, 0, 1, 0)

    # Move the label closer to the plot to avoid it falling off the top
    set_xaxis(['offset.perpendicular', 30])

    # Add labels to each plot in the top-right corner
    lopts = ['size', 16, 'coord_sys', PLOT_NORM, 'halign', 1]
    add_label(0.9, 0.9, 'Source', lopts)

    current_window('win2')
    add_label(0.9, 0.9, 'Background', lopts)
    
