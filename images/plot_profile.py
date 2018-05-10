#!/usr/bin/env python
# encoding: utf-8

import os
import sys
import h5py
import numpy as np

import matplotlib.pyplot as plt

def draw(input_file_name, absorption_image, dark_field_image):
    """Display the profiles with matplotlib."""
    absorption_profile = np.mean(absorption_image, axis=0)
    dark_field_profile = np.mean(dark_field_image, axis=0)
    dimension = 15
    plt.figure(figsize=(dimension, dimension * 0.618))
    axis = plt.axes()
    plt.xlabel("pixel")
    plt.ylabel("A, B")
    pixels = np.arange(absorption_profile.shape[0])
    plt.plot(pixels, absorption_profile,
            label="absorption $A$",
            color="black",
            linestyle="--",
            linewidth=2)
    plt.plot(pixels, dark_field_profile,
            label="dark field $B$",
            color="darkblue",
            linewidth=2)
    handles, labels = axis.get_legend_handles_labels()
    legend = plt.legend(handles, labels,
            loc="lower right")
    legend.get_frame().set_linewidth(0)
    axis.yaxis.tick_left()
    axis.xaxis.tick_bottom()
    axis.set_ylim(bottom=0, top=1.1)
    axis.set_xlim(left=0, right=absorption_profile.shape[0])
    plt.savefig('profile_{0}.svg'.format(
        os.path.splitext(os.path.basename(input_file_name))[0]))

input_file_name = sys.argv[1]

if not os.path.exists(input_file_name):
    raise(OSError("{0} not found".format(input_file_name)))

input_file = h5py.File(input_file_name, "r")
absorption_image_name = "postprocessing/absorption"
differential_phase_image_name = "postprocessing/differential_phase"
visibility_reduction_image_name = "postprocessing/visibility_reduction"

absorption_image = input_file[absorption_image_name]
visibility_reduction_image = input_file[visibility_reduction_image_name]

draw(input_file_name, absorption_image,
        visibility_reduction_image)
