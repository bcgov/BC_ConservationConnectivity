# Copyright 2021 Province of British Columbia
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and limitations under the License.

#########
#Notes on Omniscape
#Omniscape is an implementation of Circuitscape that runs on the 'Julia' platform
#Omniscape requires simple absolute directory names - no spaces or brackets, however complex relative directory names are fine
#Julia - must be installed and be in your path:
#sudo ln -s /Applications/Julia-1.6.app/Contents/Resources/julia/bin/julia /usr/local/bin/julia
#Ominscape uses an 'ini' file which requires "" not single ''

#Resistence and Sourcec rasters
#layer <- raster('/Users/darkbabine/ProjectLibrary/omni/test/input/resistance.asc')
#sites <- raster('/Users/darkbabine/ProjectLibrary/omni/test/input/source.asc')
#Reclassify as required

#Build ini file for Omniscape
OS_ini<-c("[Input files]",
          paste("resistance_file = ",file.path(ConnDir,"resistance_surface.tif")),
          paste("source_file = ", file.path(ConnDir,"source_surface.tif")),
          "[Options]",
          paste("block_size =", BlockSize),
          paste("radius = ",OmniRadius*10/pixSize),
          "buffer = 0",
          "source_threshold = 0",
          paste("project_name = ",file.path(ConnDir,RunDir),sep=''),
          "calc_flow_potential = true",
          "correct_artifacts = true",
          "source_from_resistance = false",
          "r_cutoff = 0.0",
          "write_raw_currmap = true",
          "calc_normalized_current = true",
          "write_as_tif = true",
          "parallelize = true")

#write ini file to disk at 'configlocation'
configLocation<-file.path(ConnDir,"config.ini")
cat(OS_ini, sep="\n", file=configLocation)

#write to jl file - that reads ini file and launches Omniscape on top of Julia
script <- c('using Omniscape',
            paste('run_omniscape(',configLocation,')',sep='"'))

#Julia is happier if jl file is in directory that Julia is launched from
cat(script, sep="\n", file="script.jl")

#Set up parallel processing
Julia_Threads<-'export JULIA_NUM_THREADS=4'
system(Julia_Threads)
#Launch Julia
Julia_exe <- ('julia script.jl')
system(Julia_exe)


