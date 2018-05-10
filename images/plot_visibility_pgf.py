#!/usr/bin/env python
# encoding: utf-8

import os
import h5py
import json

from readimages.dpc.commandline_parser import commandline_parser
from readimages.utils.hadd import hadd

if __name__ == '__main__':
    args = commandline_parser.parse_args()

    input_file_name = hadd(args.file)
    if not os.path.exists(input_file_name):
        raise(OSError("{0} not found".format(input_file_name)))

    input_file = h5py.File(input_file_name, "r")
    object_name = "postprocessing/visibility_{0}".format(args.pixel)
    input_object = input_file[object_name]
    pixels = input_object[0]
    visibilities = input_object[1]
    dictionaries = [
        {"pixel": pixel,
         "visibility": visibility}
        for pixel, visibility in zip(pixels, visibilities)]
    output_file_name = input_file_name.replace(".hdf5", "_visibility.json")
    with open(output_file_name, "w") as outfile:
        json.dump(dictionaries, outfile)
