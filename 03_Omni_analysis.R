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

#Omniscape is an implementatio of Circuitscape that runs on the 'Julia' platform
#to run julia needs to be in path - sudo ln -s /Applications/Julia-1.6.app/Contents/Resources/julia/bin/julia /usr/local/bin/julia
#use double quotes for Omniscape ini file

#Build ini file for Omniscape
OS_ini<-c("[Input files]",
          paste("resistance_file = ",file.path(ConnDir,"resistance_surface.tif")),
          paste("source_file = ", file.path(ConnDir,"source_surface.tif")),
          "[Options]",
          "block_size = 1",
          paste("radius = ",500/pixSize),
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

Julia_exe <- ('julia script.jl')
system(Julia_exe)


