#!/usr/bin/env python
# encoding: utf-8

import os
import sys
import h5py
import numpy as np
from scipy import stats
import matplotlib as mpl

mpl.use("pgf")

from pgf_style import pgf_with_rc_fonts

mpl.rcParams.update(pgf_with_rc_fonts)

import matplotlib.pyplot as plt


def draw(input_file_name, height, absorption_image,
         differential_phase_image,
         dark_field_image, fmt="pgf"):
    """Display the calculated images with matplotlib."""
    absorption_image_title = "assorbimento"
    differential_phase_image_title = "fase differenziale"
    dark_field_image_title = "riduzione di visibilit\\`a"
    f, (ax1, ax2, ax3) = plt.subplots(
        3, 1, sharex=True, figsize=(4.6, height), dpi=300)
    img1 = ax1.imshow(absorption_image,
                      cmap=plt.cm.Greys, aspect='auto')
    limits = stats.mstats.mquantiles(absorption_image,
                                     prob=[0.02, 0.98])
    img1.set_clim(*limits)
    ax1.axis("off")
    ax1.set_title(absorption_image_title, size="medium")
    img2 = ax2.imshow(differential_phase_image)
    limits = stats.mstats.mquantiles(differential_phase_image,
                                     prob=[0.02, 0.98])
    img2.set_clim(*limits)
    ax2.axis("off")
    ax2.set_title(differential_phase_image_title, size="medium")
    img3 = ax3.imshow(dark_field_image)
    ax3.set_title(dark_field_image_title, size="medium")
    ax3.axis("off")
    limits = stats.mstats.mquantiles(dark_field_image,
                                     prob=[0.02, 0.98])
    img3.set_clim(*limits)
    plt.tight_layout()
    if absorption_image.shape[0] == 1:
        f, (hist1, hist2, hist3) = plt.subplots(
            3, 1, sharex=True)
        hist1.hist(range(absorption_image.shape[1]),
                   weights=absorption_image.T, fc='w', ec='k')
        hist1.set_title("absorption")
        hist2.hist(range(differential_phase_image.shape[1]),
                   weights=differential_phase_image.T, fc='w', ec='k')
        hist2.set_title("differential phase")
        hist3.hist(range(dark_field_image.shape[1]),
                   bins=dark_field_image.shape[1],
                   weights=dark_field_image.T, fc='w', ec='k')
        hist3.set_title("visibility reduction")
    plt.tight_layout()
    plt.savefig('images_{0}.{1}'.format(
        os.path.splitext(os.path.basename(input_file_name))[0], fmt), dpi=300)

if __name__ == '__main__':
    input_file_name = sys.argv[1]
    height = float(sys.argv[2])

    if not os.path.exists(input_file_name):
        raise(OSError("{0} not found".format(input_file_name)))

    input_file = h5py.File(input_file_name, "r")
    absorption_image_name = "postprocessing/absorption"
    differential_phase_image_name = "postprocessing/differential_phase"
    visibility_reduction_image_name = "postprocessing/visibility_reduction"

    absorption_image = input_file[absorption_image_name]
    differential_phase_image = input_file[differential_phase_image_name]
    visibility_reduction_image = input_file[visibility_reduction_image_name]

    draw(input_file_name, height, absorption_image,
         differential_phase_image, visibility_reduction_image)
