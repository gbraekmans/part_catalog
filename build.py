#!/usr/bin/env python3

import os, platform, subprocess

def openscad(input_file, output_file):
    # Find path to Openscad binary
    openscad_binary = "openscad"
    if platform.system() == "Windows":
        openscad_binary = os.environ.get("PROGRAMFILES(X86)") + \
                                         "\OpenSCAD\openscad.com"

    args = [
        "--viewall",
        "--autocenter", 
        "--colorscheme Part",
        "--render",
        "--projection o",
    ]
    
    cmd = [openscad_binary]
    cmd.extend(args)
    cmd.extend(["-o", output_file, input_file])
    
    subprocess.run(cmd)

for f in os.walk("."):
    print(f)