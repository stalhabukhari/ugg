#!/bin/bash
apptainer build -B $(dirname $(pwd)):/code-dir ugg.sif ApptainerFile