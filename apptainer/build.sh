#!/bin/bash
rm -r ugg.sif && \
apptainer build -B $(dirname $(pwd)):/code-dir ugg.sif ApptainerFile